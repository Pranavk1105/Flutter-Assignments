# 🔧 Async & Null Safety Showcase — Dart Assignment 2

A modular Dart console application showcasing asynchronous programming (`Future`, `async/await`), comprehensive Null Safety (`Type?`, `??`, `??=`, `?.`, `!`, `late final`, type promotion), and robust error handling (`Never`, custom exceptions, `try-catch`, sealed classes with pattern matching).

---

## 🚀 Architecture & Key Features

- **Asynchronous Flow (`Future` & `async/await`)**:
  - Simulates non-blocking REST API calls with `Future.delayed()`.
  - Realistic latency handling across client, service, and entity layers.
- **Null Safety in Practice**:
  - Resilient parsing of raw Map payloads with missing or explicit `null` fields.
  - Safe fallbacks using null-coalescing (`??`) and null-coalescing assignment (`??=`).
  - Conditional member access via `?.` and safe unwrapping with `!` on promoted fields.
  - Immutable lazy computation with `late final`.
- **Exhaustive State Modelling**:
  - Sealed class hierarchy (`NetworkResponse<T>`: `ResponseSuccess`, `ResponseFailure`, `ResponseNoContent`).
  - Dart 3 Pattern Matching for compile-time exhaustive state handling.
  - Custom `NetworkException` and `Never` return type helper for validation errors.
- **Functional & Generic Programming**:
  - Generic mapper `mapCollection<S, U>` for batch collection transformations.
  - Higher-order functions and state-capturing closures for sequential logging.

---

## 📁 Project Structure

```
Async_NullSafety_Demo/
├── README.md                    # Project overview, concept mapping & execution guide
├── assets/
│   └── terminal_output.png      # Terminal execution output screenshot
└── lib/
    ├── user_account.dart        # Entity model with nullable fields, late final & safe parsing
    ├── network_response.dart    # Sealed class hierarchy (Success, Failure, NoContent)
    ├── simulated_api_client.dart # Async network client simulating delay, 200/404/500
    ├── exception_utils.dart     # Custom NetworkException and Never return type helpers
    ├── collection_helpers.dart  # Generic mappers & stateful logging closures
    ├── app_controller.dart      # Orchestrates and showcases all 5 demonstration scenarios
    └── main.dart                # Main executable entry point
```

---

## 🛠️ Concepts Demonstrated (from `dart_basics-main`)

| Concept | File Reference in `dart_basics-main` | Implementation in This Project |
| :--- | :--- | :--- |
| **Async / Future / Await** | Core Dart Async standard | `Future.delayed()`, `async/await` in `SimulatedApiClient` and `AsyncDemoController` |
| **Null Safety Basics** | `6_null_safety.dart` | `String?`, `int?`, `??` fallback defaults, `??=` assignment, `?.` safe access, `!` bang operator |
| **Advanced Null Safety** | `9_advanced_null_safety.dart` | `late final` lazy fields, `Never` return type, `try-catch` exception handling |
| **Advanced Control Flow** | `7_advanced_control_flow.dart` | `sealed class NetworkResponse<T>` with pattern matching `switch` cases & record destructuring |
| **Advanced Functions** | `8_advanced_functions.dart` | Generic mapper `mapCollection<S, U>`, state closures, named parameters |
| **Variables & Collections** | `1_variables.dart`, `2_collections.dart` | `Map<String, dynamic>`, `List<String>`, `int.parse()`, `toStringAsFixed()` |

---

## 🧪 Demo Scenarios

