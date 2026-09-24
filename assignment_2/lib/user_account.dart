class UserAccount {
  final int userId;
  final String fullName;
  final String emailAddress;
  final String? biography;
  final String? contactNumber;
  final double? avgRating;
  final List<String>? expertise;
  final Map<String, dynamic>? settings;

  late final String summaryLine = _buildSummaryLine();

  UserAccount({
    required this.userId,
    required this.fullName,
    required this.emailAddress,
    this.biography,
    this.contactNumber,
    this.avgRating,
    this.expertise,
    this.settings,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      userId: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      fullName: (json['name'] as String?) ?? 'Unknown User',
      emailAddress: (json['email'] as String?) ?? 'not-available@placeholder.com',
      biography: json['bio'] as String?,
      contactNumber: json['phoneNumber'] as String?,
      avgRating: (json['rating'] as num?)?.toDouble(),
      expertise: (json['skills'] as List<dynamic>?)
          ?.map((entry) => entry.toString())
          .toList(),
      settings: json['preferences'] as Map<String, dynamic>?,
    );
  }

  String _buildSummaryLine() {
    return 'User #$userId — $fullName <$emailAddress>';
  }

  void printAccountInfo() {
    print('╔══════════════════════════════════════════════════╗');
    print('  Summary       : $summaryLine');
    print('  User ID       : $userId');
    print('  Name          : $fullName');
    print('  Email         : $emailAddress');

    print('  Bio           : ${biography ?? "[Not specified]"}');
    print('  Contact       : ${contactNumber ?? "[No contact info]"}');

    String ratingDisplay = avgRating != null ? avgRating!.toStringAsFixed(1) : 'N/A';
    print('  Rating        : $ratingDisplay ★');

    int totalSkills = expertise?.length ?? 0;
    String skillsDisplay = expertise != null && expertise!.isNotEmpty
        ? expertise!.join(' | ')
        : '[No expertise listed]';
    print('  Expertise ($totalSkills) : $skillsDisplay');

    String uiTheme = settings?['theme']?.toString() ?? 'System Default';
    bool alertsOn = (settings?['notificationsEnabled'] as bool?) ?? false;
    print('  Settings      : Theme → $uiTheme | Alerts → ${alertsOn ? "ON" : "OFF"}');
    print('╚══════════════════════════════════════════════════╝');
  }
}
