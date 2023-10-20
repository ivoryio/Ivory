import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/config.dart';

enum TextFieldInputType { text, name, email, number }

class IvoryTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final IvoryTextFieldController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final String? label;
  final String? placeholder;
  final TextCapitalization? textCapitalization;
  final TextFieldInputType inputType;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final bool error;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;

  const IvoryTextField({
    super.key,
    this.controller,
    this.enabled = true,
    this.error = false,
    this.errorText,
    this.focusNode,
    this.inputFormatters,
    this.inputType = TextFieldInputType.text,
    this.keyboardType,
    this.label,
    this.maxLines,
    this.minLines,
    this.obscureText = false,
    this.onChanged,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.textCapitalization,
  });

  @override
  State<IvoryTextField> createState() => _IvoryTextFieldState();
}

class _IvoryTextFieldState extends State<IvoryTextField> {
  late Color _borderColor;
  late FocusNode _focusNode;
  late IvoryTextFieldController _controller;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ??
        IvoryTextFieldController(
          error: widget.error,
          enabled: widget.enabled,
          errorText: widget.errorText,
          obscureText: widget.obscureText,
        );
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

  bool get isEnabled => _controller.isEnabled;
  bool get hasError => _controller.hasError;

  @override
  Widget build(BuildContext context) {
    final keyboardType = _getKeyboardType();
    final inputFormatters = _getInputFormatters();
    final textCapitalization = _getTextCapitalization();

    return ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null) ...[
                Text(
                  widget.label!,
                  style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(
                      color: isEnabled == false
                          ? ClientConfig.getCustomColors().neutral500
                          : hasError
                              ? ClientConfig.getColorScheme().error
                              : ClientConfig.getCustomColors().neutral600),
                ),
                const SizedBox(height: 8),
              ],
              CupertinoTextField(
                focusNode: _focusNode,
                decoration: BoxDecoration(
                  color: hasError && !_focusNode.hasFocus
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
                controller: _controller._textEditingController,
                onChanged: widget.onChanged,
                obscureText: _controller.obscureText,
                placeholder: widget.placeholder,
                enabled: _controller.isEnabled,
                textCapitalization: textCapitalization,
                inputFormatters: inputFormatters,
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
                keyboardType: keyboardType,
                minLines: widget.minLines,
                maxLines: widget.maxLines ?? widget.minLines ?? 1,
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular.copyWith(
                    color: _controller.isEnabled
                        ? ClientConfig.getCustomColors().neutral900
                        : ClientConfig.getCustomColors().neutral500),
                placeholderStyle: ClientConfig.getTextStyleScheme()
                    .bodyLargeRegular
                    .copyWith(color: ClientConfig.getCustomColors().neutral500),
              ),
              if (_controller.errorText != null || widget.errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  _controller.errorText ?? widget.errorText!,
                  style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                        color: ClientConfig.getColorScheme().error,
                      ),
                ),
              ]
            ],
          );
        });
  }

  Color _getBorderColor() {
    if (_controller.isEnabled == false) {
      return ClientConfig.getCustomColors().neutral400;
    } else if (_focusNode.hasFocus) {
      return ClientConfig.getCustomColors().neutral900;
    } else if (_controller.hasError) {
      return ClientConfig.getColorScheme().error;
    } else if (_controller.text.isNotEmpty) {
      return ClientConfig.getCustomColors().neutral500;
    } else {
      return ClientConfig.getCustomColors().neutral400;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.inputFormatters != null) {
      return widget.inputFormatters;
    }

    switch (widget.inputType) {
      case TextFieldInputType.text:
        return null;
      case TextFieldInputType.name:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z .-]')),
        ];
      case TextFieldInputType.email:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
        ];
      case TextFieldInputType.number:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
        ];
      default:
        return null;
    }
  }

  TextInputType? _getKeyboardType() {
    if (widget.keyboardType != null) {
      return widget.keyboardType;
    }

    switch (widget.inputType) {
      case TextFieldInputType.text:
        return TextInputType.text;
      case TextFieldInputType.name:
        return TextInputType.name;
      case TextFieldInputType.email:
        return TextInputType.emailAddress;
      case TextFieldInputType.number:
        return TextInputType.number;
      default:
        return null;
    }
  }

  TextCapitalization _getTextCapitalization() {
    if (widget.textCapitalization != null) {
      return widget.textCapitalization!;
    } else if (widget.inputType == TextFieldInputType.name) {
      return TextCapitalization.words;
    }

    return TextCapitalization.none;
  }
}

class IvoryTextFieldController extends ChangeNotifier {
  late TextEditingController _textEditingController;
  late bool _error;
  late bool _enabled;
  late String? _errorText;
  late bool _obscureText;

  IvoryTextFieldController({
    String? text,
    String? errorText,
    bool error = false,
    bool enabled = true,
    bool obscureText = false,
  }) {
    _textEditingController = TextEditingController(text: text);
    _error = error;
    _enabled = enabled;
    _errorText = errorText;
    _obscureText = obscureText;
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _textEditingController.addListener(listener);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void setError(bool value) {
    if (value == false) {
      _errorText = null;
    }

    _error = value;
    notifyListeners();
  }

  void setErrorText(String? value) {
    _errorText = value;
    _error = value != null;
    notifyListeners();
  }

  void setEnabled(bool value) {
    _enabled = value;
    notifyListeners();
  }

  void setObscureText(bool value) {
    _obscureText = value;
    notifyListeners();
  }

  void clear() {
    _textEditingController.clear();
    notifyListeners();
  }

  bool get isEnabled => _enabled;
  String? get errorText => _errorText;
  bool get obscureText => _obscureText;
  bool get hasError => _errorText != null || _error;
  String get text => _textEditingController.text;
  TextSelection get selection => _textEditingController.selection;
  TextEditingController get textEditingController => _textEditingController;

  set text(String value) {
    _textEditingController.text = value;
    notifyListeners();
  }

  set selection(TextSelection value) {
    _textEditingController.selection = value;
    notifyListeners();
  }
}
