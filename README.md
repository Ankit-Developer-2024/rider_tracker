# Rider Tracking App

A Flutter application that tracks a rider's trip from **Start Trip** to **End
Trip**, capturing live location, distance travelled, current speed, and
maximum speed — with GPS noise filtering and full offline support. Built
entirely on local data; no backend or API integration.

---

## Screens

### 1. Splash Screen
Shown on app launch while the app checks local storage for a trip that was
left active (e.g. the app was killed mid-trip). Routes automatically to
either the Home screen or straight back into the Active Trip screen,
depending on what it finds.

### 2. Home Screen
The landing screen when there's no trip in progress.
- **Start Trip** button — requests location permission (if not already
  granted) and begins tracking.
- **Trip History** access — lets the rider view every completed trip.

### 3. Active Trip Screen
Shown while a trip is running. Displays:
- Current speed, max speed, distance travelled, elapsed time
- Count of noisy/rejected GPS points filtered out during the trip
- A live map with the route drawn as a polyline, plus distinct markers for
  the trip's start location and current (live end) location
- **End Trip** button, guarded by a confirmation dialog before the trip is
  actually stopped
- After confirming, the rider is taken to the **Trip Summary** screen
- A **Start Trip Again** shortcut is also available for quickly beginning a
  new trip

### 4. Trip Summary Screen
Shown right after a trip ends (and reused when reopening a trip from
history). Displays:
- Trip start time, duration, max speed, average speed
- Count of noisy points filtered during the trip
- A map showing the full route as a polyline, with start and end location
  markers

### 5. Trip History Screen
A list of every trip the rider has completed, most recent first. Tapping a
trip opens its Trip Summary screen.

---

## Architecture

The app follows a clean, layered structure so tracking logic stays
independent of UI:

```
lib/
 ├─ models/        → Trip, LocationPoint — plain data classes, JSON-serializable
 ├─ services/       → LocationService (GPS), PersistenceService (local storage)
 ├─ state/          → TripController — trip lifecycle, GPS filtering, distance/speed calculation
 ├─ screens/        → Splash, Home, Active Trip, Trip Summary, Trip History
 ├─ widgets/        → Reusable UI (stat cards, status badges, map view)
 └─ theme/          → Centralized colors, typography
```

- **Models** hold no logic beyond derived getters (e.g. `distanceKm`,
  `currentSpeedKmh`) — they're just structured data.
- **Services** wrap platform/plugin APIs (`location`, `permission_handler`,
  local storage) behind a small interface, so the rest of the app never
  touches the plugin APIs directly.
- **TripController** is the single source of truth for trip state. It owns
  the GPS filtering algorithm, distance accumulation, and speed tracking,
  and notifies the UI on every change.
- **Screens** are thin — they render controller state and forward user
  actions (Start/End Trip) back to it. No business logic lives in the UI
  layer.

---

## Tech Stack & Key Decisions

| Concern | Choice | Why |
|---|---|---|
| Live & background location | `location` package | Minimal setup for both foreground and background tracking compared to alternatives — handles the Android foreground-service requirement and iOS background modes without extra native code |
| Permission handling | `permission_handler` | Clean, explicit permission request/check flow, works well alongside the `location` package |
| Map display | `flutter_map` (OpenStreetMap tiles) | Real interactive map with no API key or billing account required — appropriate for a local-data-only app with no backend to manage keys through |
| Distance calculation | Haversine (custom) + `geolocator`'s built-in calculation, both computed | Both are calculated on every accepted GPS point. `geolocator`'s ellipsoid-based `distanceBetween()` is used as the trip's actual recorded distance (more accurate, since it accounts for the Earth's real shape rather than treating it as a perfect sphere). The custom Haversine formula is computed alongside purely as a cross-validation check — at the short distances between consecutive GPS points the two should differ by a negligible amount, so a larger gap would flag a bug rather than a real geographic effect, and is logged when it occurs |
| Local persistence | Local storage (no backend) | The app is fully self-contained — all trip data, history, and in-progress trip state live on-device |

