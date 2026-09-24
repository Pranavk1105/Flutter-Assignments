# 🛒 Assignment 6 – Product Listing & Filter

A Flutter application that demonstrates dynamic product catalog rendering with real-time search and filter functionality. Built to practice `ListView.builder`, custom data models, and reactive state management using `setState`.

**Name:** Pranav Kale  
**Roll No:** 150096724142

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Project Structure](#-project-structure)
- [Architecture Overview](#-architecture-overview)
- [Code Walkthrough](#-code-walkthrough)
- [Concepts Used](#-concepts-used)
- [How to Run](#-how-to-run)
- [Challenges Faced](#-challenges-faced)
- [What I Learned](#-what-i-learned)
- [Report](#-report)

---

## ✨ Features

- **Dynamic Product Catalog** — Displays a list of 10 products with name, category, and formatted price
- **Real-Time Search** — Filters products instantly as the user types in the search bar
- **Multi-Field Search** — Searches across both product name and category simultaneously
- **Case-Insensitive Matching** — Search works regardless of uppercase/lowercase input
- **Clear Button** — One-tap reset to restore the full product catalog
- **Empty State Handling** — Shows a clean "No products found" message when no items match
- **Material 3 Design** — Modern UI using Material Design 3 theming with a blue color scheme
- **Modular Architecture** — Clean separation of data model, reusable widget, screen logic, and entry point

---

## 📸 Screenshots

| Full Product List | Filtered View |
|:-:|:-:|
| ![Full List](docs/screenshot_full_list.png) | ![Filtered](docs/screenshot_filtered.png) |
| Default view showing all 10 products | Filtered results after typing a search query |

---

## 📁 Project Structure

```
assignment6/
├── lib/
│   ├── main.dart                  # App entry point & MaterialApp configuration
│   ├── product_item.dart          # Product data model + ProductTile widget
│   └── product_list_screen.dart   # Main screen with search bar & ListView.builder
├── docs/
│   ├── report.md                  # Detailed assignment write-up
│   └── assignment6_report.html    # Printable 2-page PDF report
├── test/
│   └── widget_test.dart           # Default widget test
├── pubspec.yaml                   # Dependencies & project configuration
└── README.md                     # This file
```

---

## 🏗 Architecture Overview

The app follows a clean, modular architecture with clear separation of concerns:

```
┌─────────────────────────────────────────────────┐
│                   main.dart                     │
│         MaterialApp + Theme Config              │
│                     │                           │
│                     ▼                           │
│          product_list_screen.dart                │
│    ┌────────────────────────────────┐           │
│    │  StatefulWidget                │           │
│    │  • _allProducts (master list)  │           │
│    │  • _filteredProducts (display) │           │
│    │  • _filterProducts(query)      │           │
│    │  • TextField + ListView.builder│           │
│    └──────────────┬─────────────────┘           │
│                   │                             │
│                   ▼                             │
│           product_item.dart                     │
│    ┌────────────────────────────────┐           │
│    │  Product (Data Model)         │           │
│    │  ProductTile (Reusable Widget)│           │
│    └────────────────────────────────┘           │
└─────────────────────────────────────────────────┘
```

---

## 🔍 Code Walkthrough

### 1. `lib/product_item.dart` — Data Model & Widget

**`Product` class** — A simple immutable data model with three fields:

```dart
class Product {
  final String name;
  final String category;
  final double price;

  const Product({
    required this.name,
    required this.category,
    required this.price,
  });
}
```

**`ProductTile` widget** — A reusable `StatelessWidget` that renders a single product as a `Card` containing a `ListTile`:

- **Leading:** `CircleAvatar` displaying the first letter of the product name
- **Title:** Product name in bold
- **Subtitle:** Product category
- **Trailing:** Formatted price in green (`$XX.XX`)

### 2. `lib/product_list_screen.dart` — Main Screen

A `StatefulWidget` that manages the entire product listing and filtering logic:

- **`_allProducts`** — A `const` master list of 10 sample products (never modified)
- **`_filteredProducts`** — The visible subset, recalculated on every query change
- **`_searchController`** — `TextEditingController` for programmatic control of the search field

**Filter logic:**

```dart
void _filterProducts(String query) {
  setState(() {
    if (query.isEmpty) {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  });
}
```

The `onChanged` callback on the `TextField` triggers this method, which uses `setState` to rebuild the UI with the filtered list. `ListView.builder` then efficiently renders only the matching items.

### 3. `lib/main.dart` — Entry Point

Configures and launches the app:

```dart
MaterialApp(
  title: 'Product Listing',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
  ),
  home: const ProductListScreen(),
);
```

- **Material 3** enabled for modern design language
- **Blue color scheme** seed for consistent theming across all Material components
- **Debug banner** disabled for a clean UI

---

## 🧠 Concepts Used

| Concept | Where Used | Why |
|---------|-----------|-----|
| **Data Model Class** | `Product` in `product_item.dart` | Type-safe, structured data representation |
| **ListView.builder** | `product_list_screen.dart` | Lazy rendering — only builds visible items, memory-efficient |
| **setState** | `_filterProducts()` | Triggers UI rebuild when filtered data changes |
| **StatefulWidget** | `ProductListScreen` | Manages mutable state (filtered list, search query) |
| **StatelessWidget** | `ProductTile` | Stateless presentation component, receives data via constructor |
| **TextEditingController** | Search `TextField` | Programmatic control for clearing the search input |
| **Card + ListTile** | `ProductTile` | Material Design components for consistent list item layout |
| **CircleAvatar** | Product initial badge | Visual identifier using the first letter of the product name |
| **const Constructor** | `Product`, widget constructors | Compile-time constants for performance optimization |

---

## 🚀 How to Run

### Prerequisites

- Flutter SDK `>=3.13.0`
- Chrome browser (for web) or a connected device/emulator

### Steps

```bash
# 1. Clone or navigate to the project
cd assignment6

# 2. Get dependencies
flutter pub get

# 3. Run on Chrome
flutter run -d chrome

# 4. Or run on macOS desktop
flutter run -d macos
```

---

## ⚡ Challenges Faced

### 1. List Mutation During Filtering
**Problem:** Filtering directly on the master list (`_allProducts`) permanently removed items — clearing the search didn't restore them.  
**Solution:** Maintained a separate `_filteredProducts` list that is recalculated from the immutable `_allProducts` on every query change.

### 2. Case-Sensitive Search
**Problem:** Searching "laptop" didn't match "Laptop" due to strict string comparison.  
**Solution:** Applied `toLowerCase()` to both the search query and product fields before comparison.

### 3. Searching Across Multiple Fields
**Problem:** Users might search by category ("Electronics") or by name ("Headphones"), but initial implementation only searched names.  
**Solution:** Extended the `where()` filter condition to check both `product.name` and `product.category` using a logical OR (`||`).

### 4. SDK Version Compatibility
**Problem:** Project was created with `sdk: ^3.13.2` but the deployment machine had Dart `3.13.1`, causing `flutter pub get` to fail.  
**Solution:** Relaxed the constraint to `sdk: ^3.13.0` in `pubspec.yaml`.

### 5. Clear Button Conditional Visibility
**Problem:** The clear (✕) icon was always visible in the search bar, even when empty.  
**Solution:** Conditionally rendered the `suffixIcon` based on `_searchController.text.isNotEmpty`.

---

## 📝 What I Learned

- `ListView.builder` creates items **lazily** — only when they scroll into view — making it far more memory-efficient than `ListView` for dynamic datasets
- `setState` informs Flutter's framework that internal state has changed, prompting a call to `build()` to reconcile the widget tree against updated data
- Keeping the **master list immutable** and maintaining a separate **display list** is essential for non-destructive filtering
- **Reusable component separation** (extracting `ProductTile` into its own file) keeps screen widgets focused and promotes clean, maintainable code
- **Material 3** theming with `colorSchemeSeed` automatically generates a harmonious color palette from a single seed color

---

## 📄 Report

See [`docs/report.md`](docs/report.md) for the complete assignment write-up and concept breakdown.  
See [`docs/assignment6_report.html`](docs/assignment6_report.html) for the printable 2-page PDF report.

---

> Built with Flutter & Material Design 3
