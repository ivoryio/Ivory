import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class CircularLoadingIndicator extends StatefulWidget {
  final double width;
  final List<Color>? gradientColors;
  final double strokeWidth;

  const CircularLoadingIndicator({
    super.key,
    this.width = 50,
    this.gradientColors,
    this.strokeWidth = 15.0,
  });

  @override
  State<CircularLoadingIndicator> createState() => _CircularLoadingIndicatorState();
}

class _CircularLoadingIndicatorState extends State<CircularLoadingIndicator> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    );
    _animationController.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: -1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: CustomPaint(
        size: Size.fromRadius(widget.width / 2),
        painter: CircularLoadingIndicatorPainter(
          radius: widget.width / 2,
          gradientColors: widget.gradientColors ?? [ClientConfig.getColorScheme().secondary, Colors.white],
          strokeWidth: widget.strokeWidth,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CircularLoadingIndicatorPainter extends CustomPainter {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  CircularLoadingIndicatorPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius);
    double offset = strokeWidth / 2;

    Rect rect = Offset(offset, offset) & Size(size.width - strokeWidth, size.height - strokeWidth);

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    paint.shader = SweepGradient(
      colors: gradientColors,
      startAngle: 0.0,
      endAngle: 2 * math.pi,
    ).createShader(rect);

    final thumbPositionOffset = Offset(
      radius + (radius - offset) * math.cos(_getRadians(0.0)),
      radius + (radius - offset) * math.sin(_getRadians(0.0)),
    );

    final thumbPaint = Paint()
      ..color = gradientColors[0]
      ..style = PaintingStyle.fill;

    canvas.drawArc(rect, 0.0, 2 * math.pi, false, paint);

    canvas.drawCircle(
      thumbPositionOffset,
      strokeWidth / 2,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  double _getRadians(double angle) => (angle * math.pi) / 180;
}
