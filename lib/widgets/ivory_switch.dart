import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:solarisdemo/config.dart';

class IvorySwitch extends StatefulWidget {
  final bool initialSwitchValue;
  final Function(bool value)? onChanged;

  const IvorySwitch({
    super.key,
    this.initialSwitchValue = false,
    this.onChanged,
  });

  @override
  State<IvorySwitch> createState() => IvorySwitchState();
}

class IvorySwitchState extends State<IvorySwitch> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.initialSwitchValue;
  }

  toggleSwitch() {
    setState(() {
      _switchValue = !_switchValue;
    });
    widget.onChanged?.call(_switchValue);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 56.0,
      height: 32.0,
      activeColor: ClientConfig.getColorScheme().secondary,
      inactiveColor: const Color(0xFFB0B0B0),
      duration: const Duration(milliseconds: 50),
      toggleSize: 24.0,
      value: _switchValue,
      padding: 4,
      onToggle: (val) {
        setState(() {
          _switchValue = val;
        });
        widget.onChanged?.call(val);
      },
    );
  }
}
