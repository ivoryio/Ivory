import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/circular_slider.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class CardSpendingCapScreenParams {
  final double maxSpendingCap;

  CardSpendingCapScreenParams({
    this.maxSpendingCap = 1000,
  });
}

class CardSpendingCapScreen extends StatelessWidget {
  static const routeName = "/cardSpendingCapScreen";

  final CardSpendingCapScreenParams params;

  const CardSpendingCapScreen({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings()
              .defaultScreenHorizontalPadding,
        ),
        child: Column(
          children: [
            const AppToolbar(),
            Expanded(
              child: ScrollableScreenContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text("Card spending cap",
                        style: ClientConfig.getTextStyleScheme().heading1),
                    const SizedBox(height: 16),
                    RichText(
                        text: TextSpan(
                      text:
                          "If you exceed this amount, we will alert you through a push notification. Make sure your push notifications are turned on in ",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      children: [
                        TextSpan(
                          text: "Notifications",
                          style: ClientConfig.getTextStyleScheme()
                              .bodyLargeRegularBold
                              .copyWith(
                                color: const Color(0xFF406FE6),
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("tap Notifications");
                            },
                          children: const [
                            TextSpan(
                              text: ".",
                            ),
                          ],
                        ),
                      ],
                    )),
                    const SizedBox(height: 48),
                    Center(
                      child: _SpendingCapSlider(
                        maxValue: params.maxSpendingCap,
                        onChanged: (value) {
                          print("onChanged: $value");
                        },
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                          text: "Confirm spending cap", onPressed: () {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SpendingCapSlider extends StatefulWidget {
  final double maxValue;
  final Function(double) onChanged;

  const _SpendingCapSlider({
    required this.maxValue,
    required this.onChanged,
  });

  @override
  State<_SpendingCapSlider> createState() => _SpendingCapSliderState();
}

class _SpendingCapSliderState extends State<_SpendingCapSlider> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  double _value = 0.00;

  String get _valueText => _value.toStringAsFixed(2);

  String get _maxValueText => widget.maxValue.toStringAsFixed(2);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _valueText);
    _focusNode = FocusNode();

    _controller.addListener(() {
      final value = double.tryParse(_controller.text) ?? 0.00;
      if (value > widget.maxValue) {
        _controller.text = _maxValueText;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }

      setState(() {
        _value = double.tryParse(_controller.text) ?? 0.00;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularSlider(
      width: 280,
      maxValue: widget.maxValue,
      onDrag: (value) {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
        setState(() {
          _value = value;
          _controller.text = _valueText;
        });
      },
      onDragEnd: (value) {
        widget.onChanged(value);
      },
      value: _value,
      trackWidth: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Set cap to",
            style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(
                  color: const Color(0xFF56555E),
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,6}\.?\d{0,2}')),
            ],
            textAlign: TextAlign.center,
            style: ClientConfig.getTextStyleScheme().heading1,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 10),
              isDense: true,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFE9EAEB),
                  width: 2,
                ),
              ),
              hintText: "0",
              hintStyle: ClientConfig.getTextStyleScheme().heading1.copyWith(
                    color: const Color(0xFFC4C4C4),
                  ),
            ),
          ),
          const SizedBox(height: 16),
          // Spacer(),
        ],
      ),
    );
  }
}
