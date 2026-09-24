import 'package:flutter/material.dart';
import '../models/user_registration.dart';
import '../routes/app_routes.dart';
import '../widgets/detail_info_row.dart';

/// Screen 3: Detail Screen displaying the submitted user registration details.
/// Extracts data passed through `ModalRoute.of(context)!.settings.arguments`.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract the UserRegistration object passed via named route arguments
    final user = ModalRoute.of(context)?.settings.arguments as UserRegistration?;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: user == null
            ? _buildEmptyState(context)
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: colorScheme.primary,
                              child: Text(
                                user.initials,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user.fullName,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.green),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Registration Verified',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Submitted User Data Details
                    Text(
                      'Submitted Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    DetailInfoRow(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: user.fullName,
                      iconColor: Colors.indigo,
                    ),

                    DetailInfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email Address',
                      value: user.email,
                      iconColor: Colors.teal,
                    ),

                    DetailInfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: user.phone,
                      iconColor: Colors.blue,
                    ),

                    DetailInfoRow(
                      icon: Icons.work_outline,
                      label: 'Account Role',
                      value: user.accountType,
                      iconColor: Colors.orange,
                    ),

                    DetailInfoRow(
                      icon: Icons.wc_outlined,
                      label: 'Gender',
                      value: user.gender,
                      iconColor: Colors.purple,
                    ),

                    DetailInfoRow(
                      icon: Icons.lock_outline,
                      label: 'Password Security',
                      value: '${user.maskedPassword} (${user.password.length} characters)',
                      iconColor: Colors.redAccent,
                    ),

                    DetailInfoRow(
                      icon: Icons.mark_email_read_outlined,
                      label: 'Newsletter Subscription',
                      value: user.subscribeNewsletter ? 'Active Subscriber' : 'Unsubscribed',
                      iconColor: Colors.amber.shade800,
                    ),

                    DetailInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Registration Timestamp',
                      value: user.formattedDate,
                      iconColor: Colors.cyan.shade700,
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    FilledButton.icon(
                      key: const Key('home_navigation_button'),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text(
                        'Return to Home',
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit Registration Details'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: Text(
                        'Assignment 7 • Pranav Kale (150096724142)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Registration Data Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please complete and submit the registration form to view profile details.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.form);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Go to Registration Form'),
            ),
          ],
        ),
      ),
    );
  }
}
