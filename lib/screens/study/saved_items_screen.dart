import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../utils/stub_services.dart';
import '../../services/api_service.dart';
import '../../widgets/common/bottom_nav_bar.dart';

/// Saved items screen (Study Archive).
/// Original: learning_archive
class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _bookmarks = [];

  final List<String> _categories = ['All', 'Vocabulary', 'Grammar', 'Pronunciation'];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final response = await ApiService.get('/bookmarks');
      if (response.success && mounted) {
        setState(() {
          _bookmarks = List<Map<String, dynamic>>.from(
            response.data['bookmarks'] ?? []
          );
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load bookmarks: ${response.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteBookmark(int bookmarkId) async {
    try {
      // Show confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Bookmark'),
          content: const Text('Are you sure you want to delete this bookmark?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Delete from backend
      final response = await ApiService.post('/bookmarks/$bookmarkId/delete', {});
      if (response.success && mounted) {
        // Remove from local list
        setState(() {
          _bookmarks.removeWhere((b) => b['bookmark_id'] == bookmarkId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bookmark deleted'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error deleting bookmark: $e');
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedCategory == 'All') {
      return _bookmarks;
    }
    // For now, return all items as we don't have category filtering from backend
    // You could add category based on expression type later
    return _bookmarks;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Vocabulary':
        return AppColors.primary;
      case 'Grammar':
        return AppColors.callGreen;
      case 'Pronunciation':
        return Colors.amber;
      default:
        return AppColors.slate500;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Vocabulary':
        return Icons.lightbulb_outline;
      case 'Grammar':
        return Icons.info_outline;
      case 'Pronunciation':
        return Icons.graphic_eq;
      default:
        return Icons.info_outline;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightBg,
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      );
    }

    // Group items by date
    final thisWeekItems = _filteredItems.take(3).toList();
    final lastWeekItems = _filteredItems.skip(3).toList();

    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    color: AppColors.slate600,
                    onPressed: () {
                      // TODO: Open settings
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Study Archive',
                      style: AppTextStyles.titleMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                    onPressed: () {
                      // TODO: Add new item
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.slate100,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search saved items...',
                    hintStyle: AppTextStyles.bodyMedium(color: AppColors.slate400),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.slate400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.slate200,
                            ),
                          ),
                          child: Text(
                            category,
                            style: AppTextStyles.bodySmall(
                              color: isSelected ? Colors.white : AppColors.slate600,
                            ).copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No saved items found',
                        style: AppTextStyles.bodyMedium(color: AppColors.slate400),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        // This Week section
                        if (thisWeekItems.isNotEmpty) ...[
                          Text(
                            'This Week',
                            style: AppTextStyles.labelSmall(color: AppColors.slate500)
                                .copyWith(letterSpacing: 1),
                          ),
                          const SizedBox(height: 12),
                          ...thisWeekItems.map((item) => _LearningCard(
                                item: item,
                                categoryColor: _getCategoryColor(item['category'] ?? 'Vocabulary'),
                                categoryIcon: _getCategoryIcon(item['category'] ?? 'Vocabulary'),
                                onPractice: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.phrasePractice,
                                    arguments: item,
                                  );
                                },
                                onDelete: () => _deleteBookmark(item['bookmark_id']),
                              )),
                        ],

                        // Last Week section
                        if (lastWeekItems.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Last Week',
                            style: AppTextStyles.labelSmall(color: AppColors.slate500)
                                .copyWith(letterSpacing: 1),
                          ),
                          const SizedBox(height: 12),
                          ...lastWeekItems.map((item) => _LearningCard(
                                item: item,
                                categoryColor: _getCategoryColor(item['category'] ?? 'Vocabulary'),
                                categoryIcon: _getCategoryIcon(item['category'] ?? 'Vocabulary'),
                                onPractice: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.phrasePractice,
                                    arguments: item,
                                  );
                                },
                                onDelete: () => _deleteBookmark(item['bookmark_id']),
                              )),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
            ),

            // Bottom nav
            const BottomNavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}

class _LearningCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Color categoryColor;
  final IconData categoryIcon;
  final VoidCallback onPractice;
  final VoidCallback? onDelete;

  const _LearningCard({
    required this.item,
    required this.categoryColor,
    required this.categoryIcon,
    required this.onPractice,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Adapt bookmark data to card format
    final expression = item['expression'] ?? '';
    final note = item['note'] ?? '';
    final category = item['category'] ?? 'Vocabulary';
    final createdAt = item['created_at'] ?? item['savedAt'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [AppShadows.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: category, date, bookmark
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.labelSmall(color: categoryColor)
                      .copyWith(letterSpacing: 0.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(createdAt),
                style: AppTextStyles.labelSmall(color: AppColors.slate400),
              ),
              const Spacer(),
              const Icon(
                Icons.bookmark,
                size: 20,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Expression section
          Text(
            'Expression:',
            style: AppTextStyles.labelSmall(color: AppColors.slate400),
          ),
          const SizedBox(height: 4),
          Text(
            expression,
            style: AppTextStyles.bodyLarge().copyWith(fontWeight: FontWeight.w600),
          ),

          // Note/Context section
          if (note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    categoryIcon,
                    size: 18,
                    color: categoryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note,
                      style: AppTextStyles.bodySmall(color: AppColors.slate600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Bottom actions
          Row(
            children: [
              // Practice button
              GestureDetector(
                onTap: onPractice,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Practice',
                    style: AppTextStyles.labelLarge(color: AppColors.primary),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                iconSize: 20,
                color: AppColors.slate400,
                onPressed: () {
                  // TODO: Share
                },
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  iconSize: 20,
                  color: AppColors.slate400,
                  onPressed: onDelete,
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    } catch (e) {
      return dateStr;
    }
  }
}
