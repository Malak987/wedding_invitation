import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore values used by the RSVP pipeline and the admin dashboard.
///
/// `pending` covers invitations that have been seeded (or only partially
/// submitted) but not yet answered — they appear as "Pending" on the
/// dashboard. A normal guest submission is always `attending` or `declined`;
/// `pending` exists so the dashboard can report the "invited but not answered"
/// slice without storing any extra fields.
enum AttendanceStatus {
  attending,
  declined,
  pending;

  String get firestoreValue => switch (this) {
        AttendanceStatus.attending => 'attending',
        AttendanceStatus.declined => 'declined',
        AttendanceStatus.pending => 'pending',
      };

  /// Tolerant parser for the dashboard aggregation: an unknown / missing
  /// value is treated as `pending` so the guest still shows up (as pending)
  /// instead of silently vanishing from the totals.
  static AttendanceStatus fromFirestore(Object? raw) {
    switch (raw) {
      case 'attending':
        return AttendanceStatus.attending;
      case 'declined':
        return AttendanceStatus.declined;
      default:
        return AttendanceStatus.pending;
    }
  }
}

class RsvpResponse {
  final String eventId;
  final String guestId;
  final String guestName;
  final AttendanceStatus attendanceStatus;
  final int guestCount;
  final String message;
  final String language;
  final String deviceId;

  const RsvpResponse({
    required this.eventId,
    required this.guestId,
    required this.guestName,
    required this.attendanceStatus,
    required this.guestCount,
    required this.message,
    required this.language,
    required this.deviceId,
  });

  /// Only `attending` guests carry a head-count. `declined` and `pending`
  /// always store 0, so the dashboard can SUM(`guestCount`) directly when
  /// computing total attendees.
  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'guestId': guestId,
      'guestName': guestName,
      'attendanceStatus': attendanceStatus.firestoreValue,
      'guestCount': attendanceStatus == AttendanceStatus.attending ? guestCount : 0,
      'message': message.trim(),
      'language': language,
      'deviceId': deviceId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Reads a single normalized guest document back into a typed object.
  /// Used by [RsvpRepository] / the dashboard cubit — never exposed publicly.
  factory RsvpResponse.fromFirestore(
    String id,
    Map<String, dynamic>? data,
  ) {
    final map = data ?? const {};
    return RsvpResponse(
      eventId: (map['eventId'] ?? '').toString(),
      guestId: (map['guestId'] ?? id).toString(),
      guestName: (map['guestName'] ?? '').toString(),
      attendanceStatus: AttendanceStatus.fromFirestore(map['attendanceStatus']),
      guestCount: _readInt(map['guestCount']),
      message: (map['message'] ?? '').toString(),
      language: (map['language'] ?? '').toString(),
      deviceId: (map['deviceId'] ?? '').toString(),
    );
  }
}

int _readInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class RsvpSaveResult {
  final String documentId;
  final RsvpResponse response;

  const RsvpSaveResult({
    required this.documentId,
    required this.response,
  });
}
