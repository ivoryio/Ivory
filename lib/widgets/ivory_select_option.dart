import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/select_option.dart';

import 'package:solarisdemo/widgets/ivory_option_picker.dart';

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
  final String searchFieldInitialText;
  final bool statusbarVisibilityForTallModal;

  const IvorySelectOption({
    super.key,
    required this.label,
    required this.bottomSheetTitle,
    this.options,
    this.onOptionSelected,
    this.controller,
    this.placeholder = "Select an option",
    this.searchFieldPlaceholder = "Search",
    this.searchFieldInitialText = "",
    this.onBottomSheetOpened,
    this.enabledSearch = false,
    this.onSearchChanged,
    this.filterOptions = true,
    this.bottomSheetExpanded = false,
    this.statusbarVisibilityForTallModal = false,
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
                        ...prefixItems.take(3).toList(),
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
      statusbarVisibilityForTallModal: widget.statusbarVisibilityForTallModal,
      useScrollableChild: false,
      content: IvoryOptionPicker(
        controller: _controller,
        enabledSearch: widget.enabledSearch,
        searchFieldPlaceholder: widget.searchFieldPlaceholder,
        searchFieldInitialText: widget.searchFieldInitialText,
        onSearchChanged: widget.onSearchChanged,
        filterOptions: widget.filterOptions,
        expanded: widget.bottomSheetExpanded,
        onOptionSelected: (option) {
          widget.onOptionSelected?.call(option);
        },
      ),
    );
  }
}

class IvorySelectOptionController extends ChangeNotifier {
  bool _loading;
  bool _enabled;
  bool multiselect;
  String _searchText = "";

  final List<SelectOption> _options;
  final List<SelectOption> _initialOptions;
  final List<SelectOption> _selectedOptions = List.empty(growable: true);

  IvorySelectOptionController({
    this.multiselect = false,
    bool loading = false,
    bool enabled = true,
    List<SelectOption>? options,
  })  : _options = options ?? List.empty(growable: true),
        _initialOptions = options ?? List.empty(growable: true),
        _loading = loading,
        _enabled = enabled;

  void setOptions(List<SelectOption> options) {
    _options.clear();
    _initialOptions.clear();

    _options.addAll(options);
    _initialOptions.addAll(options);

    notifyListeners();
  }

  void toggleOptionSelection(SelectOption selectedOption, int index) {
    if (selectedOption.selected) {
      _selectedOptions.removeWhere((element) => element.value == selectedOption.value);

      final optionIndex = _options.indexWhere((element) => element.value == selectedOption.value);
      _options[optionIndex] = _options[optionIndex].copyWith(selected: false);
    } else {
      if (!multiselect) {
        _selectedOptions.clear();
        for (int optionIndex = 0; optionIndex < _options.length; optionIndex++) {
          _options[optionIndex] = _options[optionIndex].copyWith(selected: false);
        }
      }

      _selectedOptions.add(selectedOption.copyWith(selected: true));
    }

    _options.removeWhere((option) => selectedOptions.any((element) => element.value == option.value));
    _options.insertAll(0, selectedOptions);

    notifyListeners();
  }

  void filterOptionsByText(String searchText) {
    _searchText = searchText;

    final filtered = List<SelectOption>.empty(growable: true);
    for (int optionIndex = 0; optionIndex < _initialOptions.length; optionIndex++) {
      final option = _initialOptions[optionIndex];
      final isSelected = selectedOptions.any((element) => element.value == option.value);

      if (option.textLabel.toLowerCase().contains(searchText.toLowerCase())) {
        filtered.add(option.copyWith(selected: isSelected));
      }
    }

    _options.clear();
    _options.addAll(filtered);

    notifyListeners();
  }

  void resetFilter() {
    _searchText = "";

    final options = List<SelectOption>.empty(growable: true);
    for (int optionIndex = 0; optionIndex < _initialOptions.length; optionIndex++) {
      final option = _initialOptions[optionIndex];
      final isSelected = selectedOptions.any((element) => element.value == option.value);

      if (isSelected) {
        options.insert(0, option.copyWith(selected: true));
      } else {
        options.add(option);
      }
    }

    _options.clear();
    _options.addAll(options);
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
  String get searchText => _searchText;
  List<SelectOption> get options => _options;
  List<SelectOption> get selectedOptions => _selectedOptions;
}
