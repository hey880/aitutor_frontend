import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Circular audio visualizer with animated vertical bars.
class AudioVisualizer extends StatefulWidget {
  final double size;

  const AudioVisualizer({
    super.key,
    this.size = 192,
  });

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  List<double> _barHeights = [0.3, 0.6, 0.9, 0.5, 0.4];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(_updateBars);
    _controller.repeat();
  }

  void _updateBars() {
    setState(() {
      _barHeights = List.generate(5, (_) => 0.2 + _random.nextDouble() * 0.8);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer border circle (scale 110%)
          Container(
            width: widget.size * 1.1,
            height: widget.size * 1.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
          ),

          // Main visualizer circle with gradient and glow
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  Color(0xFF5B96FF),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 4,
                    height: _barHeights[index] * (widget.size * 0.5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.6 + (_barHeights[index] * 0.4),
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
