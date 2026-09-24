# Pranav Kale — Profile

A Flutter profile-card app for Pranav Kale, built as a visually upgraded
sibling to the `profile/` reference app in this repository: gradient hero
header, light/dark theme toggle, staggered entrance animations, animated
GitHub stat counters, and tap-to-launch contact actions (email, phone,
GitHub).

## Content

- Name: Pranav Kale
- Role: Full Stack Developer
- Email: pkale10001@gmail.com
- Phone: 8432703264
- Location: Thane, India
- GitHub: https://github.com/Pranavk1105 (stats fetched from the GitHub
  REST API at build time: 53 public repos, 35 followers, 31 following)

## Running

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome   # or -d macos
```

## Structure

```text
lib/
  main.dart                    # App entry, theme toggle state
  theme/app_palette.dart       # Light/dark ThemeData + AppPaletteExtension
  models/user_profile.dart     # UserProfile data model
  screens/profile_screen.dart  # Main scrollable screen
  widgets/
    stat_tile.dart             # Animated count-up stat
    skill_chip.dart            # Skill pill
    contact_tile.dart          # Tappable contact row
```
