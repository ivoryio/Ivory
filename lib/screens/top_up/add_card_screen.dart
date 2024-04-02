import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/top_up/add_card_action.dart';
import 'package:solarisdemo/screens/top_up/add_money_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

const defaultCardNumberFormat = '0000 0000 0000 0000';
const defaultCardHolderFormat = 'Name Surname';
const defaultExpiryDateFormat = '00/00';


class AddCardScreen extends StatefulWidget {
  static const routeName = "/addCardScreen";

  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}


class _AddCardScreenState extends State<AddCardScreen> {
  final IvoryTextFieldController _nameOnCardController = IvoryTextFieldController();
  final IvoryTextFieldController _cardNumberController = IvoryTextFieldController();
  final IvoryTextFieldController _monthCardNumberController = IvoryTextFieldController();
  final IvoryTextFieldController _yearCardNumberController = IvoryTextFieldController();
  final IvoryTextFieldController _cvvController = IvoryTextFieldController();
  final ContinueButtonController _continueButtonController = ContinueButtonController();

void updateExpiryDate() {
  setState(() {
    expiryDate = _monthCardNumberController.text.isNotEmpty && _yearCardNumberController.text.isNotEmpty
        ? '${_monthCardNumberController.text}/${_yearCardNumberController.text}'
        : defaultExpiryDateFormat;
  });
}
  String cardNumber = defaultCardNumberFormat;
  String cardHolderName = defaultCardHolderFormat;
  String expiryDate = defaultExpiryDateFormat;

  @override
  void initState() {
    super.initState();
    _nameOnCardController.addListener(onChange);
    _cardNumberController.addListener(onChange);
    _monthCardNumberController.addListener(onChange);
    _yearCardNumberController.addListener(onChange);
    _cvvController.addListener(onChange);
  }

void onChange() {
  setState(() {
    String nameOnCard = _nameOnCardController.text;
    String cardNumber = _cardNumberController.text;
    String month = _monthCardNumberController.text;
    String year = _yearCardNumberController.text;
    String cvv = _cvvController.text;

    bool isNameValid = nameOnCard.isNotEmpty;
    bool isCardNumberValid = cardNumber.isNotEmpty;
    bool isMonthValid = month.isNotEmpty && RegExp(r'^0[1-9]|1[0-2]$').hasMatch(month);
    bool isYearValid = year.isNotEmpty && RegExp(r'^\d{2}$').hasMatch(year);
    bool isCvvValid = cvv.isNotEmpty && RegExp(r'^\d{3}$').hasMatch(cvv);

    if (isNameValid && isCardNumberValid && isMonthValid && isYearValid && isCvvValid) {
      _continueButtonController.setEnabled();
    } else {
      _continueButtonController.setDisabled();
    }

    this.cardNumber = isCardNumberValid ? cardNumber : defaultCardNumberFormat;
    this.cardHolderName = isNameValid ? nameOnCard : defaultCardHolderFormat;
    this.expiryDate = (isMonthValid && isYearValid) ? '$month/$year' : defaultExpiryDateFormat;
});}

