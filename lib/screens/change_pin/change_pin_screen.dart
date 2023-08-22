import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class ChangePinScreen extends StatelessWidget {
  static const routeName = "/changePinScreen";

  const ChangePinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> birthdayErrorNotifier = ValueNotifier<bool>(false);
    ValueNotifier<bool> postalCodeErrorNotifier = ValueNotifier<bool>(false);
    ValueNotifier<bool> sequenceErrorNotifier = ValueNotifier<bool>(false);
    ValueNotifier<bool> repeatingErrorNotifier = ValueNotifier<bool>(false);

    return ScreenScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: AppToolbar(
              richTextTitle: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Step 1',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF15141E),
                      ),
                    ),
                    TextSpan(
                      text: " out of 2",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF56555E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const PreferredSize(
            preferredSize: Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: 0.05,
              color: Color(0xFF2575FC),
              backgroundColor: Color(0xFFADADB4),
            ),
          ),
          ChangePinBody(
            birthdayErrorNotifier: birthdayErrorNotifier,
            postalCodeErrorNotifier: postalCodeErrorNotifier,
            sequenceErrorNotifier: sequenceErrorNotifier,
            repeatingErrorNotifier: repeatingErrorNotifier,
          ),
          const Spacer(),
          ChangePinChecks(
            birthdayErrorNotifier: birthdayErrorNotifier,
            postalCodeErrorNotifier: postalCodeErrorNotifier,
            sequenceErrorNotifier: sequenceErrorNotifier,
            repeatingErrorNotifier: repeatingErrorNotifier,
          ),
        ],
      ),
    );
  }
}

class ChangePinBody extends StatefulWidget {
  final ValueNotifier<bool> birthdayErrorNotifier;
  final ValueNotifier<bool> postalCodeErrorNotifier;
  final ValueNotifier<bool> sequenceErrorNotifier;
  final ValueNotifier<bool> repeatingErrorNotifier;

  const ChangePinBody({
    Key? key,
    required this.birthdayErrorNotifier,
    required this.postalCodeErrorNotifier,
    required this.sequenceErrorNotifier,
    required this.repeatingErrorNotifier,
  }) : super(key: key);

  @override
  State<ChangePinBody> createState() => _ChangePinBodyState();
}

