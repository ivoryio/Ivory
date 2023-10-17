import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/platform_text_input.dart';

class CountryPickerPopup extends StatefulWidget {
  final void Function(String value)? onChangedSearch;
  final void Function(String value)? onSubmitSearch;
  const CountryPickerPopup({super.key, required this.onChangedSearch, this.onSubmitSearch});

  @override
  State<CountryPickerPopup> createState() => _CountryPickerPopupState();
}

class _CountryPickerPopupState extends State<CountryPickerPopup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PlatformTextInput(
                hintText: "SSearch prefix or country...",
                icon: Icons.search,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a search term';
                  }
                  return null;
                },
                onChanged: widget.onChangedSearch,
                onSubmit: widget.onSubmitSearch,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
