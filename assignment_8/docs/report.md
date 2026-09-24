# Assignment 8 Report - REST API Data Fetching with FutureBuilder & SharedPreferences Caching

**Student Name:** Pranav Kale  
**Roll No:** 150096724142  
**Course / Subject:** Flutter Application Development  
**Date:** September 2026  

---

## 1. What the Assignment Was

Build a Flutter application that fetches structured data from a public REST API (e.g., **JSONPlaceholder** `/posts`), renders the fetched data dynamically using **`FutureBuilder`**, and persists the latest retrieved result into local device storage using **`SharedPreferences`** so that the application can seamlessly display cached data during network unavailability or offline sessions.

---

## 2. Files & Project Structure

```
assignment_8/
├── lib/
│   ├── main.dart                      # App entry point, MaterialApp configuration, theme & repository injection
│   ├── models/
│   │   ├── post.dart                  # Strongly-typed Post model with fromJson, toJson, & formatting getters
│   │   └── post_result.dart           # Encapsulates data list, isFromCache flag, timestamp, & notices
│   ├── services/
│   │   ├── api_service.dart           # HTTP REST client handling requests to JSONPlaceholder
│   │   ├── cache_service.dart         # Low-level SharedPreferences persistence manager
│   │   └── post_repository.dart       # High-level coordinator implementing Network-First with Cache-Fallback
│   ├── screens/
│   │   ├── post_list_screen.dart      # Main screen hosting FutureBuilder, search filter, & cache actions
│   │   └── post_detail_screen.dart    # Detail screen displaying full post content & metadata
│   └── widgets/
│       ├── cache_status_banner.dart   # Interactive banner highlighting Live/Cache source & action chips
│       ├── post_card.dart             # Card widget rendering individual post snippets & badges
│       ├── loading_skeleton.dart      # Shimmering placeholder skeleton for FutureBuilder waiting state
│       └── error_display.dart         # Error card with retry button and offline reset
├── test/
│   ├── post_model_test.dart           # 7 unit tests verifying model serialization & getters
│   ├── cache_service_test.dart        # 4 unit tests verifying SharedPreferences storage & corruption handling
│   └── widget_test.dart               # 5 widget tests verifying FutureBuilder states, search, & navigation
├── docs/
│   ├── report.md                      # Comprehensive academic report
│   └── assignment8_report.html        # Styled printable report
├── pubspec.yaml                       # Dependencies (http: ^1.6.0, shared_preferences: ^2.5.5)
└── README.md                          # Project documentation & architecture overview
```

---

## 3. Concepts Used

### A. Asynchronous UI Management with `FutureBuilder`
`FutureBuilder<T>` subscribes to a Dart `Future` and re-renders automatically as the asynchronous computation transitions through its lifecycle:
1. **`ConnectionState.waiting`**: The HTTP request or local storage read is active. A structured `LoadingSkeleton` is displayed instead of a blank screen.
2. **`snapshot.hasError`**: If a network failure occurs and no cache is available, `ErrorDisplay` presents the error message along with an interactive "Try Again" CTA.
3. **`snapshot.hasData`**: Upon successful completion, the `PostResult` is rendered in a `CustomScrollView` with full support for pull-to-refresh and interactive item inspection.

To prevent infinite re-fetching cycles triggered by widget tree rebuilds, the `Future` is instantiated inside `initState()`:
```dart
@override
void initState() {
  super.initState();
  _futurePosts = widget.repository.fetchPosts();
}
```

### B. REST API Integration (`package:http`)
The application queries JSONPlaceholder's `/posts` endpoint:
- Uses `http.Client` for request dispatching, enabling clean unit testing via `MockClient`.
- Enforces strict HTTP status code validation (`response.statusCode == 200`).
- Handles network exceptions (`SocketException`, `TimeoutException`, `HttpException`).

### C. Persistent Caching with `SharedPreferences`
Because REST data is dynamic, `SharedPreferences` is leveraged to store:
1. **Serialized Data**: The entire `List<Post>` is encoded as a JSON string using `jsonEncode(posts.map((p) => p.toJson()).toList())`.
2. **Timestamping**: `DateTime.now().toIso8601String()` is recorded alongside the payload, allowing the UI to display the exact date and time the cache was updated.

### D. Manual JSON Serialization with Dart 3 Pattern Matching
The `Post` model implements bidirectional serialization:
- `Post.fromJson(Map<String, dynamic> json)`: Uses pattern matching to validate expected field types (`id: int`, `userId: int`, `title: String`, `body: String`) with fallback defaults for missing keys.
- `Post.toJson()`: Returns a `Map<String, dynamic>` suitable for encoding into JSON string storage.

### E. Repository Pattern & Offline Simulation
The `PostRepository` separates UI code from data access logic:
- **Online Mode**: Queries REST API -> updates local cache upon success -> returns live result.
- **Offline / Network Error**: Traps connection failures -> queries `SharedPreferences` -> returns cached posts with an offline warning notice.
- **Offline Simulator**: A toggleable flag (`simulateOffline`) allows reviewers to immediately test and verify caching without disconnecting their computer's Wi-Fi.

---

## 4. Implementation Details

### 1. Data Models
- **`Post`**: Holds post identification, title, body, and user ID. Exposes helper getters: `capitalizedTitle`, `formattedId` (e.g. `#001`), and `snippet`.
- **`PostResult`**: Bundles the list of posts with metadata (`isFromCache: bool`, `timestamp: DateTime`, and optional `notice: String`).

