/// Immutable snapshot of every dashboard statistic.
///
/// All fields are **derived** from the normalized `guestResponses`
/// collection — nothing here is read from a stored aggregate document, so
/// these numbers can never drift out of sync with the guest data.
class RsvpStatsState {
  /// Number of documents = number of invitations.
  final int totalInvitations;

  /// Documents where `attendanceStatus == 'attending'`.
  final int confirmedGuests;

  /// Documents where `attendanceStatus == 'declined'`.
  final int declinedGuests;

  /// Documents where `attendanceStatus == 'pending'` (or unknown/missing).
  final int pendingGuests;

  /// SUM(`guestCount`) across every `attending` document.
  final int totalAttendees;

  /// `totalAttendees / totalInvitations` (0.0 when there are no invitations).
  ///
  /// To track the average party size *among those who accepted*, swap the
  /// denominator for `confirmedGuests`.
  final double averageGuestsPerInvitation;

  final bool loading;
  final String? error;

  const RsvpStatsState({
    required this.totalInvitations,
    required this.confirmedGuests,
    required this.declinedGuests,
    required this.pendingGuests,
    required this.totalAttendees,
    required this.averageGuestsPerInvitation,
    required this.loading,
    required this.error,
  });

  const RsvpStatsState.initial()
      : totalInvitations = 0,
        confirmedGuests = 0,
        declinedGuests = 0,
        pendingGuests = 0,
        totalAttendees = 0,
        averageGuestsPerInvitation = 0,
        loading = true,
        error = null;

  RsvpStatsState copyWith({
    int? totalInvitations,
    int? confirmedGuests,
    int? declinedGuests,
    int? pendingGuests,
    int? totalAttendees,
    double? averageGuestsPerInvitation,
    bool? loading,
    String? error,
  }) {
    return RsvpStatsState(
      totalInvitations: totalInvitations ?? this.totalInvitations,
      confirmedGuests: confirmedGuests ?? this.confirmedGuests,
      declinedGuests: declinedGuests ?? this.declinedGuests,
      pendingGuests: pendingGuests ?? this.pendingGuests,
      totalAttendees: totalAttendees ?? this.totalAttendees,
      averageGuestsPerInvitation:
          averageGuestsPerInvitation ?? this.averageGuestsPerInvitation,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
