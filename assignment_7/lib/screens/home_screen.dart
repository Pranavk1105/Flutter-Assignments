import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../models/user_registration.dart';

/// Screen 1: Home dashboard welcoming users and providing entry points for registration.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assignment 7 - Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Banner Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: colorScheme.primary,
                        child: Icon(
                          Icons.app_registration_rounded,
                          size: 40,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'User Registration Portal',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A 3-screen Flutter app demonstrating Named Route Navigation and complete Form Validation.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Architectural Highlights Section
              Text(
                'Key Architectural Features',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildFeatureTile(
                context,
                icon: Icons.alt_route_rounded,
                title: 'Named Route Navigation',
                subtitle: "Centralized routing with '/', '/form', and '/detail' routes.",
                color: Colors.blue,
              ),
              _buildFeatureTile(
                context,
                icon: Icons.verified_user_outlined,
                title: 'Robust Form Validation',
                subtitle: 'Regex email matching, password policy & confirm checks.',
                color: Colors.green,
              ),
              _buildFeatureTile(
                context,
                icon: Icons.badge_outlined,
                title: 'Data Passing via Arguments',
                subtitle: 'Passes immutable UserRegistration model via route settings.',
                color: Colors.deepPurple,
              ),

              const SizedBox(height: 28),

              // Action Buttons
              FilledButton.icon(
                key: const Key('register_button'),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.form);
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text(
                  'Go to Registration Form',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                key: const Key('sample_detail_button'),
                onPressed: () {
                  // Navigate to detail screen with sample data for demonstration
                  final sampleUser = UserRegistration(
                    fullName: 'Pranav Kale',
                    email: 'pranav.kale@example.com',
                    phone: '9876543210',
                    password: 'SecurePassword123',
                    accountType: 'Developer',
                    gender: 'Male',
                    agreeToTerms: true,
                    subscribeNewsletter: true,
                    registrationDate: DateTime.now(),
                  );
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detail,
                    arguments: sampleUser,
                  );
                },
                icon: const Icon(Icons.preview_rounded),
                label: const Text('View Sample Detail Screen'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Student Footer Badge
              Center(
                child: Text(
                  'Assignment 7 • Pranav Kale (150096724142)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
