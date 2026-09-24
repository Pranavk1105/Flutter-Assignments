# Responsive Dashboard - Assignment 4

Flutter dashboard screen built for my Flutter assignment to practice `ListView`, `GridView`, `MediaQuery`, and `Flexible`/`Expanded`.

## What it does

- Quick actions row (Add / Order / Export)
- Stats grid - revenue, orders, visitors, returns
- Recent activity list
- Layout switches from stacked (phone) to side-by-side (tablet/desktop) based on screen width

## Files

- `lib/stat_item.dart` - `StatItem` model and `StatCard` widget
- `lib/stats_grid.dart` - `StatsGrid`, a `GridView` that picks its own column count from available width
- `lib/activity_item.dart` - `ActivityItem` model and `ActivityTile` widget
- `lib/activity_list.dart` - `ActivityList`, a `ListView` of recent activity
- `lib/quick_actions.dart` - `QuickActionsBar`, a `Row` of `Flexible` action buttons
- `lib/dashboard_screen.dart` - assembles everything, switches between stacked and side-by-side layout using `MediaQuery`
- `lib/main.dart` - entry point

## How to run

```
flutter run
```

## Report

See `docs/report.md` for the write-up, along with screenshots at phone and desktop width.
