import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../utils/stub_services.dart';
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

  final List<String> _categories = ['All', 'Vocabulary', 'Grammar', 'Pronunciation'];

  List<Map<String, dynamic>> get _filteredItems {
    final items = StubServices.savedItems;
    if (_selectedCategory == 'All') {
      return items;
    }
    return items.where((item) => item['category'] == _selectedCategory).toList();
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
                                categoryColor: _getCategoryColor(item['category']),
                                categoryIcon: _getCategoryIcon(item['category']),
                                onPractice: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.phrasePractice);
                                },
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
                                categoryColor: _getCategoryColor(item['category']),
                                categoryIcon: _getCategoryIcon(item['category']),
                                onPractice: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.phrasePractice);
                                },
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

  const _LearningCard({
    required this.item,
    required this.categoryColor,
    required this.categoryIcon,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context) {
    final hasCorrection = item['correction'] != null;

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
                  item['category'] ?? '',
                  style: AppTextStyles.labelSmall(color: categoryColor)
                      .copyWith(letterSpacing: 0.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(item['savedAt']),
                style: AppTextStyles.labelSmall(color: AppColors.slate400),
              ),
              const Spacer(),
              Icon(
                Icons.bookmark,
                size: 20,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // "You said:" section
          Text(
            'You said:',
            style: AppTextStyles.labelSmall(color: AppColors.slate400),
          ),
          const SizedBox(height: 4),
          Text(
            item['original'] ?? '',
            style: AppTextStyles.bodyMedium(color: AppColors.slate600),
          ),

          // Correction section (if applicable)
          if (hasCorrection) ...[
            const SizedBox(height: 12),
            Text(
              'Correction:',
              style: AppTextStyles.labelSmall(color: AppColors.slate400),
            ),
            const SizedBox(height: 4),
            Text(
              item['correction'] ?? '',
              style: AppTextStyles.bodyLarge().copyWith(fontWeight: FontWeight.w600),
            ),
          ],

          // Explanation card
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
                    item['explanation'] ?? '',
                    style: AppTextStyles.bodySmall(color: AppColors.slate600),
                  ),
                ),
              ],
            ),
          ),
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
              IconButton(
                icon: const Icon(Icons.delete_outline),
                iconSize: 20,
                color: AppColors.slate400,
                onPressed: () {
                  // TODO: Delete
                },
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
