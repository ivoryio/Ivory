import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../config.dart';

class IvoryListItemWithAction extends StatelessWidget {
  final IconData leftIcon;
  late Color? leftIconColor;
  final String actionName;
  final String? actionDescription;
  final IconData rightIcon;
  late Color? rightIconColor;
  final bool actionSwitch;
  final VoidCallback? onPressed;

  IvoryListItemWithAction({
    super.key,
    required this.leftIcon,
    this.leftIconColor,
    required this.actionName,
    this.actionDescription,
    required this.rightIcon,
    this.rightIconColor,
    this.actionSwitch = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    leftIconColor ??= ClientConfig.getColorScheme().secondary;
    rightIconColor ??= ClientConfig.getColorScheme().secondary;

    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!(); // Call the onPressed callback if it's not null
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
                  style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600),
                ),
                if (actionDescription != null)
                  Text(
                    actionDescription!,
                    style: const TextStyle(fontSize: 14, height: 1.29, fontWeight: FontWeight.w400),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 0),
            child:
                (actionSwitch == true)
                ? const ActionItem()
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
  const ActionItem({super.key});

  @override
  State<ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<ActionItem> {
  bool _isSpendingLimitEnabled = false;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 56.0,
      height: 32.0,
      activeColor: Theme.of(context).primaryColor,
      inactiveColor: const Color(0xFFB0B0B0),
      duration: const Duration(milliseconds: 50),
      toggleSize: 24.0,
      value: _isSpendingLimitEnabled,
      padding: 4,
      onToggle: (val) {
        setState(() {
          _isSpendingLimitEnabled = val;
        });
      },
    );
  }
}
