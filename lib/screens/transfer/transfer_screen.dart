import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_accounts_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_action.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_action.dart';
import 'package:solarisdemo/screens/transfer/transfer_review_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_amount_field.dart';
import 'package:solarisdemo/widgets/ivory_card.dart';
import 'package:solarisdemo/widgets/ivory_error_widget.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class TransferScreen extends StatefulWidget {
  static const routeName = "/transferScreen";

  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
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
    final user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: StoreConnector<AppState, TransferAccountsViewModel>(
        onInit: (store) {
          store.dispatch(GetReferenceAccountCommandAction(user: user.cognito));
          store.dispatch(GetPersonAccountCommandAction(user: user.cognito));
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
                final balance = newViewModel.personAccount.availableBalance!.value.toDouble();

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
        distinct: true,
        builder: (context, viewModel) {
          return ScreenScaffold(
            body: Column(
              children: [
                AppToolbar(
                  title: "Transfer",
                  padding: EdgeInsets.symmetric(
                    horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  ),
                ),
                viewModel is TransferAccountsLoadingViewModel
                    ? const Expanded(child: Center(child: CircularProgressIndicator()))
                    : viewModel is TransferAccountsFetchedViewModel
                        ? Expanded(child: _buildScreenBody(viewModel))
                        : const IvoryErrorWidget("Could not load accounts"),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScreenBody(TransferAccountsFetchedViewModel viewModel) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              child: Column(
                children: [
                  _Card(
                    title: "Porsche account",
                    iban: viewModel.personAccount.iban!,
                    balance: viewModel.personAccount.availableBalance!.value.toDouble(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.arrow_downward),
                  ),
                  _Card(
                    title: "Reference account",
                    iban: viewModel.referenceAccount.iban,
                    bankName: viewModel.referenceAccount.name,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Enter transfer amount",
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                          color: _errorText != null ? Colors.red : const Color(0xFF56555E),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  IvoryAmountField(
                    controller: amountController,
                    error: _errorText != null,
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorText!,
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      showBottomModal(
                        context: context,
                        title: "How to top up your Ivory account?",
                        content: _TopUpBottomSheetContent(iban: viewModel.personAccount.iban!),
                      );
                    },
                    child: Text(
                      "Want to top up your Ivory account?",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: const Color(0xFF406FE6),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            child: Button(
              color: const Color(0xFF2575FC),
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
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String iban;
  final double? balance;
  final String? bankName;

  const _Card({
    required this.title,
    required this.iban,
    this.balance,
    this.bankName,
  });

  @override
  Widget build(BuildContext context) {
    return IvoryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Text(title, style: ClientConfig.getTextStyleScheme().heading4),
              if (balance != null) ...[
                const Spacer(),
                Text(
                  "€${balance!.toStringAsFixed(2)}",
                  style: ClientConfig.getTextStyleScheme().heading4,
                ),
                Text("*", style: ClientConfig.getTextStyleScheme().heading4.copyWith(color: const Color(0xFF2575FC))),
              ]
            ]),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  Format.iban(iban),
                  style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                ),
                if (balance != null) ...[
                  const Spacer(),
                  Text(
                    "Balance",
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                  ),
                ]
              ],
            ),
          ),
          if (bankName != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    bankName!,
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (balance != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                            color: const Color(0xFF2575FC),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    TextSpan(
                      text: " You can only transfer the topped-up balance.",
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                            color: const Color(0xFF15141E),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _TopUpBottomSheetContent extends StatelessWidget {
  final String iban;

  const _TopUpBottomSheetContent({required this.iban});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(text: "Copy your Ivory IBAN below:", iban: iban),
        const SizedBox(height: 24),
        _buildRow(text: "Log into your reference bank account."),
        const SizedBox(height: 24),
        _buildRow(text: "Make a transfer to your Ivory account using the IBAN you copied."),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRow({required String text, String? iban}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, color: Color(0xFF2575FC)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
              if (iban != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      Format.iban(iban),
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: const Color(0xFF15141E),
                          ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: iban));
                      },
                      child: const Icon(Icons.copy, color: Color(0xFF15141E)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