---

## GPS Noise & Unrealistic Jump Handling

Every incoming location update is evaluated **before** it's allowed to
affect distance, current speed, or max speed:

- **Low accuracy** readings (beyond a set threshold) are discarded.
- **Out-of-order timestamps** are discarded — a point can't be "before" the
  last accepted point.
- **Implausible speed** — if the distance between two consecutive points,
  divided by the time between them, implies a speed no rider could
  realistically reach, the point is flagged as an unrealistic GPS jump and
  excluded from distance/speed calculations.
- **Jitter** — very small movements below a minimum distance threshold
  (GPS noise while stationary) are ignored so distance doesn't creep up
  while the rider isn't moving.

Rejected/noisy points are **counted separately** and shown to the rider
(and in the trip summary) rather than silently dropped — this makes it
visible that filtering is actively happening, not just assumed.

### Distance Calculation — Cross-Validated with Two Methods
Distance between consecutive accepted GPS points is calculated using
**both** a custom Haversine formula and `geolocator`'s built-in
`distanceBetween()` on every point. The `geolocator` result (ellipsoid-
based, more accurate) is what's actually accumulated as the trip's
recorded distance. The Haversine result is computed alongside as a
sanity check — the two are compared, and a meaningful divergence between
them is logged, since at these short distances they should always be in
close agreement.

---

## Trip Continuity — Background vs. Killed State

These are two different situations, handled two different ways:

### Background (app minimized, screen locked — process still alive)
This is handled **automatically** by the `location` package's
foreground-service (Android) / background mode (iOS) setup — tracking
simply keeps running, with no special "resume" logic needed. As long as
the app process hasn't actually been terminated, location updates keep
flowing and get added to the trip continuously, screen locked or not.

### Killed state (app process terminated)
This is the case that actually needs the persistence/resume logic. Once
the process is killed, tracking cannot continue — there's no running code
left to receive location updates. To handle this without data loss:

- Trip state (distance, speed, route points, status) is written to local
  storage continuously **while the trip is active**, not just at the end.
- On the next app launch, the app checks local storage for a trip still
  marked active. If found, it restores that trip's data and **resumes
  tracking from where it left off**, picking up as though the rider had
  simply reopened the app mid-trip.
- This recovery only happens when the rider **manually reopens the app**
  — nothing tracks in the time between the kill and the reopen, since
  there's no process running to do so.

### Why full tracking through a killed state isn't attempted
Continuing to actively track location while the app process is fully
terminated (not just backgrounded) is intentionally not implemented:
**both the Google Play Store and Apple App Store restrict or reject apps
that attempt to revive themselves or run persistent tracking after being
force-killed by the user.** Android does not guarantee any code will run
after a user swipes an app away, and iOS explicitly does not allow an app
to relaunch itself after termination for background work. Building around
this would mean relying on OS-level behavior that is both unreliable and
against platform policy — so instead, the app guarantees **no data is
lost** and that tracking **resumes cleanly** the moment the rider reopens
the app, which is the practical, policy-compliant approach.

---

## Offline Support

Since the app has no backend, "offline support" is inherent rather than a
separate feature to build: every trip and its location points are written
to local storage as they're collected, not just when a trip ends. The app
never depends on network connectivity to function — it works identically
with or without internet access.

---

## Setup & Run Instructions

```bash
flutter pub get
flutter run
```

### Android
- Location permissions (foreground + background) are declared in
  `android/app/src/main/AndroidManifest.xml`.
- On first **Start Trip**, the app requests location permission via
  `permission_handler`. Background tracking requires the rider to grant
  "Allow all the time" when prompted (or via Settings on newer Android
  versions, which only offer this as a secondary step).

