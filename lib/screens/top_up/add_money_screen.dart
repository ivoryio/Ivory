import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/ivory_amount_field.dart';
import 'package:solarisdemo/widgets/account_balance_text.dart';
import 'package:solarisdemo/screens/transfer/transfer_review_screen.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_accounts_presenter.dart';

class AddMoneyScreen extends StatefulWidget {
  static const routeName = "/addMoneyScreen";

  const AddMoneyScreen({Key? key}) : super(key: key);

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  String? _errorText;
  bool _canContinue = false;
  final amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: StoreConnector<AppState, TransferAccountsViewModel>(
        onInit: (store) {
          // store.dispatch(GetPersonAccountCommandAction());
          // store.dispatch(GetReferenceAccountCommandAction());
        },
        converter: (store) => TransferAccountsPresenter.presentTransfer(
          referenceAccountState: store.state.referenceAccountState,
          personAccountState: store.state.personAccountState,
        ),
        onWillChange: (oldViewModel, newViewModel) {
          if (newViewModel is TransferAccountsFetchedViewModel) {
            amountController.addListener(() {
              setState(() {
                final value = double.tryParse(amountController.text) ?? 0;
                final balance = newViewModel.personAccount.balance!.value.toDouble();

                if (value > balance) {
                  _errorText = "Not enough balance";
                  _canContinue = false;
                } else if (value > 0) {
                  _errorText = null;
                  _canContinue = true;
                } else {
                  _errorText = null;
                  _canContinue = false;
                }
              });
            });
          }
        },
        builder: (context, viewModel) {
          return Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppToolbar(),
                const SizedBox(height: 16),
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
                const SizedBox(height: 24),
                Center(
                    child: CustomContainer(),
                  ),
                AmountTransfer(amountController: amountController),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Button(
                    text: "Next",
                    onPressed: _canContinue
                      ? () {
                          FocusScope.of(context).unfocus();
                          Navigator.pushNamed(
                            context,
                            TransferReviewScreen.routeName,
                            arguments: TransferReviewScreenParams(
                              transferAmountValue: double.parse(amountController.text),
                            ),
                          );
                        }
                      : null,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 80,
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: ClientConfig.getCustomColors().neutral100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(color: ClientConfig.getCustomColors().neutral200, width: 1),
                  color: Colors.white,
                ),
                child: Icon(Icons.credit_card),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ING Bank'),
                  Text('Visa *9482'),
                ],
              ),
            ],
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {},
              child: Text('Change',
              style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 16, 
                  fontWeight: FontWeight.w600,
                )),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                side: MaterialStateProperty.all(BorderSide.none),
              ),
            ),
          ),
        ],
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
              // Add your text styles here
            ),
          ),
          IvoryAmountField(
            controller: amountController,
            unfocusedBorderColor: ClientConfig.getCustomColors().neutral400,
            hintColor: ClientConfig.getCustomColors().neutral400,
            // Add your IvoryAmountField properties here
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Current balance:",
                  style: TextStyle(
                    color: ClientConfig.getCustomColors().neutral700,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                AccountBalanceText(
                  value: 10.00,
                  numberStyle: ClientConfig.getTextStyleScheme().display.copyWith(color: ClientConfig.getCustomColors().neutral700, fontSize: 16, fontWeight: FontWeight.w600),
                  centsStyle: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}