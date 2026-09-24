# Library Catalog Management System (Dart Console Application)

A clean, modular Object-Oriented Dart console application demonstrating foundational programming concepts including variable typing, control flow, functions with named/default parameters, and OOP inheritance.

---

## Features

- **OOP & Inheritance Hierarchy**:
  - `CatalogItem`: Base abstract class encapsulating common attributes (`id`, `title`, `isAvailable`) and abstract method `displayInfo()`.
  - `BookItem`: Subclass extending `CatalogItem` with `author`, `pageCount`, and `category`.
  - `PeriodicalItem`: Subclass extending `CatalogItem` with `issueNo` and `publicationDate`.
- **Member Management**:
  - `LibraryMember` class managing active loan records (`List<CatalogItem>`).
- **Library Service Operations**:
  - Add items to catalog inventory (`List<CatalogItem>`).
  - Enroll library members (`Map<String, LibraryMember>`).
  - Issue items with availability validation.
  - Return items and restore catalog availability.
  - Case-insensitive search by keyword.
- **Utility Calculations**:
  - Compute overdue fines with customizable daily rates.

---

## Project Architecture

```
lib/
├── catalog_item.dart    # Base abstract class (CatalogItem)
├── book_item.dart       # Book subclass extending CatalogItem
├── periodical_item.dart # Periodical/Magazine subclass extending CatalogItem
├── library_member.dart  # Member model & active loan tracker
├── library_service.dart # Core LibraryService & catalog manager
├── fine_calculator.dart # Fine computation utility function
├── app_runner.dart      # Console workflow orchestration
└── main.dart            # Application entry point
```

---

## Core Concepts Demonstrated

| Concept | Implementation Details |
| :--- | :--- |
| **Variables & Collections** | `String`, `int`, `double`, `bool`, `List<CatalogItem>`, `Map<String, LibraryMember>` |
| **OOP & Inheritance** | `CatalogItem` (Base) → `BookItem`, `PeriodicalItem` (`extends`, `super`, `@override`) |
| **Encapsulation & Abstraction** | Abstract method `displayInfo()`, modular file architecture |
| **Functions** | Named parameters (`required`), default arguments, return types |
| **Loops & Flow Control** | `for`, `for-in`, `while`, and condition checks (`if-else`) |

---

## Execution

### Run the App

```bash
dart run lib/main.dart
```

---

## Sample Terminal Output

```text
================ Metropolis Public Library CATALOG ================
[Book] ID: BK-101 | "Design Patterns" by Erich Gamma et al. (395 pp., Software Engineering) -> Available
[Book] ID: BK-102 | "Flutter in Action" by Eric Windmill (360 pp., Mobile Development) -> Available
[Periodical] ID: MG-201 | "Tech Horizons" (Issue #142, September 2026) -> Available

>>> PROCESSING CHECKOUTS <<<
Success: "Design Patterns" issued to Sarah Connor.
Success: "Tech Horizons" issued to John Doe.
Notice: "Design Patterns" is already checked out.

>>> MEMBER LOANS SUMMARY <<<
Current loans for Sarah Connor (ID: MEM-001):
  - [BK-101] Design Patterns
Current loans for John Doe (ID: MEM-002):
  - [MG-201] Tech Horizons

>>> SEARCHING CATALOG FOR "Flutter" <<<
[Book] ID: BK-102 | "Flutter in Action" by Eric Windmill (360 pp., Mobile Development) -> Available

>>> PROCESSING ITEM RETURN & FINE CALCULATION <<<
Success: "Design Patterns" returned by Sarah Connor.
Late penalty for 5 overdue day(s): $8.75

================ Metropolis Public Library CATALOG ================
[Book] ID: BK-101 | "Design Patterns" by Erich Gamma et al. (395 pp., Software Engineering) -> Available
[Book] ID: BK-102 | "Flutter in Action" by Eric Windmill (360 pp., Mobile Development) -> Available
[Periodical] ID: MG-201 | "Tech Horizons" (Issue #142, September 2026) -> Checked Out
```