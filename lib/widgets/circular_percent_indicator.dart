import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class CircularPercentIndicator extends StatefulWidget {
  final double percent;

  const CircularPercentIndicator({super.key, required this.percent});

  @override
  State<CircularPercentIndicator> createState() => _CircularPercentIndicatorState();
}

class _CircularPercentIndicatorState extends State<CircularPercentIndicator> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CircularProgressIndicator(
                value: controller.value * widget.percent,
                strokeWidth: 5,
                backgroundColor: ClientConfig.getCustomColors().neutral200,
                valueColor: AlwaysStoppedAnimation<Color>(ClientConfig.getColorScheme().secondary),
              ),
            ),
            Center(
              child: Text(
                '${(widget.percent * 100).toInt()} %',
                style: ClientConfig.getTextStyleScheme().labelSmall,
              ),
            )
          ],
        );
      },
    );
  }
}
