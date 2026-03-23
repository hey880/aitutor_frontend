import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../utils/stub_services.dart';
import '../../services/api_service.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/study/score_ring.dart';
import '../../widgets/study/expression_card.dart';
import '../../widgets/study/message_bubble.dart';

/// Session detail screen with performance scores and conversation.
/// Original: call_performance_summary_2
class SessionDetailScreen extends StatefulWidget {
  final int sessionId;

  const SessionDetailScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  bool _isLoading = true;
  Map<String, dynamic>? _reviewData;

  @override
  void initState() {
    super.initState();
    _loadReviewData();
  }

  Future<void> _loadReviewData() async {
    try {
      // Call the full review endpoint which includes conversation
      final response = await ApiService.get('/review/${widget.sessionId}');
      if (response.success && mounted) {
        setState(() {
          _reviewData = response.data;
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load review: ${response.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error loading review: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _bookmarkExpression(Map<String, dynamic> expr) async {
    try {
      final response = await ApiService.post('/bookmarks', {
        'session_id': widget.sessionId,
        'expression': expr['expression'],
        'note': expr['context'] ?? expr['example'] ?? '',
      });

      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved to bookmarks!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error bookmarking: $e');
    }
  }

  Future<void> _showFeedback(int messageId) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Call feedback API
      final response = await ApiService.post(
        '/feedback/analyze',
        {'message_id': messageId},
      );

      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      if (response.success) {
        final data = response.data;
        final grammarFeedback = data['grammar_feedback'] ?? '';
        final vocabularyFeedback = data['vocabulary_feedback'] ?? '';
        final suggestions = data['suggested_response'];

        // Show feedback dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.analytics, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('피드백'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (grammarFeedback.isNotEmpty) ...[
                    Text(
                      '문법 교정',
                      style: AppTextStyles.labelLarge(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      grammarFeedback,
                      style: AppTextStyles.bodyMedium(color: AppColors.textDark),
                      softWrap: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (vocabularyFeedback.isNotEmpty) ...[
                    Text(
                      '더 나은 표현',
                      style: AppTextStyles.labelLarge(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vocabularyFeedback,
                      style: AppTextStyles.bodyMedium(color: AppColors.textDark),
                      softWrap: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (suggestions != null) ...[
                    Text(
                      '추천 표현',
                      style: AppTextStyles.labelLarge(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    if (suggestions is List)
                      ...suggestions.map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• $s',
                              style: AppTextStyles.bodyMedium(
                                  color: AppColors.slate600),
                            ),
                          ))
                    else
                      Text(
                        suggestions.toString(),
                        style: AppTextStyles.bodyMedium(color: AppColors.slate600),
                      ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('닫기'),
              ),
            ],
          ),
        );
      } else {
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('피드백을 가져올 수 없습니다: ${response.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류 발생: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightBg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Check if review data was loaded successfully
    if (_reviewData == null) {
      return Scaffold(
        backgroundColor: AppColors.lightBg,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
                child: Row(
                  children: [
                    const AppBackButton(),
                    const SizedBox(width: 8),
                    Text(
                      'Session Detail',
                      style: AppTextStyles.titleMedium(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.slate400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load session data',
                          style: AppTextStyles.titleMedium(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please check your connection and try again.',
                          style: AppTextStyles.bodySmall(color: AppColors.slate500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          text: 'Retry',
                          onPressed: () {
                            setState(() => _isLoading = true);
                            _loadReviewData();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Use actual review data (no stub fallback)
    final scores = _reviewData!['scores'] as Map<String, dynamic>? ?? {};
    final expressions = (_reviewData!['key_expressions'] ?? []) as List;
    final feedback = _reviewData!['feedback'] ?? 'No feedback available.';
    final messages = (_reviewData!['conversation'] ?? []) as List;

    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
              child: Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 8),
                  Text(
                    'Session Detail',
                    style: AppTextStyles.titleMedium(),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Session Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: [AppShadows.cardShadow],
                        ),
                        child: Column(
                          children: [
                            Text(
                              _reviewData!['title'] ?? _reviewData!['topic'] ?? 'Conversation Practice',
                              style: AppTextStyles.titleMedium(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _reviewData!['date'] ?? '',
                              style: AppTextStyles.bodySmall(color: AppColors.slate500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 2: Score Rings
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: [AppShadows.cardShadow],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ScoreRing(
                              score: scores['pronunciation'] ?? 0,
                              label: 'Pronunciation',
                              color: AppColors.primary,
                            ),
                            ScoreRing(
                              score: scores['intonation'] ?? 0,
                              label: 'Intonation',
                              color: AppColors.callGreen,
                            ),
                            ScoreRing(
                              score: scores['fluency'] ?? 0,
                              label: 'Fluency',
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 3: Performance Feedback Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.slate100,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Performance Feedback',
                                    style: AppTextStyles.bodyMedium()
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feedback,
                                    style: AppTextStyles.bodySmall(
                                      color: AppColors.slate600,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section 4: Expressions You Learned
                    if (expressions.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '💡 Expressions You Learned',
                          style: AppTextStyles.titleMedium().copyWith(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // PageView for expression cards
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: expressions.length,
                          physics: const PageScrollPhysics(), // Ensure swipe works
                          padEnds: false,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemBuilder: (context, index) {
                            final expr = expressions[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Stack(
                                children: [
                                  ExpressionCard(
                                    expression: expr['expression'] ?? '',
                                    translation: expr['translation'] ?? '',
                                    example: expr['example'] ?? expr['context'] ?? '',
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: const Icon(Icons.bookmark_add),
                                      color: AppColors.primary,
                                      onPressed: () => _bookmarkExpression(expr),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: const CircleBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Page indicator dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(expressions.length, (index) {
                          final isActive = index == _currentPage;
                          return Container(
                            width: isActive ? 24 : 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primary : AppColors.slate300,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Section 5: Full Conversation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '💬 Full Conversation',
                        style: AppTextStyles.titleMedium().copyWith(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Message list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: messages.map((msg) {
                          final isUser = msg['sender'] == 'user';
                          final messageId = msg['message_id'] as int?;
                          return MessageBubble(
                            isUser: isUser,
                            text: msg['text'] ?? '',
                            translatedText: msg['translated_text'],
                            timestamp: msg['timestamp'] ?? '',
                            pronunciationScore: msg['pronunciation_score'],
                            showTimestamp: false, // Don't show timestamp
                            onFeedback: isUser && messageId != null
                                ? () => _showFeedback(messageId)
                                : null,
                            onPlayAudio: () {
                              // TODO: Play audio
                            },
                            onPractice: () {
                              Navigator.pushNamed(context, AppRoutes.phrasePractice);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bottom button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: PrimaryButton(
                        text: 'Start New Practice Session',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.phrasePractice);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom nav
            const BottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}
