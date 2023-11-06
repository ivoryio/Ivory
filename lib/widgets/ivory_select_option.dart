import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/utilities/debouncer.dart';
import 'package:solarisdemo/widgets/ivory_builder.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';

class IvorySelectOption extends StatefulWidget {
  final String label;
  final String? bottomSheetTitle;
  final bool enabledSearch;
  final String placeholder;
  final String searchFieldPlaceholder;
  final List<SelectOption>? options;
  final void Function(SelectOption)? onOptionSelected;
  final IvorySelectOptionController? controller;
  final void Function(String)? onSearchChanged;
  final VoidCallback? onBottomSheetOpened;
  final bool filterOptions;
  final bool bottomSheetExpanded;

  const IvorySelectOption({
    super.key,
    required this.label,
    required this.bottomSheetTitle,
    this.options,
    this.onOptionSelected,
    this.controller,
    this.placeholder = "Select an option",
    this.searchFieldPlaceholder = "Search",
    this.onBottomSheetOpened,
    this.enabledSearch = false,
    this.onSearchChanged,
    this.filterOptions = true,
    this.bottomSheetExpanded = false,
  });

  @override
  State<IvorySelectOption> createState() => _IvorySelectOptionState();
}

class _IvorySelectOptionState extends State<IvorySelectOption> {
  late IvorySelectOptionController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? IvorySelectOptionController();

