import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/rsvp_response.dart';
import '../repository/rsvp_repository.dart';
import 'rsvp_stats_state.dart';

/// Owns all RSVP dashboard statistics.
///
/// Subscribes to [RsvpRepository.watchAllResponses] (a single Firestore
/// snapshot listener) and **recomputes every metric on each change**, then
/// emits a new [RsvpStatsState]. No values are stored in Firestore; the
/// aggregation lives entirely here.
///
/// Because the heavy lifting is a pure function ([_aggregate]), the cubit is
/// trivial to unit-test by feeding it a hand-built `List<RsvpResponse>`.
class RsvpStatsCubit extends Cubit<RsvpStatsState> {
  final RsvpRepository _repository;
  StreamSubscription<List<RsvpResponse>>? _subscription;

  RsvpStatsCubit([RsvpRepository? repository])
      : _repository = repository ?? RsvpRepository.instance,
        super(const RsvpStatsState.initial());

  /// Begin listening to Firestore. Idempotent — safe to call more than once.
  void start() {
    if (_subscription != null) return;
    _subscription = _repository.watchAllResponses().listen(
          _onData,
          onError: _onError,
        );
  }

  void _onData(List<RsvpResponse> responses) {
    if (isClosed) return;
    emit(_aggregate(responses));
  }

  void _onError(Object error) {
    if (isClosed) return;
    emit(state.copyWith(loading: false, error: _describe(error)));
  }

  /// Pure aggregation over the full guest list. One pass, O(n).
  ///
  /// - Total Invitations      = responses.length
  /// - Confirmed Guests       = count(attendanceStatus == attending)
  /// - Declined Guests        = count(attendanceStatus == declined)
  /// - Pending Guests         = count(attendanceStatus == pending)
  /// - Total Attendees        = SUM(guestCount) over attending docs
  /// - Average Guests/Invite  = totalAttendees / totalInvitations
  RsvpStatsState _aggregate(List<RsvpResponse> responses) {
    var confirmed = 0;
    var declined = 0;
    var pending = 0;
    var totalAttendees = 0;

    for (final response in responses) {
      switch (response.attendanceStatus) {
        case AttendanceStatus.attending:
          confirmed++;
          totalAttendees += response.guestCount;
          break;
        case AttendanceStatus.declined:
          declined++;
          break;
        case AttendanceStatus.pending:
          pending++;
          break;
      }
    }

    final totalInvitations = responses.length;
    final average = totalInvitations == 0 ? 0.0 : totalAttendees / totalInvitations;

    return RsvpStatsState(
      totalInvitations: totalInvitations,
      confirmedGuests: confirmed,
      declinedGuests: declined,
      pendingGuests: pending,
      totalAttendees: totalAttendees,
      averageGuestsPerInvitation: average,
      loading: false,
      error: null,
    );
  }

  String _describe(Object error) {
    final text = error.toString();
    if (text.contains('permission-denied') || text.contains('PERMISSION_DENIED')) {
      return 'permission-denied';
    }
    return 'fetch-error';
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