### iOS
iOS setup and testing was **not completed for this submission** — the
development environment used does not currently have access to an iOS
system (a Mac). The Android implementation is complete and fully tested.
That said, the iOS-side requirements are understood and documented so the
work could be completed with access to the right hardware:
- Location usage descriptions would need to be declared in
  `ios/Runner/Info.plist`
  (`NSLocationWhenInUseUsageDescription`,
  `NSLocationAlwaysAndWhenInUseUsageDescription`), along with the
  `location` background mode.
- The rider would be prompted for "When In Use" access first; background
  tracking requires upgrading to "Always Allow," which iOS handles as a
  separate, later prompt per Apple's guidelines.
- The `location` package supports iOS the same way it does Android, so no
  code changes beyond the `Info.plist` entries above should be required —
  this is a configuration/testing gap, not a missing implementation.

---

## Edge Cases — How Each Is Handled

| Edge case | Handling |
|---|---|
| **No internet connection during a trip** | Not applicable to functionality — the app has no backend dependency, so trips are tracked and stored fully offline regardless of connectivity. |
| **API timeout / server error** | Not applicable — no backend integration is implemented. |
| **Same action submitted multiple times** | Not applicable — no backend/API calls exist to duplicate. Locally, the End Trip action is guarded by a confirmation dialog to prevent accidental double-taps from ending a trip unintentionally. |
| **App killed or device restarts during an active trip** | Trip state is persisted to local storage continuously during tracking. On next app launch, if a trip is still marked active, the app resumes it and reattaches location tracking. Full tracking through a killed/terminated state without reopening the app is intentionally not attempted — see explanation above. |
| **Device is offline and later reconnects** | No effect on the app's behavior — since there's no sync step, reconnecting doesn't trigger anything, and no data was ever blocked from being recorded locally. |
| **GPS reports an unrealistic location or speed** | Filtered out by the accuracy/timestamp/plausible-speed checks described above, and counted separately as a rejected point rather than allowed to affect trip distance or speed. |
| **Server and device have different trip states** | Not applicable — there is no server-side trip state to diverge from. |

---

## Testing the Major Edge Cases

1. **GPS jump / unrealistic location** — On an emulator, use Extended
   Controls → Location to set a coordinate far from the current route,
   then set it back. Confirm the Active Trip screen's "noisy points
   filtered" count increases and the jump is not reflected in distance or
   max speed.
2. **App killed mid-trip** — Start a trip, let a few location points come
   in, then force-close the app from the recent-apps switcher (not just
   backgrounding it). Reopen the app and confirm it resumes the same trip
   with its previous distance/speed/route intact.
3. **Backgrounded (not killed) mid-trip** — Start a trip, press Home or
   lock the screen without force-closing the app, wait a minute, then
   reopen it. Confirm tracking continued the whole time with no gap in the
   route/distance — this should require no "resume," since the process
   never stopped.
4. **Permission denied** — Deny location permission when prompted and
   confirm the app shows a clear message instead of silently failing to
   track.
5. **Location services disabled** — Turn off the device's location toggle
   entirely before tapping Start Trip, and confirm the app detects this
   and prompts the rider rather than starting a trip with no data.
6. **Stationary GPS jitter** — Leave the device stationary during an
   active trip and confirm distance does not slowly increase from GPS
   noise (jitter filtering).
7. **Trip history accuracy** — Complete multiple trips and confirm each
   appears correctly in Trip History, with its summary matching what was
   shown at the time the trip ended.

---

## Notes / Limitations

- iOS was not built or tested in this submission due to lack of access to
  an iOS development environment (Mac) — see the iOS section above for
  what's needed to complete it.
- Background tracking reliability while the screen is locked is subject to
  platform-level battery optimization and OS scheduling on Android — a
  known constraint, not something an app can fully override.
- Full tracking continuity through a force-killed app state or device
  reboot is not implemented, by design, for the reasons explained above.
- The app uses `flutter_map` with OpenStreetMap's public tile server for
  the route map — suitable for development/demo use; a production
  deployment should move to a paid tile provider per OpenStreetMap's usage
  policy.
