import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../utils/stub_services.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/study/score_ring.dart';
import '../../widgets/study/expression_card.dart';
import '../../widgets/study/message_bubble.dart';

/// Session detail screen with performance scores and conversation.
/// Original: call_performance_summary_2
class SessionDetailScreen extends StatefulWidget {
  const SessionDetailScreen({super.key});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scores = StubServices.scores;
    final expressions = StubServices.keyExpressionsDetailed;
    final feedback = StubServices.aiFeedback;
    final messages = StubServices.conversationMessages;

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
                              StubServices.sessionTopic,
                              style: AppTextStyles.titleMedium(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              StubServices.sessionDate,
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
                      height: 180,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: expressions.length,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          final expr = expressions[index];
                          return ExpressionCard(
                            expression: expr['expression'] ?? '',
                            translation: expr['translation'] ?? '',
                            example: expr['example'] ?? '',
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Page indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(expressions.length, (index) {
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
                          return MessageBubble(
                            isUser: isUser,
                            text: msg['text'] ?? '',
                            translatedText: msg['translatedText'],
                            timestamp: msg['timestamp'] ?? '',
                            pronunciationScore: msg['pronunciationScore'],
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
