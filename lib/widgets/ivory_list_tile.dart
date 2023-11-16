import 'package:flutter/material.dart';

import '../config.dart';

class IvoryListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData leftIcon;
  final IconData rightIcon;
  final VoidCallback? onTap;
  final Color? leftIconColor;
  final Color? rightIconColor;
  final Widget? actionItem;
  final EdgeInsetsGeometry? padding;

  const IvoryListTile({
    super.key,
    this.onTap,
    this.padding,
    this.subtitle,
    this.actionItem,
    this.leftIconColor,
    required this.title,
    this.rightIconColor,
    required this.leftIcon,
    this.rightIcon = Icons.arrow_forward_ios,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 16,
              horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding.left,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(leftIcon, color: leftIconColor ?? ClientConfig.getColorScheme().secondary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ClientConfig.getTextStyleScheme().heading4,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 0),
              child: actionItem ??
                  Icon(
                    rightIcon,
                    color: rightIconColor ?? ClientConfig.getColorScheme().secondary,
                    size: 24,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
