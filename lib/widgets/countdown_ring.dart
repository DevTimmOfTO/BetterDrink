import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A depleting circular progress ring: starts full and shrinks toward zero
/// as [remaining] approaches zero, out of a total span of [total].
class CountdownRing extends StatelessWidget {
  const CountdownRing({
    super.key,
    required this.remaining,
    required this.total,
    required this.timeLabel,
    required this.subLabel,
    this.size = 260,
  });

  final Duration remaining;
  final Duration total;
  final String timeLabel;
  final String subLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final totalMs = total.inMilliseconds;
    final fraction = totalMs <= 0
        ? 0.0
        : (remaining.inMilliseconds / totalMs).clamp(0.0, 1.0);
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          fraction: fraction,
          trackColor: colorScheme.surfaceContainerHighest,
          gradientColors: [colorScheme.primary, colorScheme.tertiary],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeLabel,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                subLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.trackColor,
    required this.gradientColors,
  });

  final double fraction;
  final Color trackColor;
  final List<Color> gradientColors;

  static const double _strokeWidth = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - _strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (fraction > 0) {
      final sweepAngle = 2 * math.pi * fraction;
      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: sweepAngle,
          colors: gradientColors,
          transform: const _StartAtTopRotation(),
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.trackColor != trackColor;
  }
}

/// Rotates a [SweepGradient] so its start angle lines up with 12 o'clock,
/// matching the arc drawn by [Canvas.drawArc] which also starts there.
class _StartAtTopRotation extends GradientTransform {
  const _StartAtTopRotation();

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final center = bounds.center;
    final matrix = Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..rotateZ(-math.pi / 2)
      ..translateByDouble(-center.dx, -center.dy, 0, 1);
    return matrix;
  }
}