  @override
  void dispose() {
    _nameOnCardController.dispose();
    _cardNumberController.dispose();
    _monthCardNumberController.dispose();
    _yearCardNumberController.dispose();
    _cvvController.dispose();
    _continueButtonController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return ScreenScaffold(
    body: Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add a card',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            VisaCard(
              cardNumber: cardNumber,
              cardHolderName: cardHolderName,
              expiryDate: expiryDate,
            ),
            const SizedBox(height: 16),
            CreditCardForm( 
              nameOnCardController: _nameOnCardController,
              cardNumberController: _cardNumberController,
              monthCardNumberController: _monthCardNumberController,
              yearCardNumberController: _yearCardNumberController,
              cvvController: _cvvController,
            ),
            SizedBox(
              width: double.infinity,
              child: ListenableBuilder(
                listenable: _continueButtonController,
                builder: (context, _) => PrimaryButton(
                  text: "Add card",
                  onPressed: _continueButtonController.isEnabled ? () {
                    StoreProvider.of<AppState>(context).dispatch(
                      SubmitCardInformationCommandAction(
                        cardHolder: _nameOnCardController.text,
                        cardNumber: _cardNumberController.text,
                        month: _monthCardNumberController.text,
                        year: _yearCardNumberController.text,
                        cvv: _cvvController.text,
                      ),
                    );
                    Navigator.pushNamed(context, AddMoneyScreen.routeName);
                  } : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
  }
}

class VisaCard extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final double width;
  final double height;

  const VisaCard({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    this.width = 300,
    this.height = 200,
  });


  @override
  Widget build(BuildContext context) {
    final bool isDefaultCardNumber = cardNumber == defaultCardNumberFormat;
    final bool isDefaultCardHolderName = cardHolderName == defaultCardHolderFormat;
    final bool isDefaultExpiryDate = expiryDate == defaultExpiryDateFormat;

    final Color textColor = isDefaultCardNumber || isDefaultCardHolderName || isDefaultExpiryDate
        ? ClientConfig.getCustomColors().neutral600 
        : Colors.black; 
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFDFE2E6),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/card_logo.png', 
                width: 60,
                height: 40,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    cardNumber,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CARD HOLDER',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        cardHolderName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EXPIRY DATE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        expiryDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreditCardForm extends StatelessWidget {
  final IvoryTextFieldController nameOnCardController;
  final IvoryTextFieldController cardNumberController;
  final IvoryTextFieldController monthCardNumberController;
  final IvoryTextFieldController yearCardNumberController;
  final IvoryTextFieldController cvvController;

  const CreditCardForm({
    required this.nameOnCardController,
    required this.cardNumberController,
    required this.monthCardNumberController,
    required this.yearCardNumberController,
    required this.cvvController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: IvoryTextField(
            label: 'Name on card',
            placeholder: 'Name on card',
            inputType: TextFieldInputType.name,
            controller: nameOnCardController,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: IvoryTextField(
            label: 'Card number',
            placeholder: 'Card number',
            inputType: TextFieldInputType.number,
            keyboardType: TextInputType.number,
            inputFormatters: [InputFormatter.cardNumber(cardNumberController.text)],
            controller: cardNumberController,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
             SizedBox(
                height: 80, 
                width: MediaQuery.of(context).size.width / 2.5,
                child:  IvoryTextField(
                label: 'Month',
                placeholder: '00',
                inputType: TextFieldInputType.number,
                keyboardType: TextInputType.number,
                controller: monthCardNumberController,
                inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),],
                onChanged: (value) {
                  final validMonthPattern = RegExp(r'^0[1-9]|1[0-2]$');
                  if (!validMonthPattern.hasMatch(value)) {
                    monthCardNumberController.setError(true);
                  } else {
                    monthCardNumberController.setError(false);
                  }
                },
                ),
              ), 
            Spacer(),
            SizedBox(
                height: 80, 
                width: MediaQuery.of(context).size.width / 2.5,
                child:  IvoryTextField(
                  label: 'Year',
                  placeholder: '00',
                  inputType: TextFieldInputType.number,
                  keyboardType: TextInputType.number,
                  controller: yearCardNumberController,
                  inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,  
                  LengthLimitingTextInputFormatter(2)
                  ],
                  onChanged: (value) {
                    final currentYear = DateTime.now().year;
                    final lastTwoDigitsOfCurrentYear = currentYear % 100;
                    final enteredYear = int.tryParse(value) ?? 0;
                    if (enteredYear < lastTwoDigitsOfCurrentYear) {
                      yearCardNumberController.setError(true);
                    } else {
                      yearCardNumberController.setError(false);
                    }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: IvoryTextField(
            label: 'CVV',
            placeholder: 'CVV',
            inputType: TextFieldInputType.number,
            keyboardType: TextInputType.number,
            controller: cvvController,
            inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, 
                LengthLimitingTextInputFormatter(3)
              ]
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}