1. **Demo 1: Complete User Account (200 OK)**
   - Fetches fully populated profile asynchronously (User ID #101).
   - Validates all fields, tests `late final` summary generation, and displays complete account.
2. **Demo 2: Partial Account with Null Fields (200 OK + Null Coalescing)**
   - Fetches profile containing missing/null values (User ID #102).
   - Triggers `??` fallback strings, `expertise?.length ?? 0`, and nested `settings` map navigation without exceptions.
3. **Demo 3: Resource Not Found / Null Payload (404 Empty)**
   - Simulates querying a non-existent record (User ID #404).
   - Returns `null` from service; handled cleanly via `ResponseNoContent` without application crashes.
4. **Demo 4: Simulated Internal Server Error (500 Exception)**
   - Simulates a database failure (User ID #500).
   - Throws `NetworkException`, caught via `try-catch`, wrapped into `ResponseFailure`, and displayed gracefully.
5. **Demo 5: Batch Async Fetch & Generic Transformation**
   - Fetches gadget inventory list asynchronously.
   - Transforms items using `mapCollection<Map<String, dynamic>, String>` and demonstrates `??=` on currency strings.

---

## ▶️ Getting Started & Execution

### Prerequisites
Ensure the [Dart SDK](https://dart.dev/get-dart) (version 3.0 or later) is installed on your system.

### Running the Application

Navigate to the project directory and execute:

```bash
cd Async_NullSafety_Demo
dart run lib/main.dart
```

*(Alternatively, navigate into `lib` and run `dart run main.dart`)*

### Static Analysis & Verification

To verify code quality and null-safety compliance:

```bash
dart analyze
```

---

## 🖥️ Terminal Execution Output

```text
================================================================
  🔧 DART ASYNC, FUTURE & NULL SAFETY SHOWCASE (ASSIGNMENT 2)
================================================================

>>> DEMO 1: Retrieving Complete User Account (ID: 101) <<<
  [ASYNC_RUNNER #1] Sending request for User #101...
  → Dispatching async GET to: https://api.devhub.internal/v2/users/101
  [HTTP 200 — OK] User account retrieved and parsed:
╔══════════════════════════════════════════════════╗
  Summary       : User #101 — Pranav Kale <pranav@example.com>
  User ID       : 101
  Name          : Pranav Kale
  Email         : pranav@example.com
  Bio           : Full-Stack Mobile Developer specializing in Dart & Flutter
  Contact       : +91 99887 76655
  Rating        : 4.8 ★
  Expertise (4) : Dart | Flutter | Firebase | REST APIs
  Settings      : Theme → Midnight Dark | Alerts → ON
╚══════════════════════════════════════════════════╝

>>> DEMO 2: Retrieving Partial Account with Null Fields (ID: 102) <<<
  [ASYNC_RUNNER #2] Sending request for User #102...
  → Dispatching async GET to: https://api.devhub.internal/v2/users/102
  [HTTP 200 — OK] User account retrieved and parsed:
╔══════════════════════════════════════════════════╗
  Summary       : User #102 — Ananya Gupta <ananya.gupta@example.com>
  User ID       : 102
  Name          : Ananya Gupta
  Email         : ananya.gupta@example.com
  Bio           : [Not specified]
  Contact       : [No contact info]
  Rating        : N/A ★
  Expertise (0) : [No expertise listed]
  Settings      : Theme → System Default | Alerts → OFF
╚══════════════════════════════════════════════════╝

>>> DEMO 3: Retrieving Non-Existent User (ID: 404 / Not Found) <<<
  [ASYNC_RUNNER #3] Sending request for User #404...
  → Dispatching async GET to: https://api.devhub.internal/v2/users/404
  [HTTP 404 — NOT FOUND] No record available.
  Details: No user record found for ID #404 (HTTP 404 — Not Found).

>>> DEMO 4: Simulated Server Failure (ID: 500 / Exception) <<<
  [ASYNC_RUNNER #4] Sending request for User #500...
  → Dispatching async GET to: https://api.devhub.internal/v2/users/500
  [HTTP 500] Request handled gracefully!
  Reason: Internal Server Error: Primary database node is unreachable.

>>> DEMO 5: Batch Async Fetch & Generic Collection Transform <<<
  [ASYNC_RUNNER #5] Fetching Gadget Inventory batch...
  [OK] Received 4 inventory items. Running generic mapper:
    ▸ Bluetooth Earbuds — $49.99 (22 available)
    ▸ Portable SSD 1TB — $119.00 (9 available)
    ▸ RGB Mechanical Keyboard — $94.50 (17 available)
    ▸ Thunderbolt Dock Station — $189.75 (SOLD OUT)
  Selected Currency (via ??= operator): INR (₹)

================================================================
  ✅ ALL DEMONSTRATION SCENARIOS EXECUTED SUCCESSFULLY
================================================================
```

---

## 📷 Visual Output Screenshot

![Terminal Execution Output Screenshot](assets/terminal_output.png)
