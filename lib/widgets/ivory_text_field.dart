import 'package:flutter/cupertino.dart';
import 'package:solarisdemo/config.dart';

class IvoryTextField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final FocusNode? focusNode;
  final String? label;
  final String? errorText;

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
    this.focusNode,
    this.label,
    this.errorText,
  }) : super(key: key);

  @override
  State<IvoryTextField> createState() => _IvoryTextFieldState();
}

class _IvoryTextFieldState extends State<IvoryTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();

    _focusNode.addListener(() => setState(() {}));
    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(
                color: widget.errorText != null
                    ? ClientConfig.getCustomColors().error
                    : ClientConfig.getCustomColors().neutral600),
          ),
          const SizedBox(height: 8),
        ],
        CupertinoTextField(
          focusNode: _focusNode,
          decoration: BoxDecoration(
            color: widget.errorText != null
                ? ClientConfig.getCustomColors().red100
                : ClientConfig.getCustomColors().neutral100,
            border: Border.all(
              color: _getBorderColor(),
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.prefix != null || widget.suffix != null ? 8 : 16,
            vertical: 12,
          ),
          controller: _controller,
          onChanged: widget.onChanged,
          placeholder: widget.placeholder,
          prefix: widget.prefix != null ? Padding(padding: const EdgeInsets.only(left: 8), child: widget.prefix) : null,
          suffix: widget.suffix != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: widget.suffix,
                )
              : null,
          keyboardType: widget.keyboardType,
          minLines: widget.minLines,
          maxLines: widget.maxLines ?? widget.minLines ?? 1,
          style: ClientConfig.getTextStyleScheme()
              .bodyLargeRegular
              .copyWith(color: ClientConfig.getCustomColors().neutral900),
          placeholderStyle: ClientConfig.getTextStyleScheme()
              .bodyLargeRegular
              .copyWith(color: ClientConfig.getCustomColors().neutral500),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: ClientConfig.getTextStyleScheme()
                .bodySmallRegular
                .copyWith(color: ClientConfig.getCustomColors().error),
          ),
        ]
      ],
    );
  }

  Color _getBorderColor() {
    if (widget.errorText != null) {
      return const Color(0xFFE61F27);
    } else if (_focusNode.hasFocus) {
      return ClientConfig.getCustomColors().neutral900;
    } else if (_controller.text.isNotEmpty) {
      return ClientConfig.getCustomColors().neutral500;
    } else {
      return ClientConfig.getCustomColors().neutral400;
    }
  }
}
