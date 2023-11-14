import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class RadioSelectList extends StatefulWidget {
  final bool toggleable;
  final List<RadioSelectItem> items;
  final void Function(RadioSelectItem?)? onSelectionChanged;
  final ValueNotifier<RadioSelectItem?>? selectedValueNotifier;

  const RadioSelectList({
    super.key,
    required this.items,
    this.onSelectionChanged,
    this.toggleable = false,
    this.selectedValueNotifier,
  });

  @override
  State<RadioSelectList> createState() => _RadioSelectListState();
}

class _RadioSelectListState extends State<RadioSelectList> {
  late final ValueNotifier<RadioSelectItem?> _selectedValue;

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.selectedValueNotifier ?? ValueNotifier<RadioSelectItem?>(null);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = List.empty(growable: true);

    for (var itemIndex = 0; itemIndex < widget.items.length; itemIndex++) {
      final item = widget.items[itemIndex];

      children.add(
        ValueListenableBuilder(
          valueListenable: _selectedValue,
          builder: (context, value, child) {
            final isItemSelected = value == item;

            return RadioSelectListTile(
              item: item,
              isItemSelected: isItemSelected,
              onTap: () {
                final newSelectedValue = isItemSelected && widget.toggleable ? null : item.value;
                widget.onSelectionChanged?.call(newSelectedValue != null ? item : null);
                _selectedValue.value = newSelectedValue != null ? item : null;
              },
            );
          },
        ),
      );

      if (itemIndex < widget.items.length - 1) {
        children.add(const SizedBox(height: 16));
      }
    }

    return Column(
      children: children,
    );
  }
}

class RadioSelectItem extends Equatable {
  final String title;
  final String subtitle;
  final String timeEstimation;
  final String value;

  const RadioSelectItem({
    required this.title,
    required this.subtitle,
    required this.timeEstimation,
    required this.value,
  });

  @override
  List<Object?> get props => [title, subtitle, timeEstimation, value];
}

class RadioIndicator extends StatelessWidget {
  final bool selected;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color backgroundColor;
  final Duration animationDuration;

  const RadioIndicator({
    super.key,
    this.selected = false,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        border: Border.all(
          color: selected
              ? selectedColor ?? ClientConfig.getColorScheme().secondary
              : unselectedColor ?? ClientConfig.getCustomColors().neutral600,
          width: 1,
        ),
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.fastOutSlowIn,
          height: selected ? 12 : 0,
          width: selected ? 12 : 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: selected ? selectedColor ?? ClientConfig.getColorScheme().secondary : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class RadioSelectListTile extends StatelessWidget {
  final RadioSelectItem item;
  final bool isItemSelected;
  final VoidCallback? onTap;

  const RadioSelectListTile({super.key, required this.item, required this.isItemSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isItemSelected ? ClientConfig.getColorScheme().secondary : ClientConfig.getCustomColors().neutral200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioIndicator(selected: isItemSelected),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: ClientConfig.getTextStyleScheme()
                              .labelMedium
                              .copyWith(color: ClientConfig.getCustomColors().neutral900),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.timeEstimation,
                        style: ClientConfig.getTextStyleScheme()
                            .labelCaps
                            .copyWith(color: ClientConfig.getCustomColors().neutral700),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.alarm, size: 18, color: ClientConfig.getCustomColors().neutral700),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: ClientConfig.getTextStyleScheme()
                        .bodySmallRegular
                        .copyWith(color: ClientConfig.getCustomColors().neutral900),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
