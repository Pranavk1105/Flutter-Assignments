import 'package:flutter/material.dart';
import 'package:assignment_8/models/post.dart';

/// Detailed view displaying the complete information for a selected [Post].
class PostDetailScreen extends StatelessWidget {
  final Post post;
  final bool isFromCache;

  const PostDetailScreen({
    super.key,
    required this.post,
    this.isFromCache = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${post.formattedId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Post',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing Post #${post.id}...'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Metadata Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  label: Text(
                    post.formattedId,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  avatar: const Icon(Icons.tag_rounded, size: 16),
                ),
                Chip(
                  backgroundColor: Colors.blue.shade50,
                  label: Text(
                    'Author User ID: ${post.userId}',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  avatar: Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: Colors.blue.shade900,
                  ),
                ),
                if (isFromCache)
                  Chip(
                    backgroundColor: Colors.amber.shade50,
                    label: Text(
                      'Cached Offline',
                      style: TextStyle(
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    avatar: Icon(
                      Icons.storage_rounded,
                      size: 16,
                      color: Colors.amber.shade900,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Post Title
            Text(
              post.capitalizedTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Post Body Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.article_outlined,
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Content Body',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.body,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade900,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Source Attribution Card
            Card(
              elevation: 0,
              color: Colors.indigo.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.indigo.shade100),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.api_rounded, color: Colors.indigo.shade800),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'JSONPlaceholder REST API',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'https://jsonplaceholder.typicode.com/posts/${post.id}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
