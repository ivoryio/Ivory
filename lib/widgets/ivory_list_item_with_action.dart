import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../config.dart';

// ignore: must_be_immutable
class IvoryListItemWithAction extends StatelessWidget {
  final IconData leftIcon;
  late Color? leftIconColor;
  final String actionName;
  final String? actionDescription;
  final IconData rightIcon;
  late Color? rightIconColor;
  final bool? actionSwitch;
  final VoidCallback? onPressed;
  final GlobalKey<ActionItemState> switchKey = GlobalKey<ActionItemState>();

  IvoryListItemWithAction({
    super.key,
    required this.leftIcon,
    this.leftIconColor,
    required this.actionName,
    this.actionDescription,
    required this.rightIcon,
    this.rightIconColor,
    this.actionSwitch,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    leftIconColor ??= ClientConfig.getColorScheme().secondary;
    rightIconColor ??= ClientConfig.getColorScheme().secondary;

    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
        if (actionSwitch != null) {
          switchKey.currentState!.toggleSwitch();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(leftIcon, color: leftIconColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actionName,
                  style: ClientConfig.getTextStyleScheme().heading4,
                ),
                if (actionDescription != null)
                  Text(
                    actionDescription!,
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 0),
            child: (actionSwitch != null)
                ? ActionItem(
                    key: switchKey,
                    initialSwitchValue: actionSwitch!,
                  )
                : Icon(
                    rightIcon,
                    color: rightIconColor,
                    size: 24,
                  ),
          ),
        ],
      ),
    );
  }
}

class ActionItem extends StatefulWidget {
  final bool initialSwitchValue;
  const ActionItem({super.key, required this.initialSwitchValue});

  @override
  State<ActionItem> createState() => ActionItemState();
}

class ActionItemState extends State<ActionItem> {
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
      },
    );
  }
}
