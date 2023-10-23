import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_presenter.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_action.dart';
import 'package:solarisdemo/screens/transfer/transfer_sign_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_card.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class TransferReviewScreenParams {
  final double transferAmountValue;

  TransferReviewScreenParams({required this.transferAmountValue});
}

class TransferReviewScreen extends StatefulWidget {
  static const routeName = "/transferReviewScreen";

  final TransferReviewScreenParams params;

  const TransferReviewScreen({super.key, required this.params});

  @override
  State<TransferReviewScreen> createState() => _TransferReviewScreenState();
}

class _TransferReviewScreenState extends State<TransferReviewScreen> {
  final noteController = IvoryTextFieldController();

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;

    return StoreConnector<AppState, TransferViewModel>(
      converter: (store) => TransferPresenter.presentTransfer(
        transferState: store.state.transferState,
        personAccountState: store.state.personAccountState,
        referenceAccountState: store.state.referenceAccountState,
      ),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel is TransferConfirmationViewModel) {
          Navigator.pushNamed(context, TransferSignScreen.routeName);
        }
      },
      builder: (context, viewModel) => ScreenScaffold(
        body: Column(
          children: [
            AppToolbar(
              title: "Review transfer",
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            _buildBody(),
            Container(
              width: double.infinity,
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: viewModel is TransferLoadingViewModel
                  ? const Center(child: CircularProgressIndicator())
                  : Button(
                      color: ClientConfig.getColorScheme().tertiary,
                      text: "Sign & confirm",
                      textColor: ClientConfig.getColorScheme().surface,
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        StoreProvider.of<AppState>(context).dispatch(
                          TransferCommandAction(
                            user: user.cognito,
                            transfer: ReferenceAccountTransfer(
                              description: noteController.text,
                              amount: ReferenceAccountTransferAmount(
                                value: widget.params.transferAmountValue,
                              ),
                            ),
                          ),
                        );
                      }),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          child: Column(
            children: [
              IvoryCard(
                padding: const EdgeInsets.all(16),
                color: ClientConfig.getCustomColors().neutral100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transferring:",
                      style: ClientConfig.getTextStyleScheme().bodySmallBold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Format.euro(widget.params.transferAmountValue, digits: 2),
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "From:",
                      style: ClientConfig.getTextStyleScheme().bodySmallBold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ivory account",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "To:",
                      style: ClientConfig.getTextStyleScheme().bodySmallBold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Reference account",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add note (optional)",
                  style: ClientConfig.getTextStyleScheme().bodySmallBold,
                ),
              ),
              const SizedBox(height: 8),
              IvoryTextField(
                minLines: 4,
                placeholder: "Add note",
                controller: noteController,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
