import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../services/api_service.dart';

/// Incoming call screen - dark themed.
/// Original: incoming_ai_call
class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({super.key});

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  bool _isStartingSession = false;

  Future<void> _onAcceptCall() async {
    setState(() => _isStartingSession = true);

    try {
      // Start a new session
      final response = await ApiService.post('/sessions/start', {});

      if (response.success && mounted) {
        final sessionId = response.data['session_id'] as int;
        final aiGreeting = response.data['ai_greeting'] as String?;

        // Navigate to active call chat screen with session ID
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.activeCallChat,
          arguments: {
            'sessionId': sessionId,
            'aiGreeting': aiGreeting,
          },
        );
      } else {
        if (mounted) {
          setState(() => _isStartingSession = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start session: ${response.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error starting session: $e');
      if (mounted) {
        setState(() => _isStartingSession = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Row(
                children: [
                  // Expand more icon
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.expand_more,
                      size: 24,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  // AI Language Partner text
                  Text(
                    'AI LANGUAGE PARTNER',
                    style: AppTextStyles.labelSmall(
                      color: Colors.white.withValues(alpha: 0.4),
                    ).copyWith(
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Balance
                ],
              ),
            ),

            // Center content
            const SizedBox(height: 80),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with glow
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    // Main avatar circle
                    Container(
                      width: 192,
                      height: 192,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withValues(alpha: 0.8),
                            letterSpacing: -2,
                          ),
                        ),
                      ),
                    ),
                    // Inner border
                    Container(
                      width: 176,
                      height: 176,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Name
                Text(
                  'Alex',
                  style: AppTextStyles.displayHero(color: Colors.white)
                      .copyWith(fontSize: 48),
                ),
                const SizedBox(height: 12),

                // Scheduled text
                Text(
                  'Scheduled Daily Practice',
                  style: AppTextStyles.titleMedium(color: AppColors.primary)
                      .copyWith(letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),

                // Incoming call text
                Text(
                  'Incoming AI Call...',
                  style: AppTextStyles.bodyMedium(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),

            // Action buttons (Remind Me / Message)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionButton(
                    icon: Icons.alarm,
                    label: 'REMIND ME',
                    onTap: () {
                      // TODO: Remind me action
                    },
                  ),
                  const SizedBox(width: 64),
                  _ActionButton(
                    icon: Icons.chat_bubble,
                    label: 'MESSAGE',
                    onTap: () {
                      // TODO: Message action
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Accept / Decline buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decline button
                  _CallButton(
                    icon: Icons.call,
                    iconRotation: 135,
                    backgroundColor: AppColors.callRed,
                    label: 'Decline',
                    onTap: () {
                      // Navigate to home and clear stack
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                  ),

                  // Accept button
                  _CallButton(
                    icon: Icons.call,
                    iconRotation: 0,
                    backgroundColor: AppColors.callGreen,
                    label: _isStartingSession ? 'Starting...' : 'Accept',
                    onTap: _isStartingSession ? () {} : _onAcceptCall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bottom indicator
            Container(
              width: 144,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
            child: Icon(
              icon,
              size: 22,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall(
              color: Colors.white.withValues(alpha: 0.5),
            ).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final double iconRotation;
  final Color backgroundColor;
  final String label;
  final VoidCallback onTap;

  const _CallButton({
    required this.icon,
    required this.iconRotation,
    required this.backgroundColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Transform.rotate(
              angle: iconRotation * math.pi / 180,
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: AppTextStyles.bodyMedium(
            color: Colors.white.withValues(alpha: 0.6),
          ).copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
