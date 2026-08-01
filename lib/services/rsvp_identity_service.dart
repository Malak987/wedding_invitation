import 'dart:math';

import '../utils/web_runtime_stub.dart'
if (dart.library.html) '../utils/web_runtime.dart';

class GuestIdentity {
  final String guestId;
  final String guestName;
  final String deviceId;

  const GuestIdentity({
    required this.guestId,
    required this.guestName,
    required this.deviceId,
  });
}

/// Resolves RSVP identity without authentication/backend.
///
/// Recommended invitation URL format:
/// `https://sofamirna-2026.web.app/?guestId=guest_120&guestName=Ahmed`
///
/// If the link does not include a guest id, the app creates a stable browser
/// guest id and device id in localStorage. This still guarantees one Firestore
/// document per browser/device; for strict one-response-per-invited-guest,
/// send personalized links with a `guestId` parameter.
class RsvpIdentityService {
  static final RsvpIdentityService instance = RsvpIdentityService._internal();
  RsvpIdentityService._internal();

  static const _deviceStorageKey = 'engagement_rsvp_device_id';
  static const _guestStorageKey = 'engagement_rsvp_guest_id';
  static const _guestNameStorageKey = 'engagement_rsvp_guest_name';
  static const _lastContributionPrefix = 'engagement_rsvp_last_contribution_';

  final Random _random = Random.secure();

  /// The head-count this guest last successfully contributed to the running
  /// attendance total for [eventId] (0 if declined or never submitted).
  /// Returns null if this guest has never submitted before, so the caller
  /// can tell "first submission" apart from "resubmission with 0 people".
  int? getLastKnownContribution({required String eventId, required String guestId}) {
    final raw = WebRuntime.readStorage(_lastContributionKey(eventId, guestId));
    if (raw == null) return null;
    return int.tryParse(raw);
  }

  void saveLastKnownContribution({
    required String eventId,
    required String guestId,
    required int contribution,
  }) {
    WebRuntime.writeStorage(_lastContributionKey(eventId, guestId), contribution.toString());
  }

  String _lastContributionKey(String eventId, String guestId) =>
      '$_lastContributionPrefix${eventId}_$guestId';

  void saveGuestName(String guestName) {
    final cleanName = guestName.trim();
    if (cleanName.isNotEmpty) {
      WebRuntime.writeStorage(_guestNameStorageKey, cleanName);
    }
  }

  GuestIdentity resolve() {
    final query = Uri.base.queryParameters;

    final queryGuestId = _firstNonEmpty([
      query['guestId'],
      query['guest_id'],
      query['gid'],
      query['id'],
    ]);

    final queryGuestName = _firstNonEmpty([
      query['guestName'],
      query['guest_name'],
      query['name'],
    ]);

    final deviceId = _getOrCreateStoredValue(_deviceStorageKey, _newDeviceId);

    final guestId = queryGuestId?.trim().isNotEmpty == true
        ? queryGuestId!.trim()
        : _getOrCreateStoredValue(_guestStorageKey, _newGuestId);

    if (queryGuestId != null && queryGuestId.trim().isNotEmpty) {
      WebRuntime.writeStorage(_guestStorageKey, queryGuestId.trim());
    }

    final guestName = queryGuestName?.trim().isNotEmpty == true
        ? queryGuestName!.trim()
        : (WebRuntime.readStorage(_guestNameStorageKey)?.trim().isNotEmpty == true
        ? WebRuntime.readStorage(_guestNameStorageKey)!.trim()
        : 'Guest');

    if (queryGuestName != null && queryGuestName.trim().isNotEmpty) {
      WebRuntime.writeStorage(_guestNameStorageKey, queryGuestName.trim());
    }

    return GuestIdentity(
      guestId: _cleanForField(guestId),
      guestName: guestName,
      deviceId: deviceId,
    );
  }

  String _getOrCreateStoredValue(String key, String Function() generator) {
    final stored = WebRuntime.readStorage(key);
    if (stored != null && stored.trim().isNotEmpty) return stored.trim();

    final value = generator();
    WebRuntime.writeStorage(key, value);
    return value;
  }

  String _newGuestId() => 'guest_${_randomToken(14)}';

  String _newDeviceId() => 'device_${_randomToken(24)}';

  String _randomToken(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(chars[_random.nextInt(chars.length)]);
    }
    return '${DateTime.now().millisecondsSinceEpoch}_${buffer.toString()}';
  }

  String _cleanForField(String value) {
    final cleaned = value.trim().replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '_');
    return cleaned.isEmpty ? _newGuestId() : cleaned;
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) return value;
    }
    return null;
  }
}