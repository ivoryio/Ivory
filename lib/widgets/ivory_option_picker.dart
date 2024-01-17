import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/select_option.dart';
import 'package:solarisdemo/utilities/debouncer.dart';
import 'package:solarisdemo/widgets/custom_builder.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';

class IvoryOptionPicker extends StatefulWidget {
  final IvorySelectOptionController controller;
  final String searchFieldPlaceholder;
  final void Function(SelectOption)? onOptionSelected;
  final void Function(String)? onSearchChanged;
  final bool enabledSearch;
  final bool filterOptions;
  final bool expanded;
  final String searchFieldInitialText;

  const IvoryOptionPicker({
    super.key,
    required this.controller,
    this.onOptionSelected,
    this.enabledSearch = true,
    this.filterOptions = true,
    this.searchFieldPlaceholder = "Search",
    this.onSearchChanged,
    this.expanded = false,
    this.searchFieldInitialText = "",
  });

  @override
  State<IvoryOptionPicker> createState() => _IvoryOptionPickerState();
}

class _IvoryOptionPickerState extends State<IvoryOptionPicker> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final initialText =
        widget.searchFieldInitialText.isEmpty ? widget.controller.searchText : widget.searchFieldInitialText;

    return CustomBuilder(
      builder: (BuildContext context, child) {
        if (widget.expanded) {
          return Expanded(child: child!);
        }

        return child!;
      },
      child: Column(
        children: [
          if (widget.enabledSearch) ...[
            Padding(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: IvoryTextField(
                placeholder: widget.searchFieldPlaceholder,
                initialText: initialText,
                suffix: Icon(Icons.search, color: ClientConfig.getCustomColors().neutral700, size: 20),
                onChanged: (value) {
                  widget.onSearchChanged?.call(value);

                  if (widget.filterOptions) {
                    _debouncer.run(
                      () {
                        if (value.isEmpty) {
                          widget.controller.resetFilter();
                          return;
                        }

                        widget.controller.filterOptionsByText(value);
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          ListenableBuilder(
            listenable: widget.controller,
            builder: (context, child) {
              if (widget.controller.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: ClientConfig.getCustomColors().neutral700,
                  ),
                );
              }

              return _buildListView(options: widget.controller.options);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView({required List<SelectOption> options}) {
    if (options.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: Text(
          "No results found",
          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
        ),
      );
    }

    return CustomBuilder(
      builder: (context, child) {
        if (widget.expanded) {
          return Expanded(child: child!);
        }

        return child!;
      },
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          SelectOption option = options[index];

          return _BottomSheetOption(
            key: UniqueKey(),
            textLabel: option.textLabel,
            isSelected: option.selected,
            multiselect: widget.controller.multiselect,
            onTap: () {
              widget.controller.toggleOptionSelection(option, index);
              widget.onOptionSelected?.call(option);
            },
            prefix: option.prefix,
          );
        },
      ),
    );
  }
}

class _BottomSheetOption extends StatefulWidget {
  final String textLabel;
  final bool isSelected;
  final bool multiselect;
  final VoidCallback onTap;
  final Widget? prefix;

  const _BottomSheetOption({
    super.key,
    required this.textLabel,
    required this.isSelected,
    required this.onTap,
    this.multiselect = false,
    this.prefix,
  });

  @override
  State<_BottomSheetOption> createState() => _BottomSheetOptionState();
}

class _BottomSheetOptionState extends State<_BottomSheetOption> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
        if (widget.multiselect) {
          setState(() {
            _isSelected = !_isSelected;
          });
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: _isSelected ? ClientConfig.getCustomColors().neutral100 : null,
          border: Border(
            bottom: _isSelected
                ? BorderSide(
                    color: ClientConfig.getCustomColors().neutral200,
                    width: 1,
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            if (widget.prefix != null) widget.prefix!,
            Expanded(
              child: Text(
                widget.textLabel,
                style: ClientConfig.getTextStyleScheme().heading4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_isSelected) Icon(Icons.check, color: ClientConfig.getCustomColors().success),
          ],
        ),
      ),
    );
  }
}
