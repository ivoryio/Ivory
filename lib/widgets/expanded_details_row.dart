import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class ExpandedDetailsRow extends StatelessWidget {
  final String title;
  final String? trailing;
  final Widget? trailingWidget;
  final VoidCallback? onInfoIconTap;

  const ExpandedDetailsRow({
    super.key,
    required this.title,
    required this.trailing,
    this.trailingWidget,
    this.onInfoIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
        ),
        if (onInfoIconTap != null) ...[
          const SizedBox(width: 4),
          InfoIconButton(onTap: onInfoIconTap),
        ],
        const Spacer(),
        if (trailing != null)
          Text(
            trailing!,
            style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
          ),
        if (trailingWidget != null) trailingWidget!,
      ],
    );
  }
}

class InfoIconButton extends StatelessWidget {
  final VoidCallback? onTap;

  const InfoIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.info_outline_rounded),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
