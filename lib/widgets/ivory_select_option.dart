import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';

class IvorySelectOption extends StatefulWidget {
  final String label;
  final String? bottomSheetLabel;
  final List<SelectOption>? options;
  final void Function(SelectOption)? onOptionSelected;
  final IvorySelectOptionController? controller;
  final VoidCallback? onBottomSheetOpened;

  const IvorySelectOption({
    super.key,
    required this.label,
    required this.bottomSheetLabel,
    this.options,
    this.onOptionSelected,
    this.controller,
    this.onBottomSheetOpened,
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
        final List<SelectOption> selectedOptions = _controller.selectedOptions;
        List<Widget> prefixItems = List.empty(growable: true);
        for (final option in selectedOptions) {
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
                        color: selectedOptions.isNotEmpty
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
                      if (selectedOptions.isNotEmpty)
                        Expanded(
                          child: Text(
                            selectedOptions.map((e) => e.textLabel).join(", "),
                            style: ClientConfig.getTextStyleScheme()
                                .bodyLargeRegular
                                .copyWith(color: ClientConfig.getCustomColors().neutral700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        Text(
                          widget.bottomSheetLabel ?? widget.label,
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
    widget.onBottomSheetOpened?.call();

    showBottomModal(
      context: context,
      title: "Select your preferred title",
      addContentPadding: false,
      useSafeArea: true,
      isScrollControlled: true,
      content: Column(
        children: [
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: IvoryTextField(
              placeholder: "Search country",
              onChanged: (value) {
                _controller.setLoading(true);
                final List<SelectOption> filteredOptions = _controller.options
                    .where((option) => option.textLabel.toLowerCase().contains(value.toLowerCase()))
                    .toList();
                _controller.setOptions(filteredOptions);
                _controller.setLoading(false);
              },
            ),
          ),
          SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.options.length,
            itemBuilder: (context, index) {
              final SelectOption option = _controller.options[index];
              return _BottomSheetOption(
                textLabel: option.textLabel,
                isSelected: option.selected,
                multiselect: widget.controller?.multiselect ?? false,
                onTap: () {
                  _controller.selectOption(option);
                  widget.onOptionSelected?.call(option);
                },
                prefix: option.prefix,
              );
            },
          ),
        ],
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

  final List<SelectOption> _options;

  IvorySelectOptionController({
    this.multiselect = false,
    bool loading = false,
    List<SelectOption>? options,
  })  : _options = options ?? List.empty(growable: true),
        _loading = loading;

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

  bool get loading => _loading;
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

class _BottomSheetContent extends StatefulWidget {
  const _BottomSheetContent({super.key});

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
