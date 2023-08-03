import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class YvoryListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final String? subtitle;
  final IconData? startIcon;
  final EdgeInsets? padding;
  final bool rounded;

  const YvoryListTile({
    Key? key,
    this.onTap,
    this.title,
    this.subtitle,
    this.startIcon,
    this.padding,
    this.rounded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: rounded ? BorderRadius.circular(16) : null,
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 16,
              horizontal: ClientConfig.getCustomClientUiSettings()
                  .defaultScreenHorizontalPadding,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              startIcon,
              color: const Color(0xFFCC0000),
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
                      style: const TextStyle(
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 18 / 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF56555E),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF000000),
            )
          ],
        ),
      ),
    );
  }
}