class _ChangePinBodyState extends State<ChangePinBody> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusPin = FocusNode();
  String _newPIN = '';
  bool hasError = false;

  bool hasConsecutiveDigits(String pin) {
    if (pin.length < 4) {
      widget.sequenceErrorNotifier.value = false;
      return true;
    }
    for (int i = 0; i < pin.length - 1; i++) {
      int currentDigit = int.parse(pin[i]);
      int nextDigit = int.parse(pin[i + 1]);

      if (nextDigit != currentDigit + 1) {
        widget.sequenceErrorNotifier.value = false;
        return true;
      }
    }
    widget.sequenceErrorNotifier.value = true;
    return false;
  }

  bool hasRepeatingDigits(String pin) {
    if (pin.length < 4) {
      widget.repeatingErrorNotifier.value = false;
      return true;
    }

    Map<String, int> digitCount = {};

    for (int i = 0; i < pin.length; i++) {
      String digit = pin[i];
      digitCount[digit] = (digitCount[digit] ?? 0) + 1;
    }

    for (var value in digitCount.values) {
      if (value > 2) {
        widget.repeatingErrorNotifier.value = true;
        return false;
      }
    }

    widget.repeatingErrorNotifier.value = false;
    return true;
  }

  bool containsPostalCode(String pin, String postalCode) {
    if (pin.length < 4) {
      widget.postalCodeErrorNotifier.value = false;
      return true;
    }
    if (postalCode.contains(_newPIN)) {
      widget.postalCodeErrorNotifier.value = true;
      return false;
    }
    widget.postalCodeErrorNotifier.value = false;
    return true;
  }

  bool containsBirthDate(String pin, DateTime birtDate) {
    if (pin.length < 4) {
      widget.birthdayErrorNotifier.value = false;
      return true;
    }
    String formattedDate = DateFormat('yyyyMMdd').format(birtDate);

    if (formattedDate.contains(_newPIN)) {
      widget.birthdayErrorNotifier.value = true;
      return false;
    }
    widget.birthdayErrorNotifier.value = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose PIN",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Remember your PIN as you will use it for all future card purchases.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              _focusPin.requestFocus();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: hasError
                        ? const Color(0xffE61F27)
                        : index >= _newPIN.length
                            ? const Color(0xffadadb4)
                            : const Color(0xff15141E),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 1,
            child: TextField(
              autofocus: true,
              controller: _controller,
              focusNode: _focusPin,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration.collapsed(
                hintText: 'PIN',
              ),
              style: TextStyle(
                color: Colors.grey.withOpacity(0),
              ),
              cursorColor: Colors.transparent,
              cursorRadius: const Radius.circular(0),
              cursorWidth: 0,
              onChanged: (text) {
                if (text.length <= 4) {
                  setState(() {
                    _newPIN = text;
                    hasError = !hasConsecutiveDigits(_newPIN) ||
                        !containsPostalCode(_newPIN, user.person.address?.postalCode ?? 'postalCode') ||
                        !hasRepeatingDigits(_newPIN) ||
                        !containsBirthDate(_newPIN, user.person.birthDate ?? DateTime.now());
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePinChecks extends StatelessWidget {
  final ValueNotifier<bool> birthdayErrorNotifier;
  final ValueNotifier<bool> postalCodeErrorNotifier;
  final ValueNotifier<bool> sequenceErrorNotifier;
  final ValueNotifier<bool> repeatingErrorNotifier;

  const ChangePinChecks({
    Key? key,
    required this.birthdayErrorNotifier,
    required this.postalCodeErrorNotifier,
    required this.sequenceErrorNotifier,
    required this.repeatingErrorNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your PIN should not contain:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ValueListenableBuilder<bool>(
              valueListenable: birthdayErrorNotifier,
              builder: (context, hasError, child) {
                return Row(
                  children: [
                    Icon(
                      Icons.close,
                      size: 24,
                      color: birthdayErrorNotifier.value ? const Color(0xffE61F27) : Colors.black,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Your date of birth",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: birthdayErrorNotifier.value ? const Color(0xffE61F27) : Colors.black,
                      ),
                    ),
                  ],
                );
              }),
          ValueListenableBuilder<bool>(
              valueListenable: postalCodeErrorNotifier,
              builder: (context, hasError, child) {
                return Row(
                  children: [
                    Icon(
                      Icons.close,
                      size: 24,
                      color: postalCodeErrorNotifier.value ? const Color(0xffE61F27) : Colors.black,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Your postal code",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: postalCodeErrorNotifier.value ? const Color(0xffE61F27) : Colors.black,
                      ),
                    ),
                  ],
                );
              }),
          ValueListenableBuilder<bool>(
              valueListenable: sequenceErrorNotifier,
              builder: (context, hasError, child) {
                return Row(
                  children: [
                    Icon(
                      Icons.close,
                      size: 24,
                      color: sequenceErrorNotifier.value ? const Color(0xffE61F27) : Colors.black,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Number sequences, e.g. 1234",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: sequenceErrorNotifier.value ? const Color(0xffE61F27) : Colors.black,
                      ),
                    ),
                  ],
                );
              }),
          ValueListenableBuilder<bool>(
              valueListenable: repeatingErrorNotifier,
              builder: (context, hasError, child) {
                return Row(
                  children: [
                    Icon(
                      Icons.close,
                      size: 24,
                      color: repeatingErrorNotifier.value ? const Color(0xffE61F27) : Colors.black,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "More than two digits repeating",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: repeatingErrorNotifier.value ? const Color(0xffE61F27) : Colors.black,
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
