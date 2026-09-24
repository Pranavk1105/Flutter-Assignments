import 'package:flutter/material.dart';

/// Renders an informative error card when [FutureBuilder] receives [AsyncSnapshot.hasError].
class ErrorDisplay extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  final VoidCallback? onResetOffline;
  final bool isOfflineSimulated;

  const ErrorDisplay({
    super.key,
    required this.error,
    required this.onRetry,
    this.onResetOffline,
    this.isOfflineSimulated = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorMsg = error.toString().replaceAll('Exception: ', '');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.shade200, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade100.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 44,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Data Fetch Failed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    key: const Key('retry_button'),
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                    ),
                  ),
                  if (isOfflineSimulated && onResetOffline != null) ...[
                    const SizedBox(width: 10),
                    OutlinedButton(
                      key: const Key('disable_offline_button'),
                      onPressed: onResetOffline,
                      child: const Text('Disable Offline Mode'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
