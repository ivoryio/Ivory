import 'package:flutter/cupertino.dart';
import 'package:solarisdemo/config.dart';

class IvoryTextField extends StatefulWidget {
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
  final IvoryTextFieldController? controller;

  const IvoryTextField({
    Key? key,
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
    this.controller,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          final isEnabled = _controller.isEnabled;
          final hasError = widget.error || widget.errorText != null || _controller.errorText != null;

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
                  color: hasError ? ClientConfig.getCustomColors().red100 : ClientConfig.getCustomColors().neutral100,
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
                controller: _controller.textEditingController,
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
    } else if (widget.error || widget.errorText != null || _controller.errorText != null) {
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

class IvoryTextFieldController extends ChangeNotifier {
  late TextEditingController _textEditingController;
  late bool _error;
  late bool _enabled;
  late String? _errorText;

  IvoryTextFieldController({
    String? text,
    String? errorText,
    bool error = false,
    bool enabled = true,
  }) {
    _textEditingController = TextEditingController(text: text);
    _error = error;
    _enabled = enabled;
    _errorText = errorText;
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

  void clear() {
    _textEditingController.clear();
    notifyListeners();
  }

  bool get isEnabled => _enabled;
  String? get errorText => _errorText;
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