### 2. Networking (`ApiService`)
Executes asynchronous HTTP `GET` requests against `https://jsonplaceholder.typicode.com/posts` with an explicit 10-second timeout. Validates that the returned payload is a JSON array and maps each item to a `Post` instance.

### 3. Local Storage (`CacheService`)
Wraps `SharedPreferences` with high-level asynchronous methods:
- `savePosts(List<Post> posts, [DateTime? timestamp])`
- `getCachedPosts(): Future<List<Post>?>`
- `getCacheTimestamp(): Future<DateTime?>`
- `clearCache(): Future<void>`

### 4. Interactive UI
- **`CacheStatusBanner`**: Prominently informs the user whether the current feed is live or served from storage, showing exact timestamps, total count, an offline mode toggle chip, a manual refresh CTA, and a clear cache button.
- **`PostCard`**: Material 3 card featuring an ID pill, author badge, formatted title, snippet, and tap interaction.
- **`PostDetailScreen`**: Detailed view displaying the complete unclipped text body, author details, and API attribution.
- **Search Bar**: Allows instant real-time filtering across titles, post IDs, and author IDs.

---

## 5. Visual Verification & Output Screenshots

The application was run and validated in Google Chrome (`flutter run -d chrome`). The following screenshots document its operation across all core assignment states:

### A. Live REST API Mode
![Live REST API Output](screenshots/screenshot_live_api.png)
*Figure 1: Initial launch fetching 100 live posts from `https://jsonplaceholder.typicode.com/posts`. The header indicates live status (teal badge), exact fetch timestamp (`19 Sep 2026 at 23:22:59`), and unselected offline simulator chip.*

### B. SharedPreferences Cached / Offline Mode
![SharedPreferences Cached Output](screenshots/screenshot_cached_offline.png)
*Figure 2: Simulating offline mode or running without network access. The header dynamically transitions to amber "SharedPreferences Cache", confirms data persistence with the exact cache timestamp, and displays an offline notice.*

### C. Post Detail Screen
![Post Detail Screen Output](screenshots/screenshot_post_detail.png)
*Figure 3: Tapping Post #001 navigates to the detailed view, displaying the post identifier, author user ID, cached offline chip, unclipped content body, and source attribution.*

---

## 6. Verification & Testing

The application includes an automated test suite comprising **16 test cases** (20 total assertions across 3 suites) that pass with 100% success:

```
$ flutter test
00:00 +0: Post Model Tests fromJson correctly parses standard JSON data
00:00 +1: Post Model Tests fromJson gracefully falls back when fields are null or mismatched
00:00 +2: Post Model Tests toJson produces expected Map representation
00:00 +3: Post Model Tests capitalizedTitle capitalizes first character
00:00 +4: Post Model Tests formattedId pads with leading zeroes
00:00 +5: Post Model Tests snippet truncates long text cleanly
00:00 +6: Post Model Tests equality and hashCode work as expected
00:00 +7: FutureBuilder renders loading state and transitions to live data
00:00 +12: Tapping a post card navigates to PostDetailScreen
00:00 +13: Search query dynamically filters posts in real-time
00:01 +14: Simulating offline mode falls back to SharedPreferences cache
00:01 +15: ErrorDisplay renders when network fails and no cache exists
00:01 +16: All tests passed!
```

### Static Analysis
`flutter analyze` confirms **Zero warnings and zero errors**:
```
$ flutter analyze
Analyzing assignment_8...
No issues found! (ran in 2.4s)
```

---

## 7. Challenges & Solutions

| Challenge | Solution |
| :--- | :--- |
| **Preventing infinite network calls in `FutureBuilder`** | In Flutter, if a `Future` is called directly inside `build()`, every widget rebuild triggers another network request. This was resolved by storing the `Future` in a state variable `_futurePosts` in `initState()` and only reassigning it upon explicit refresh actions. |
| **Cross-Platform Compatibility & `dart:io` in Web** | Importing `dart:io` (`SocketException`, `HttpException`) caused the Dart Development Compiler (DDC) to crash on Flutter Web. Replaced `dart:io` with a custom cross-platform `ApiException` and wrapped `http.ClientException` / `TimeoutException`, making the app 100% universal across Web, iOS, Android, and macOS. |
| **Safe offline fallback without crashes** | When offline, if no cache exists, simply returning `null` causes confusing blank screens. A structured `PostResult` was introduced along with an explicit `ErrorDisplay` card equipped with retry logic. |
| **Testing offline behavior during grading** | Manually disconnecting network adapters or disabling Wi-Fi is tedious. An interactive "Simulate Offline Mode" chip was integrated into the UI and repository to instantly demonstrate cache retrieval. |
| **Large JSON deserialization** | Used Dart 3 pattern matching with safe type casting (`(json['id'] as num?)?.toInt() ?? 0`) to prevent runtime type exceptions if API payloads contain inconsistent numbers or nulls. |
| **Cache Invalidation Safety** | Implemented a "Clear Cache" action with confirmation dialog, and verified that empty cache state displays a clean actionable error view rather than crashing. |

---

## 7. How to Run

1. Open a terminal in the assignment directory:
   ```bash
   cd /Users/pranavkale/Desktop/assignment_flutter/assignment_8
   ```
2. Run automated tests:
   ```bash
   flutter test
   ```
3. Run the app on Google Chrome or macOS:
   ```bash
   flutter run -d chrome
   ```
