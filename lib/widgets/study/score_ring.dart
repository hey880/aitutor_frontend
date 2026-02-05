import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Circular score ring with percentage display.
/// Used in session detail for pronunciation, intonation, fluency scores.
class ScoreRing extends StatelessWidget {
  final int score;
  final String label;
  final Color color;
  final double size;

  const ScoreRing({
    super.key,
    required this.score,
    required this.label,
    required this.color,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ScoreRingPainter(
              progress: score / 100,
              color: color,
              backgroundColor: AppColors.slate100,
              strokeWidth: 8,
            ),
            child: Center(
              child: Text(
                '$score%',
                style: AppTextStyles.titleMedium(color: color),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.bodySmall(color: AppColors.slate500),
        ),
      ],
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _ScoreRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
