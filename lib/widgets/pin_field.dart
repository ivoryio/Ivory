import 'package:flutter/material.dart';

class PinField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;

  const PinField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  PinFieldState createState() => PinFieldState();
}

class PinFieldState extends State<PinField> {
  bool _hasText = false;
  bool _isInvalid = false;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
    widget.onChanged(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: decideColor(),
            shape: BoxShape.circle,
          ),
          child: TextField(
            focusNode: widget.focusNode,
            controller: widget.controller,
            maxLength: 1,
            keyboardType: TextInputType.number,
            obscureText: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 0),
            decoration: const InputDecoration(
              counterText: "",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
            showCursor: false,
          ),
        ),
      ],
    );
  }

  void setFieldInvalid() {
    setState(() {
      _isInvalid = true;
    });
  }

  void setFieldValid() {
    setState(() {
      _isInvalid = false;
    });
  }

  void setFieldDone() {
    setState(() {
      _isDone = true;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    super.dispose();
  }

  decideColor() {
    if (_isInvalid) {
      return const Color(0xFFE61F27);
    } else if (_isDone) {
      return const Color(0xFF00774C);
    } else if (_hasText) {
      return const Color(0xFF15141E);
    } else {
      return const Color(
        0xFFADADB4,
      );
    }
  }
}

// ignore: must_be_immutable
class FourDigitPinCodeInput extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  late String pin;

  FourDigitPinCodeInput({
    super.key,
    required this.onCompleted,
  });

  @override
  FourDigitPinCodeInputState createState() => FourDigitPinCodeInputState();
}

class FourDigitPinCodeInputState extends State<FourDigitPinCodeInput> {
  FocusNode focusNode = FocusNode();
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List<FocusNode>.generate(4, (index) => FocusNode());

  List<GlobalKey<PinFieldState>> pinFieldKeys = List.generate(
    4,
    (_) => GlobalKey<PinFieldState>(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 146,
      height: 10,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<PinField>.generate(
          _controllers.length,
          (index) => PinField(
            key: pinFieldKeys[index],
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (text) {
              if (text.isNotEmpty && index < _controllers.length - 1) {
                _focusNodes[index].unfocus();
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else if (index == _controllers.length - 1 && text.isNotEmpty) {
                String pin = _controllers.map((c) => c.text).join();
                setState(() {
                  widget.pin = pin;
                });
                widget.onCompleted(pin);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void clearPin() {
    for (var controller in _controllers) {
      controller.clear();
    }
  }

  void setFocusOnFirst() {
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  void unfocusAllFields() {
    for (var focusNode in _focusNodes) {
      focusNode.unfocus();
    }
  }

  void toggleValidity() {
    setAllFieldsInvalid();
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        if (mounted) {
          setAllFieldsValid();
        }
      },
    );
  }

  void setAllFieldsValid() {
    for (var pinFieldKey in pinFieldKeys) {
      pinFieldKey.currentState!.setFieldValid();
    }
  }

  void setAllFieldsInvalid() {
    for (var pinField in pinFieldKeys) {
      pinField.currentState!.setFieldInvalid();
    }
  }

  void setAllFieldsDone() {
    for (var pinField in pinFieldKeys) {
      pinField.currentState!.setFieldDone();
    }
  }
}
