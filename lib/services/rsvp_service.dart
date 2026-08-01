import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/rsvp_response.dart';
import 'rsvp_identity_service.dart';

/// RSVP persistence layer.
///
/// No backend is used: the client writes directly to Firestore. A deterministic
/// document ID (`eventId_guestId`) guarantees one document per guest. Re-submit
/// = update/merge the same document, never create duplicates.
///
/// `guestResponses` is write-only from the client (see firestore.rules:
/// `allow get/list: if false`) so visitors can never browse the guest list.
/// That means the total number of confirmed attendees can't be computed by
/// querying/summing that collection later. Instead, every save also applies
/// a delta to a small `stats/attendance` document (`totalGuests`,
/// `totalResponses`) that only ever holds two numbers — never guest names or
/// messages — so it's safe to read publicly.
class RsvpService {
  static final RsvpService instance = RsvpService._internal();
  RsvpService._internal();

  final CollectionReference<Map<String, dynamic>> _collection =
  FirebaseFirestore.instance.collection('guestResponses');

  final DocumentReference<Map<String, dynamic>> _statsDoc =
  FirebaseFirestore.instance.collection('stats').doc('attendance');

  Future<RsvpSaveResult> saveResponse(RsvpResponse response) async {
    final documentId = documentIdFor(
      eventId: response.eventId,
      guestId: response.guestId,
    );

    final newContribution =
    response.attendanceStatus == AttendanceStatus.attending ? response.guestCount : 0;

    final lastKnown = RsvpIdentityService.instance.getLastKnownContribution(
      eventId: response.eventId,
      guestId: response.guestId,
    );
    final isFirstSubmission = lastKnown == null;
    final guestDelta = newContribution - (lastKnown ?? 0);

    await _collection.doc(documentId).set(
      response.toFirestore(),
      SetOptions(merge: true),
    );

    // Only touch the running total once the guest doc itself is saved.
    // `FieldValue.increment` on a merge-set creates the field starting from
    // 0 if `stats/attendance` doesn't exist yet, so no separate "create"
    // step is needed.
    if (guestDelta != 0 || isFirstSubmission) {
      await _statsDoc.set({
        'totalGuests': FieldValue.increment(guestDelta),
        'totalResponses': FieldValue.increment(isFirstSubmission ? 1 : 0),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    RsvpIdentityService.instance.saveLastKnownContribution(
      eventId: response.eventId,
      guestId: response.guestId,
      contribution: newContribution,
    );

    return RsvpSaveResult(documentId: documentId, response: response);
  }

  /// Live "how many people are confirmed so far" total. Safe to show
  /// publicly — this document never contains names, messages, or anything
  /// guest-identifying.
  Stream<int> watchTotalConfirmedGuests() {
    return _statsDoc.snapshots().map((snap) {
      final value = snap.data()?['totalGuests'];
      return value is int ? value : (value as num?)?.toInt() ?? 0;
    });
  }

  Future<void> saveNotificationPreferences({
    required String documentId,
    required String? fcmToken,
    required List<Map<String, dynamic>> reminderSchedule,
  }) async {
    await _collection.doc(documentId).set({
      'notificationsEnabled': fcmToken != null && fcmToken.isNotEmpty,
      'fcmToken': fcmToken,
      'reminderSchedule': reminderSchedule,
      'notificationsUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String documentIdFor({required String eventId, required String guestId}) {
    String clean(String value) => value
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '_')
        .replaceAll(RegExp('_+'), '_');

    return '${clean(eventId)}_${clean(guestId)}';
  }
}