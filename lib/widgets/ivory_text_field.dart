import 'dart:developer';

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
  final bool obscureText;
  final String? errorText;
  final bool error;
  final TextCapitalization? textCapitalization;
  final bool enabled;

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
    this.obscureText = false,
    this.enabled = true,
    this.error = false,
    this.textCapitalization,
  }) : super(key: key);

  @override
  State<IvoryTextField> createState() => _IvoryTextFieldState();
}

class _IvoryTextFieldState extends State<IvoryTextField> {
  late Color _borderColor;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    log('widget.error [${widget.error}]');

    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();

    _borderColor = _getBorderColor();

    _focusNode.addListener(onChange);
    _controller.addListener(onChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  void onChange() {
    final newBorderColor = _getBorderColor();
    if (newBorderColor != _borderColor) {
      setState(() {
        _borderColor = newBorderColor;
      });
    }
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
                color: widget.enabled == false
                    ? ClientConfig.getCustomColors().neutral500
                    : widget.error || widget.errorText != null
                        ? ClientConfig.getColorScheme().error
                        : ClientConfig.getCustomColors().neutral600),
          ),
          const SizedBox(height: 8),
        ],
        CupertinoTextField(
          focusNode: _focusNode,
          decoration: BoxDecoration(
            color: widget.error || widget.errorText != null
                ? ClientConfig.getCustomColors().red100
                : ClientConfig.getCustomColors().neutral100,
            border: Border.all(
              color: _borderColor,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          controller: _controller,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          placeholder: widget.placeholder,
          enabled: widget.enabled,
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          prefix: widget.prefix != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: widget.prefix,
                )
              : null,
          suffix: widget.suffix != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: widget.suffix,
                )
              : null,
          keyboardType: widget.keyboardType,
          minLines: widget.minLines,
          maxLines: widget.maxLines ?? widget.minLines ?? 1,
          style: ClientConfig.getTextStyleScheme().bodyLargeRegular.copyWith(
              color: widget.enabled
                  ? ClientConfig.getCustomColors().neutral900
                  : ClientConfig.getCustomColors().neutral500),
          placeholderStyle: ClientConfig.getTextStyleScheme()
              .bodyLargeRegular
              .copyWith(color: ClientConfig.getCustomColors().neutral500),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                  color: ClientConfig.getColorScheme().error,
                ),
          ),
        ]
      ],
    );
  }

  Color _getBorderColor() {
    if (widget.enabled == false) {
      return ClientConfig.getCustomColors().neutral400;
    } else if (widget.error || widget.errorText != null) {
      return const Color(0xFFE61F27);
    } else if (_focusNode.hasFocus && !widget.error) {
      return ClientConfig.getCustomColors().neutral900;
    } else if (_controller.text.isNotEmpty && !widget.error) {
      return ClientConfig.getCustomColors().neutral500;
    } else {
      return ClientConfig.getCustomColors().neutral400;
    }
  }
}
