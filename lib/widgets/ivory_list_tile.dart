import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class IvoryListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final String? subtitle;
  final IconData? startIcon;
  final Widget? trailingWidget;
  final EdgeInsets? padding;
  final bool rounded;
  final bool hasTrailing;

  const IvoryListTile({
    Key? key,
    this.onTap,
    this.title,
    this.subtitle,
    this.startIcon,
    this.trailingWidget,
    this.padding,
    this.rounded = false,
    this.hasTrailing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: rounded ? BorderRadius.circular(16) : null,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              startIcon,
              color: ClientConfig.getColorScheme().secondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: ClientConfig.getTextStyleScheme().heading4,
                    ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                    )
                ],
              ),
            ),
            if (hasTrailing) ...[
              const SizedBox(width: 16),
              if (trailingWidget == null)
                Icon(
                  Icons.arrow_forward_ios,
                  color: ClientConfig.getColorScheme().tertiary,
                )
              else
                trailingWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
