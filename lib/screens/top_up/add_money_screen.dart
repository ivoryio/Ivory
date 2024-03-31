import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/ivory_amount_field.dart';
import 'package:solarisdemo/screens/top_up/sign_cofirm_screen.dart';

class AddMoneyScreen extends StatefulWidget {
  static const routeName = "/addMoneyScreen";

  const AddMoneyScreen({Key? key}) : super(key: key);

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  bool _canContinue = false; 
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.addListener(_updateContinueStatus);
    _updateContinueStatus(); 
  }

  void _updateContinueStatus() {
    setState(() {
      _canContinue = amountController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
        return ScreenScaffold(
          body: Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppToolbar(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add money',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: CustomContainer(),
                ),
                AmountTransfer(amountController: amountController),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: PrimaryButton(
                    text: "Next",
                    onPressed: _canContinue
                        ? () {
                            FocusScope.of(context).unfocus();
                            Navigator.pushNamed(
                              context,
                              SignAndConfirmScreen.routeName,
                            );
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }
}



class CustomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: ClientConfig.getCustomColors().neutral100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        border: Border.all(color: ClientConfig.getCustomColors().neutral200, width: 1),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.credit_card),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          'ING BANK',
                          style: TextStyle(
                            color: ClientConfig.getCustomColors().neutral900,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Visa *9482',
                          style: TextStyle(
                            color: ClientConfig.getCustomColors().neutral700,
                            fontSize: 14.0,
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 8.0),
            OutlinedButton(
              onPressed: () {
                 Navigator.pop(context);
                },
              child: Text(
                'Change',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                side: MaterialStateProperty.all(BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmountTransfer extends StatelessWidget {
  final TextEditingController amountController;

  const AmountTransfer({Key? key, required this.amountController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            "Enter amount",
            style: TextStyle(
              color: ClientConfig.getCustomColors().neutral700,
              fontSize: 14,
            ),
          ),
          IvoryAmountField(
            controller: amountController,
            unfocusedBorderColor: ClientConfig.getCustomColors().neutral400,
            hintColor: ClientConfig.getCustomColors().neutral400,
          ),
        ],
      ),
    );
  }
}