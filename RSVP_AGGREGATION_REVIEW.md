# RSVP Aggregation — Architecture Review & Refactor

## What was wrong before

| Problem | Where | Why it mattered |
|---|---|---|
| **Stored aggregate (`totalGuests`)** | `RsvpService.saveResponse()` did `FieldValue.increment(...)` on a separate `stats/attendance` doc | Duplicated data that can drift (no transaction, multi-device races). The requirement forbids this. |
| **No `pending` status** | `AttendanceStatus` enum had only `attending` / `declined` | "Pending Guests" couldn't exist. |
| **Counter read the aggregate, not the source of truth** | `watchTotalConfirmedGuests()` read `stats/attendance` | The number could desync from the actual guest documents. |
| **No Repository / Cubit** | all logic in `RsvpService` | Aggregation logic mixed into the write path. |
| **localStorage delta hack** | `getLastKnownContribution` / `saveLastKnownContribution` | Existed only to compute the increment; fragile and unnecessary. |

## New architecture (normalized, derived, realtime)

```
Firestore  ──(snapshots)──►  RsvpRepository        (data access only)
                                   │
                                   ▼  Stream<List<RsvpResponse>>  (broadcast, 1 listener)
                             RsvpStatsCubit         (pure aggregation)
                                   │
                                   ▼  RsvpStatsState
                          RsvpDashboardSection + RSVP counter   (BlocBuilder)
```

**Every dashboard number is computed at runtime — nothing is stored.**

### Files
- `lib/repository/rsvp_repository.dart` — single source of truth for reads/writes. Exposes **one** broadcast `snapshots()` stream so the cubit + every widget share **one** Firestore connection (read-optimized).
- `lib/cubit/rsvp_stats_state.dart` — immutable state.
- `lib/cubit/rsvp_stats_cubit.dart` — subscribes to the repository and recomputes **all** metrics on every change. Aggregation is a pure O(n) function (`_aggregate`), so it is trivially unit-testable.
- `lib/dashboard/rsvp_dashboard.dart` — live dashboard widget (6 metrics).
- `lib/models/rsvp_response.dart` — added `pending` + a `fromFirestore` parser.

### The six metrics (all derived)
| Metric | Formula |
|---|---|
| Total Invitations | `documents.length` |
| Confirmed Guests | count where `attendanceStatus == 'attending'` |
| Declined Guests | count where `attendanceStatus == 'declined'` |
| Pending Guests | count where `attendanceStatus == 'pending'` (unknown/missing → pending) |
| Total Attendees | `SUM(guestCount)` over `attending` docs |
| Average Guests / Invitation | `totalAttendees / totalInvitations` (swap denominator for `confirmedGuests` to get avg party size among accepters) |

### Removed
- `lib/services/rsvp_service.dart` (replaced by the repository)
- the `stats/attendance` document and all `FieldValue.increment` logic
- `getLastKnownContribution` / `saveLastKnownContribution` from `RsvpIdentityService`

## Firestore rules (`firestore.rules`)
- Deleted the `stats/attendance` match.
- `attendanceStatus` now allows `attending | declined | pending`; `guestCount` must be `0` for declined/pending and `1–5` for attending.
- `guestResponses` reads (`list`/`get`) are now **admin-only**; guests can still create/update only their own deterministic doc.

## ⚠️ Important: read access & the public counter
Because the dashboard now computes from the **normalized** collection client-side, whoever views it must be allowed to read `guestResponses`. The rules gate this behind an **admin custom claim**:

```bash
# Node Admin SDK — make the couple an admin
admin.auth().setCustomUserClaims(uid, { admin: true })
```

Then sign that user in (Firebase Auth) on the device where the dashboard is used.

**Public site effect:** anonymous visitors can no longer read an aggregate, so the public "X guests confirmed so far" chip only renders for admins (it is hidden otherwise). This is the unavoidable consequence of *both* "no stored total" *and* "don't expose the guest list". If you want a public live count again, the secure options are:
1. A callable **Cloud Function** that returns the computed `totalAttendees` (derived on demand — not a stored field), or
2. Firestore **`count()` aggregation** behind a rule that allows the aggregate but still denies listing document bodies (note: a plain `count()` requires list permission, so option 1 is safer).

## Run
```bash
flutter pub get            # pulls in flutter_bloc
flutter analyze
flutter build web --release
firebase deploy --only firestore:rules,hosting
```
