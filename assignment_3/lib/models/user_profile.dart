class UserProfile {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String location;
  final String bio;
  final String githubUrl;
  final List<String> skills;
  final int publicRepos;
  final int followers;
  final int following;

  const UserProfile({
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.location,
    required this.bio,
    required this.githubUrl,
    required this.skills,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  /// First letter of each of the first two space-separated name parts,
  /// used as the avatar fallback (e.g. "Pranav Kale" -> "PK").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters =
        parts.where((p) => p.isNotEmpty).map((p) => p[0].toUpperCase());
    return letters.take(2).join();
  }

  static const pranavKale = UserProfile(
    name: 'Pranav Kale',
    role: 'Full Stack Developer',
    email: 'pkale10001@gmail.com',
    phone: '8432703264',
    location: 'Thane, India',
    bio:
        'Full stack developer who enjoys building clean, performant apps end '
        'to end — from Flutter UI to backend APIs and everything in between.',
    githubUrl: 'https://github.com/Pranavk1105',
    skills: [
      'Flutter',
      'Dart',
      'Java',
      'Python',
      'C++',
      'DSA',
      'Git',
      'SQL',
      'HTML/CSS/JS',
    ],
    publicRepos: 53,
    followers: 35,
    following: 31,
  );
}
