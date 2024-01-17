import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SelectOption extends Equatable {
  final Widget? prefix;
  final String textLabel;
  final bool selected;
  final String value;
  final Map<String, dynamic>? data;

  const SelectOption({
    required this.value,
    required this.textLabel,
    this.selected = false,
    this.prefix,
    this.data,
  });

  SelectOption copyWith({
    String? value,
    String? textLabel,
    bool? selected,
    Widget? prefix,
    Map<String, dynamic>? data,
  }) {
    return SelectOption(
      value: value ?? this.value,
      textLabel: textLabel ?? this.textLabel,
      selected: selected ?? this.selected,
      prefix: prefix ?? this.prefix,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [value, textLabel, selected, prefix, data];
}
