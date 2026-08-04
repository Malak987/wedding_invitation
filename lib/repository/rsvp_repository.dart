import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/rsvp_response.dart';

/// Single source of truth for RSVP persistence (data-access layer only).
///
/// Design goals (per the dashboard requirements):
/// - **Normalized**: the only stored data is one document per guest in
///   `guestResponses`. No `totalGuests`, no `stats/attendance`, no running
///   totals, nothing duplicated. Every dashboard number is *derived* by
///   [RsvpStatsCubit].
/// - **One listener**: [watchAllResponses] exposes a single *broadcast*
///   stream over `guestResponses.snapshots()`. The cubit (and any future
///   consumer) share that one Firestore connection, so adding more widgets
///   never multiplies reads.
/// - **No business logic here**: this layer only reads/writes raw documents.
///   All statistics live in the cubit, keeping the repository a thin,
///   testable boundary.
class RsvpRepository {
  static final RsvpRepository instance = RsvpRepository._internal();
  RsvpRepository._internal();

  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('guestResponses');

  // Lazily created, shared broadcast stream — see [watchAllResponses].
  Stream<List<RsvpResponse>>? _allResponsesStream;

  /// Realtime stream of every guest document.
  ///
  /// No `orderBy` is applied on purpose: an `orderBy` on a field would
  /// *exclude* documents that are missing that field (e.g. pre-seeded
  /// `pending` invitations created from the console), which would silently
  /// skew the dashboard totals. We need *every* document to count.
  ///
  /// The underlying `snapshots()` is wrapped in `asBroadcastStream()` so a
  /// single Firestore listener serves every subscriber.
  Stream<List<RsvpResponse>> watchAllResponses() {
    return _allResponsesStream ??= _collection
        .snapshots()
        .map((query) => query.docs
            .map((doc) => RsvpResponse.fromFirestore(doc.id, doc.data()))
            .toList(growable: false))
        .asBroadcastStream();
  }

  /// Upserts one guest's response into their deterministic document
  /// (`eventId_guestId`). Re-submission = merge the same doc, never a
  /// duplicate. No totals are maintained: the dashboard recomputes from the
  /// realtime stream above.
  Future<RsvpSaveResult> saveResponse(RsvpResponse response) async {
    final documentId = documentIdFor(
      eventId: response.eventId,
      guestId: response.guestId,
    );

    await _collection.doc(documentId).set(
          response.toFirestore(),
          SetOptions(merge: true),
        );

    return RsvpSaveResult(documentId: documentId, response: response);
  }

  Future<void> saveNotificationPreferences({
    required String documentId,
    required String? fcmToken,
    required List<Map<String, dynamic>> reminderSchedule,
  }) async {
    await _collection.doc(documentId).set(
      {
        'notificationsEnabled': fcmToken != null && fcmToken.isNotEmpty,
        'fcmToken': fcmToken,
        'reminderSchedule': reminderSchedule,
        'notificationsUpdatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  String documentIdFor({required String eventId, required String guestId}) {
    String clean(String value) => value
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '_')
        .replaceAll(RegExp('_+'), '_');

    return '${clean(eventId)}_${clean(guestId)}';
  }
}
