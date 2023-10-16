import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/modal.dart';

class IvorySelectOption extends StatefulWidget {
  final String label;
  final String? bottomSheetLabel;
  final List<SelectOption> options;
  final void Function(SelectOption)? onOptionSelected;
  final IvorySelectOptionController? controller;
  final VoidCallback? onBottomSheetOpened;

  const IvorySelectOption({
    super.key,
    required this.label,
    required this.bottomSheetLabel,
    required this.options,
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
    _controller.init(widget.options);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final List<SelectOption> selectedOptions = _controller.selectedOptions;

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
                      if (selectedOptions.isNotEmpty)
                        Expanded(
                          child: Text(
                            selectedOptions.map((e) => e.label).join(", "),
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
                      Icon(Icons.keyboard_arrow_down, color: ClientConfig.getCustomColors().neutral700),
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
      content: Column(
        children: _controller._options
            .map(
              (option) => _BottomSheetOption(
                label: option.label,
                isSelected: option.selected,
                multiselect: _controller.multiselect,
                onTap: () {
                  _controller.selectOption(option);
                  widget.onOptionSelected?.call(option);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BottomSheetOption extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool multiselect;
  final VoidCallback onTap;

  const _BottomSheetOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.multiselect = false,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: ClientConfig.getTextStyleScheme().heading4),
            if (_isSelected) const Icon(Icons.check, color: Color(0xFF00774C)),
          ],
        ),
      ),
    );
  }
}

class IvorySelectOptionController extends ChangeNotifier {
  final bool multiselect;

  final List<SelectOption> _options;

  IvorySelectOptionController({this.multiselect = false, List<SelectOption>? options})
      : _options = options ?? List.empty(growable: true);

  void init(List<SelectOption> options) {
    _options.clear();
    _options.addAll(options);
  }

  void selectOption(SelectOption selectedOption) {
    for (int optionIndex = 0; optionIndex < _options.length; optionIndex++) {
      SelectOption option = _options[optionIndex];
      if (selectedOption == option) {
        _options[optionIndex] = option.copyWith(selected: !option.selected);
      } else {
        _options[optionIndex] = multiselect ? option : option.copyWith(selected: false);
      }
    }

    notifyListeners();
  }

  List<SelectOption> get options => _options;
  List<SelectOption> get selectedOptions => _options.where((option) => option.selected).toList();
}

class SelectOption extends Equatable {
  final String label;
  final bool selected;
  final String value;

  const SelectOption({
    required this.value,
    required this.label,
    this.selected = false,
  });

  SelectOption copyWith({
    String? value,
    String? label,
    bool? selected,
  }) {
    return SelectOption(
      value: value ?? this.value,
      label: label ?? this.label,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [value, label, selected];

  @override
  bool get stringify => true;
}
