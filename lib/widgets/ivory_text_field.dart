import 'package:flutter/cupertino.dart';

class IvoryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;

  const IvoryTextField({
    Key? key,
    this.controller,
    this.onChanged,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.minLines,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        border: Border.all(
          color: const Color(0xFFADADB4),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      controller: controller,
      onChanged: onChanged,
      placeholder: placeholder,
      prefix: prefix,
      suffix: suffix,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines ?? minLines ?? 1,
    );
  }
}
