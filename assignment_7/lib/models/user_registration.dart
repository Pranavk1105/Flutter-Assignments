/// Model class representing a registered user's profile and credentials.
class UserRegistration {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String accountType;
  final String gender;
  final bool agreeToTerms;
  final bool subscribeNewsletter;
  final DateTime registrationDate;

  const UserRegistration({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.accountType,
    required this.gender,
    required this.agreeToTerms,
    this.subscribeNewsletter = false,
    required this.registrationDate,
  });

  /// Extracts user initials (e.g. "John Doe" -> "JD")
  String get initials {
    if (fullName.trim().isEmpty) return '?';
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Returns a masked string for the password (e.g. "••••••••")
  String get maskedPassword {
    return '•' * password.length;
  }

  /// Returns a formatted date string (YYYY-MM-DD HH:mm)
  String get formattedDate {
    final y = registrationDate.year.toString().padLeft(4, '0');
    final m = registrationDate.month.toString().padLeft(2, '0');
    final d = registrationDate.day.toString().padLeft(2, '0');
    final hr = registrationDate.hour.toString().padLeft(2, '0');
    final min = registrationDate.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hr:$min';
  }
}
