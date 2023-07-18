import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/pin_field.dart';
import '../../widgets/screen.dart';

class BankCardDetailsChoosePinScreen extends StatelessWidget {
  const BankCardDetailsChoosePinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'BankDetailsChoosePinScreen',
      centerTitle: true,
      hideBackButton: false,
      hideBottomNavbar: true,
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedColumn(
              space: 32,
              children: [
                const Text('BankDetailsChoosePinScreen'),
                SpacedColumn(
                  space: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose PIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    const Text(
                      'Remember your PIN as you will use it for all future card purchases.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    PinCodeInput(
                      onCompleted: (pin) {
                        context.read<BankCardDetailsCubit>().choosePin(
                              state.card!,
                              pin,
                            );
                      },
                    ),
                  ],
                )
              ],
            ),
            SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 10,
              children: [
                const Text(
                  'Your PIN should not contain:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 0,
                  children: const [
                    Row(
                      children: [
                        Icon(
                          Icons.close,
                          size: 24,
                        ),
                        Text(
                          'Your date of birth',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.close,
                          size: 24,
                        ),
                        Text(
                          'Your postal code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.close,
                          size: 24,
                        ),
                        Text(
                          'Number sequences, e.g. 1234',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.close,
                          size: 24,
                        ),
                        Text(
                          'More than two digits repeating',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Insert 4 digit for PIN",
                    onPressed: () {
                      // context.read<BankCardDetailsCubit>().initializeActivation();
                      context
                          .read<BankCardDetailsCubit>()
                          .choosePin(state.card!, "0000");
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PinCodeInput extends StatefulWidget {
  final ValueChanged<String> onCompleted;

  const PinCodeInput({super.key, required this.onCompleted});

  @override
  PinCodeInputState createState() => PinCodeInputState();
}

class PinCodeInputState extends State<PinCodeInput> {
  FocusNode focusNode = FocusNode();
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List<FocusNode>.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('Focus');
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List<Widget>.generate(
        _controllers.length,
        (index) => PinField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onChanged: (text) {
            if (text.isNotEmpty && index < _controllers.length - 1) {
              log('Unfocus');
              _focusNodes[index].unfocus();
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else if (index == _controllers.length - 1 && text.isNotEmpty) {
              if (!_checkPinCompleted()) {
                print('Invalid pin');
              } else {
                widget.onCompleted(_controllers.map((c) => c.text).join());
                print('Valid pin');
              }
            }
          },
        ),
      ),
    );
  }

  bool _checkPinCompleted() {
    // validations here
    var pinCode = _controllers.map((c) => c.text).join();
    if (pinCode.length == 4 && pinCode != "0000") {
      return true;
    }
    return false;
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
}
