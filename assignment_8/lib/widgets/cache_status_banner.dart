import 'package:flutter/material.dart';
import 'package:assignment_8/models/post_result.dart';

/// Interactive banner highlighting whether the displayed data is fresh from
/// the live JSONPlaceholder REST API or retrieved from [SharedPreferences] cache.
class CacheStatusBanner extends StatelessWidget {
  final PostResult result;
  final bool isSimulatingOffline;
  final ValueChanged<bool> onToggleOffline;
  final VoidCallback onRefresh;
  final VoidCallback onClearCache;

  const CacheStatusBanner({
    super.key,
    required this.result,
    required this.isSimulatingOffline,
    required this.onToggleOffline,
    required this.onRefresh,
    required this.onClearCache,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCache = result.isFromCache;

    final primaryColor = isCache ? Colors.amber.shade800 : Colors.teal.shade700;
    final bgColor = isCache ? Colors.amber.shade50 : Colors.teal.shade50;
    final borderColor = isCache ? Colors.amber.shade200 : Colors.teal.shade200;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with status badge and count
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCache ? Icons.storage_rounded : Icons.cloud_done_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isCache ? 'SharedPreferences Cache' : 'Live REST API',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  '${result.posts.length} Posts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Timestamp info
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${isCache ? 'Cached on' : 'Fetched on'}: ${result.formattedTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          if (result.notice != null) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 14, color: Colors.amber.shade900),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    result.notice!,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const Divider(height: 18, thickness: 0.8),

          // Action controls: Offline simulation switch & Clear Cache button
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Offline toggle chip
              FilterChip(
                key: const Key('toggle_offline_chip'),
                label: Text(
                  isSimulatingOffline
                      ? 'Simulating Offline'
                      : 'Simulate Offline',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSimulatingOffline
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSimulatingOffline
                        ? Colors.red.shade900
                        : theme.colorScheme.onSurface,
                  ),
                ),
                selected: isSimulatingOffline,
                selectedColor: Colors.red.shade100,
                checkmarkColor: Colors.red.shade900,
                onSelected: onToggleOffline,
                avatar: Icon(
                  isSimulatingOffline
                      ? Icons.wifi_off_rounded
                      : Icons.wifi_rounded,
                  size: 15,
                  color: isSimulatingOffline
                      ? Colors.red.shade900
                      : Colors.grey.shade700,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),

              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    key: const Key('refresh_banner_button'),
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh_rounded, size: 14),
                    label: const Text('Refresh', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      minimumSize: const Size(0, 32),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(width: 6),
                  TextButton.icon(
                    key: const Key('clear_cache_button'),
                    onPressed: onClearCache,
                    icon: Icon(Icons.delete_outline_rounded,
                        size: 14, color: Colors.red.shade700),
                    label: Text(
                      'Clear Cache',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red.shade700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      minimumSize: const Size(0, 32),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
