import 'dart:math';

import 'package:flutter/material.dart';

class CircularSlider extends StatefulWidget {
  final Color progressTrackColor;
  final Color trackColor;
  final Function(double value) onDrag;
  final Function(double value)? onDragEnd;
  final Widget? child;
  final double childHorizontalPadding;
  final double maxAngle;
  final double maxValue;
  final double startAngle;
  final double thumbSize;
  final double trackWidth;
  final double width;
  final double? value;

  const CircularSlider({
    required this.maxValue,
    required this.onDrag,
    this.onDragEnd,
    super.key,
    this.child,
    this.childHorizontalPadding = 40,
    this.maxAngle = 335,
    this.progressTrackColor = const Color(0xFFC00000),
    this.startAngle = 80,
    this.thumbSize = 40,
    this.trackColor = const Color(0xFFE9EAEB),
    this.trackWidth = 30,
    this.value,
    this.width = 250,
  });

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  double _angle = 0;

  @override
  void initState() {
    super.initState();

    if (widget.value != null) {
      _angle = _getAngleBasedOnValue();
    }
  }

  double _getAngleBasedOnValue() {
    if (widget.value == null) {
      return _angle;
    }

    final value = widget.value! < 0 ? 0.0 : min(widget.value!, widget.maxValue);
    return value * widget.maxAngle / widget.maxValue;
  }

  double _getValueBasedOnAngle() {
    return _angle * widget.maxValue / widget.maxAngle;
  }

  void onPanUpdate(DragUpdateDetails details) {
    Offset coordinates = details.localPosition;
    final radius = widget.width / 2;

    setState(() {
      final center = (radius * 2) / 2;

      Offset pureCoordinates = Offset(((coordinates.dx - center) / center),
          ((coordinates.dy - center) / center) * -1);
      final angleTan =
          atan((pureCoordinates.dy.abs()) / (pureCoordinates.dx.abs()));

      _angle = _getAngle(angleTan);
      _angle = _angle.roundToDouble();

      if (!pureCoordinates.dx.isNegative && !pureCoordinates.dy.isNegative) {
        _angle = widget.startAngle - _angle;
      } else if (!pureCoordinates.dx.isNegative &&
          pureCoordinates.dy.isNegative) {
        _angle = widget.startAngle + _angle;
      } else if (pureCoordinates.dx.isNegative &&
          pureCoordinates.dy.isNegative) {
        _angle = widget.startAngle - _angle;
        _angle += 180;
      } else if (pureCoordinates.dx.isNegative &&
          !pureCoordinates.dy.isNegative) {
        _angle = widget.startAngle + _angle;
        _angle += 180;
      }

      if (_angle.isNegative) {
        _angle = 0;
      }
      if (_angle > widget.maxAngle) {
        _angle = widget.maxAngle;
      }

      widget.onDrag(_getValueBasedOnAngle());
    });
  }

  void onPanEnd(DragEndDetails details) {
    final value = _getValueBasedOnAngle();

    if (widget.onDragEnd != null) {
      widget.onDragEnd!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: widget.width,
          height: widget.width,
          child: GestureDetector(
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanEnd,
            child: CustomPaint(
              painter: SliderPainter(
                angle: _getAngleBasedOnValue(),
                trackColor: widget.trackColor,
                progressTrackColor: widget.progressTrackColor,
                trackWidth: widget.trackWidth,
                thumbSize: widget.thumbSize,
                startAngle: widget.startAngle,
                maxAngle: widget.maxAngle,
              ),
            ),
          ),
        ),
        SizedBox(
          width: widget.width -
              widget.trackWidth * 2 -
              widget.childHorizontalPadding,
          height: widget.width -
              widget.trackWidth * 2 -
              widget.childHorizontalPadding,
          child: widget.child,
        )
      ],
    );
  }
}

class SliderPainter extends CustomPainter {
  final Color progressTrackColor;
  final Color trackColor;
  final double angle;
  final double maxAngle;
  final double startAngle;
  final double thumbSize;
  final double trackWidth;

  SliderPainter({
    required this.angle,
    required this.maxAngle,
    required this.progressTrackColor,
    required this.startAngle,
    required this.thumbSize,
    required this.trackColor,
    required this.trackWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width / 2, size.height / 2);
    final halfTrackWidth = trackWidth / 2;
    final thumbRadius = thumbSize / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round;

    final progressTrackPaint = Paint()
      ..color = progressTrackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round;

    final thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final thumbBorderPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final thumbBoxShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final thumbPositionOffset = Offset(
      cos(_getRadians(angle - startAngle)) * (radius - halfTrackWidth),
      sin(_getRadians(angle - startAngle)) * (radius - halfTrackWidth),
    );

    // move canvas to center
    canvas.translate(radius, radius);

    // draw track
    canvas.drawArc(
      Rect.fromCircle(
          center: const Offset(0, 0), radius: radius - halfTrackWidth),
      _getRadians(-startAngle),
      _getRadians(maxAngle),
      false,
      trackPaint,
    );

    // draw progress track
    canvas.drawArc(
      Rect.fromCircle(
          center: const Offset(0, 0), radius: radius - halfTrackWidth),
      _getRadians(-startAngle),
      _getRadians(angle),
      false,
      progressTrackPaint,
    );

    // draw thumb shadow
    canvas.drawCircle(
      thumbPositionOffset,
      thumbRadius,
      thumbBoxShadowPaint,
    );

    // draw thumb border
    canvas.drawCircle(
      thumbPositionOffset,
      thumbRadius,
      thumbBorderPaint,
    );

    // draw thumb
    canvas.drawCircle(
      thumbPositionOffset,
      thumbRadius,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

double _getRadians(double angle) => (angle * pi) / 180;

double _getAngle(double radians) => radians * 180 / pi;
