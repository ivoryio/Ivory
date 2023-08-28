import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class IvorySwitch extends StatefulWidget {
  final bool value;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;
  final double toggleSize;
  final double padding;
  final void Function(bool) onToggle;

  const IvorySwitch({
    super.key,
    this.value = false,
    required this.onToggle,
    this.width = 56,
    this.height = 32,
    this.activeColor = Colors.black,
    this.inactiveColor = const Color(0xFFCFD4D9),
    this.duration = const Duration(milliseconds: 100),
    this.toggleSize = 24,
    this.padding = 4,
  });

  @override
  State<IvorySwitch> createState() => _IvorySwitchState();
}

class _IvorySwitchState extends State<IvorySwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: widget.width,
      height: widget.height,
      activeColor: Colors.black,
      inactiveColor: const Color(0xFFCFD4D9),
      duration: widget.duration,
      toggleSize: widget.toggleSize,
      value: _value,
      padding: widget.padding,
      onToggle: (value) {
        setState(() {
          _value = value;
        });
        widget.onToggle(value);
      },
    );
  }
}
