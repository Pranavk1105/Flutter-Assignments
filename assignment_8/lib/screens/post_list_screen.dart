import 'package:flutter/material.dart';
import 'package:assignment_8/models/post_result.dart';
import 'package:assignment_8/screens/post_detail_screen.dart';
import 'package:assignment_8/services/post_repository.dart';
import 'package:assignment_8/widgets/cache_status_banner.dart';
import 'package:assignment_8/widgets/error_display.dart';
import 'package:assignment_8/widgets/loading_skeleton.dart';
import 'package:assignment_8/widgets/post_card.dart';

/// Main screen displaying posts using [FutureBuilder] with offline [SharedPreferences] caching.
class PostListScreen extends StatefulWidget {
  final PostRepository repository;

  const PostListScreen({
    super.key,
    required this.repository,
  });

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<PostResult> _futurePosts;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize the future once to avoid re-triggering network requests on rebuilds
    _futurePosts = widget.repository.fetchPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Refreshes the post data from the repository.
  Future<void> _refresh({bool forceRefresh = true}) async {
    setState(() {
      _futurePosts = widget.repository.fetchPosts(forceRefresh: forceRefresh);
    });
    // Await completion so RefreshIndicator animates properly
    try {
      await _futurePosts;
    } catch (_) {
      // Errors handled gracefully by FutureBuilder
    }
  }

  /// Toggles offline simulation mode to test cache fallback without turning off Wi-Fi.
  void _toggleOfflineSimulation(bool enabled) {
    setState(() {
      widget.repository.simulateOffline = enabled;
      _futurePosts = widget.repository.fetchPosts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled
              ? 'Offline simulation enabled (Forces SharedPreferences cache)'
              : 'Offline simulation disabled (Resumes live network calls)',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Confirms and clears the SharedPreferences cache.
  Future<void> _confirmClearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear SharedPreferences Cache?'),
        content: const Text(
          'This will remove all stored posts and cache timestamps from local storage. '
          'Subsequent fetches will require network access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await widget.repository.clearCache();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SharedPreferences cache cleared successfully.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      // Re-trigger fetch to reflect updated cache state
      _refresh(forceRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignment 8',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'REST API & SharedPreferences Cache',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('appbar_refresh_button'),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Fetch Live Data',
            onPressed: () => _refresh(forceRefresh: true),
          ),
        ],
      ),
      body: FutureBuilder<PostResult>(
        future: _futurePosts,
        builder: (context, snapshot) {
          // 1. ConnectionState.waiting -> Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSkeleton();
          }

          // 2. Error state -> Informative error view with retry action
          if (snapshot.hasError) {
            return ErrorDisplay(
              error: snapshot.error!,
              isOfflineSimulated: widget.repository.simulateOffline,
              onRetry: () => _refresh(forceRefresh: true),
              onResetOffline: () => _toggleOfflineSimulation(false),
            );
          }

          // 3. Success state -> Render cache banner, search bar, and post list
          if (snapshot.hasData) {
            final result = snapshot.data!;
            final allPosts = result.posts;

            // Apply search filter locally
            final filteredPosts = _searchQuery.isEmpty
                ? allPosts
                : allPosts.where((post) {
                    final query = _searchQuery.toLowerCase();
                    return post.title.toLowerCase().contains(query) ||
                        post.id.toString() == query ||
                        post.userId.toString() == query;
                  }).toList();

            return RefreshIndicator(
              key: const Key('post_list_refresh_indicator'),
              onRefresh: () => _refresh(forceRefresh: true),
              child: CustomScrollView(
                slivers: [
                  // Cache & Network status banner
                  SliverToBoxAdapter(
                    child: CacheStatusBanner(
                      result: result,
                      isSimulatingOffline: widget.repository.simulateOffline,
                      onToggleOffline: _toggleOfflineSimulation,
                      onRefresh: () => _refresh(forceRefresh: true),
                      onClearCache: _confirmClearCache,
                    ),
                  ),

                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: TextField(
                        key: const Key('post_search_field'),
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search posts by title, ID, or user...',
                          prefixIcon: const Icon(Icons.search_rounded, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Empty filter results
                  if (filteredPosts.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 52, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No posts match "$_searchQuery"',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              child: const Text('Reset search'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // List of posts
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = filteredPosts[index];
                          return PostCard(
                            key: Key('post_card_${post.id}'),
                            post: post,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailScreen(
                                    post: post,
                                    isFromCache: result.isFromCache,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: filteredPosts.length,
                      ),
                    ),

                  // Bottom padding for scroll comfort
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
            );
          }

          // Fallback
          return const Center(child: Text('No data found.'));
        },
      ),
    );
  }
}
