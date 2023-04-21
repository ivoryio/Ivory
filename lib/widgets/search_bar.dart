import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'platform_text_input.dart';

class SearchBar extends StatelessWidget {
  final void Function() onPressedFilterButton;
  final bool showButtonIndicator;

  const SearchBar({
    super.key,
    required this.onPressedFilterButton,
    this.showButtonIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PlatformTextInput(
            hintText: "Search here...",
            icon: Icons.search,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a search term';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black,
              ),
              child: PlatformIconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.filter_alt, color: Colors.white),
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
