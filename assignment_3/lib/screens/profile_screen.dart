import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_profile.dart';
import '../theme/app_palette.dart';
import '../widgets/contact_tile.dart';
import '../widgets/skill_chip.dart';
import '../widgets/stat_tile.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static const profile = UserProfile.pranavKale;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _staggered({
    required double start,
    required double end,
    required Widget child,
  }) {
    final fade = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    return AnimatedBuilder(
      animation: fade,
      builder: (context, _) => Opacity(
        opacity: fade.value,
        child: Transform.translate(
          offset: Offset(0, (1 - fade.value) * 16),
          child: child,
        ),
      ),
      child: child,
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppPalette.gradientStart, AppPalette.gradientEnd],
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: widget.onToggleTheme,
                      icon: Icon(
                        widget.isDarkMode
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: Colors.white,
                      ),
                      tooltip: widget.isDarkMode
                          ? 'Switch to light mode'
                          : 'Switch to dark mode',
                    ),
                  ),
                  _staggered(
                    start: 0.0,
                    end: 0.5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(
                          profile.initials,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _staggered(
                    start: 0.1,
                    end: 0.6,
                    child: Column(
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.role,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _staggered(
                      start: 0.15,
                      end: 0.65,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: palette.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          profile.bio,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _staggered(
                      start: 0.2,
                      end: 0.7,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final skill in profile.skills)
                            SkillChip(label: skill),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _staggered(
                      start: 0.25,
                      end: 0.75,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: palette.cardBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatTile(
                              value: profile.publicRepos,
                              label: 'Repos',
                              icon: Icons.folder_open_outlined,
                            ),
                            Container(
                              height: 32,
                              width: 1,
                              color: palette.cardBorder,
                            ),
                            StatTile(
                              value: profile.followers,
                              label: 'Followers',
                              icon: Icons.people_outline,
                            ),
                            Container(
                              height: 32,
                              width: 1,
                              color: palette.cardBorder,
                            ),
                            StatTile(
                              value: profile.following,
                              label: 'Following',
                              icon: Icons.person_add_alt_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _staggered(
                      start: 0.3,
                      end: 0.8,
                      child: Column(
                        children: [
                          ContactTile(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: profile.email,
                            onTap: () => _launch('mailto:${profile.email}'),
                          ),
                          const SizedBox(height: 10),
                          ContactTile(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: profile.phone,
                            onTap: () => _launch('tel:${profile.phone}'),
                          ),
                          const SizedBox(height: 10),
                          ContactTile(
                            icon: Icons.location_on_outlined,
                            label: 'Location',
                            value: profile.location,
                          ),
                          const SizedBox(height: 10),
                          ContactTile(
                            icon: Icons.code,
                            label: 'GitHub',
                            value: profile.githubUrl.replaceFirst(
                              'https://',
                              '',
                            ),
                            onTap: () => _launch(profile.githubUrl),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _staggered(
                      start: 0.35,
                      end: 0.85,
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () =>
                                  _launch('mailto:${profile.email}'),
                              icon: const Icon(Icons.send_rounded, size: 18),
                              label: const Text('Email Me'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _launch(profile.githubUrl),
                              icon: const Icon(Icons.code, size: 18),
                              label: const Text('View GitHub'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: scheme.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