    if (widget.options != null) {
      _controller.setOptions(widget.options!);
    }
  }

  @override
  void dispose() {
    // dispose only if controller is not provided
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final bool isLoading = _controller.loading;

        List<Widget> prefixItems = List.empty(growable: true);
        for (final option in _controller.selectedOptions) {
          if (option.prefix != null) {
            prefixItems.add(option.prefix!);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: ClientConfig.getTextStyleScheme().labelSmall),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _onTap,
              child: Container(
                  decoration: BoxDecoration(
                    color: ClientConfig.getCustomColors().neutral100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _controller.selectedOptions.isNotEmpty
                            ? ClientConfig.getCustomColors().neutral500
                            : ClientConfig.getCustomColors().neutral400),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (prefixItems.isNotEmpty) ...[
                        ...prefixItems,
                        const SizedBox(width: 8),
                      ],
                      if (_controller.selectedOptions.isNotEmpty)
                        Expanded(
                          child: Text(
                            _controller.selectedOptions.map((e) => e.textLabel).join(", "),
                            style: ClientConfig.getTextStyleScheme()
                                .bodyLargeRegular
                                .copyWith(color: ClientConfig.getCustomColors().neutral900),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        Text(
                          widget.placeholder,
                          style: ClientConfig.getTextStyleScheme()
                              .bodyLargeRegular
                              .copyWith(color: ClientConfig.getCustomColors().neutral500),
                        ),
                      const SizedBox(width: 8),
                      isLoading
                          ? SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: ClientConfig.getCustomColors().neutral700,
                              ),
                            )
                          : Icon(Icons.keyboard_arrow_down, color: ClientConfig.getCustomColors().neutral700),
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  void _onTap() {
    if (_controller.loading || !_controller.enabled) {
      return;
    }

    widget.onBottomSheetOpened?.call();

    showBottomModal(
      context: context,
      title: widget.bottomSheetTitle,
      addContentPadding: false,
      useSafeArea: true,
      useScrollableChild: false,
      content: IvoryOptionPicker(
        controller: _controller,
        enabledSearch: widget.enabledSearch,
        searchFieldPlaceholder: widget.searchFieldPlaceholder,
        onSearchChanged: widget.onSearchChanged,
        filterOptions: widget.filterOptions,
        expanded: widget.bottomSheetExpanded,
        onOptionSelected: (option) {
          _controller.selectOption(option);
          widget.onOptionSelected?.call(option);
        },
      ),
    );
  }
}

class IvoryOptionPicker extends StatefulWidget {
  final IvorySelectOptionController controller;
  final String searchFieldPlaceholder;
  final void Function(SelectOption) onOptionSelected;
  final void Function(String)? onSearchChanged;
  final bool enabledSearch;
  final bool filterOptions;
  final bool expanded;

  const IvoryOptionPicker({
    super.key,
    required this.controller,
    required this.onOptionSelected,
    required this.enabledSearch,
    required this.searchFieldPlaceholder,
    required this.filterOptions,
    this.onSearchChanged,
    this.expanded = false,
  });

  @override
  State<IvoryOptionPicker> createState() => _IvoryOptionPickerState();
}

class _IvoryOptionPickerState extends State<IvoryOptionPicker> {
  late List<SelectOption> _filteredOptions;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _filteredOptions = widget.controller.options;
  }

  @override
  Widget build(BuildContext context) {
    return IvoryBuilder(
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
                suffix: Icon(Icons.search, color: ClientConfig.getCustomColors().neutral700, size: 20),
                onChanged: (value) {
                  widget.onSearchChanged?.call(value);

                  if (widget.filterOptions) {
                    _debouncer.run(
                      () => setState(() {
                        _filteredOptions = widget.controller.options
                            .where((option) => option.textLabel.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      }),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          widget.filterOptions
              ? _buildListView(options: _filteredOptions)
              : ListenableBuilder(
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

                    return _buildListView(options: _filteredOptions);
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

    return IvoryBuilder(
      builder: (context, child) {
        if (widget.expanded) {
          return Expanded(child: child!);
        }

        return child!;
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          SelectOption option = options[index];

          return _BottomSheetOption(
            key: UniqueKey(),
            textLabel: option.textLabel,
            isSelected: option.selected,
            multiselect: widget.controller.multiselect,
            onTap: () {
              widget.onOptionSelected(option);
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
        child: Row(
          children: [
            if (widget.prefix != null) widget.prefix!,
            Text(widget.textLabel, style: ClientConfig.getTextStyleScheme().heading4),
            const Spacer(),
            if (_isSelected) Icon(Icons.check, color: ClientConfig.getCustomColors().success),
          ],
        ),
      ),
    );
  }
}

class IvorySelectOptionController extends ChangeNotifier {
  final bool multiselect;
  bool _loading;
  bool _enabled;

  final List<SelectOption> _options;

  IvorySelectOptionController({
    this.multiselect = false,
    bool loading = false,
    bool enabled = true,
    List<SelectOption>? options,
  })  : _options = options ?? List.empty(growable: true),
        _loading = loading,
        _enabled = enabled;

  void setOptions(List<SelectOption> options) {
    _options.clear();
    _options.addAll(options);

    notifyListeners();
  }

  void selectOption(SelectOption selectedOption) {
    for (int optionIndex = 0; optionIndex < _options.length; optionIndex++) {
      SelectOption option = _options[optionIndex];
      if (selectedOption.value == option.value) {
        _options[optionIndex] = option.copyWith(selected: !option.selected);
      } else {
        _options[optionIndex] = multiselect ? option : option.copyWith(selected: false);
      }
    }

    notifyListeners();
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setEnabled(bool enabled) {
    _enabled = enabled;
    notifyListeners();
  }

  void reset() {
    _options.clear();
    _loading = false;
    _enabled = true;

    notifyListeners();
  }

  bool get loading => _loading;
  bool get enabled => _enabled;
  List<SelectOption> get options => _options;
  List<SelectOption> get selectedOptions => _options.where((option) => option.selected).toList();
}

class SelectOption extends Equatable {
  final Widget? prefix;
  final String textLabel;
  final bool selected;
  final String value;

  const SelectOption({
    required this.value,
    required this.textLabel,
    this.selected = false,
    this.prefix,
  });

  SelectOption copyWith({
    String? value,
    String? textLabel,
    bool? selected,
    Widget? prefix,
  }) {
    return SelectOption(
      value: value ?? this.value,
      textLabel: textLabel ?? this.textLabel,
      selected: selected ?? this.selected,
      prefix: prefix ?? this.prefix,
    );
  }

  @override
  List<Object?> get props => [value, textLabel, selected, prefix];
}
