import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../config.dart';
import 'platform_text_input.dart';

class CustomSearchBar extends StatelessWidget {
  final void Function() onPressedFilterButton;
  final bool showButtonIndicator;
  final void Function(String value)? onChangedSearch;
  final void Function(String value)? onSubmitSearch;
  final String? textLabel;
  final String? hintText;

  const CustomSearchBar({
    super.key,
    required this.onPressedFilterButton,
    this.showButtonIndicator = false,
    required this.onChangedSearch,
    this.onSubmitSearch,
    this.textLabel,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PlatformTextInput(
            hintText: hintText ?? "Search by name, date",
            icon: Icons.search,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a search term';
              }
              return null;
            },
            onChanged: onChangedSearch,
            onSubmit: onSubmitSearch,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color:  ClientConfig.getColorScheme().primary,
                ),
              ),
              child: PlatformIconButton(
                icon: SvgPicture.asset(
                  "assets/icons/filter_icon.svg",
                  colorFilter: ColorFilter.mode(ClientConfig.getColorScheme().primary, BlendMode.srcIn),
                  height: 16,
                  width: 16,
                ),
                onPressed: onPressedFilterButton,
              ),
            ),
            if (showButtonIndicator)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                      color: const Color(0xff2BCCFF),
                      borderRadius: BorderRadius.circular(100)),
                ),
              )
          ]),
        ),
      ],
    );
  }
}
