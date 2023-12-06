import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_action.dart';
import 'package:solarisdemo/screens/transfer/transfer_failed_screen.dart';
import 'package:solarisdemo/screens/transfer/transfer_successful_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

class TransferSignScreen extends StatefulWidget {
  static const routeName = "/transferSignScreen";

  const TransferSignScreen({super.key});

  @override
  State<TransferSignScreen> createState() => _TransferSignScreenState();
}

class _TransferSignScreenState extends State<TransferSignScreen> {
  final TextEditingController _tanInputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TransferViewModel>(
      converter: (store) => TransferPresenter.presentTransfer(
        transferState: store.state.transferState,
        personAccountState: store.state.personAccountState,
        referenceAccountState: store.state.referenceAccountState,
      ),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel is TransferConfirmedViewModel) {
          Navigator.popAndPushNamed(context, TransferSuccessfulScreen.routeName);
        } else if (newViewModel is TransferFailedViewModel) {
          Navigator.popAndPushNamed(context, TransferFailedScreen.routeName, arguments: newViewModel.errorType);
        }
      },
      builder: (context, viewModel) => ScreenScaffold(
        body: Column(
          children: [
            AppToolbar(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            Expanded(
              child: Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Confirm OTP",
                      style: ClientConfig.getTextStyleScheme().heading1,
                      textAlign: TextAlign.left,
                    ),
                    if (viewModel is TransferLoadingViewModel) ...[
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                    ],
                    if (viewModel is TransferConfirmationViewModel) ...[
                      const SizedBox(height: 16),
                      Text(
                        "Please enter the OTP sent to your registered mobile number",
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 16),
                      TanInput(
                        controller: _tanInputController,
                        focusNode: _focusNode,
                        length: 6,
                        onChanged: (tan) {
                          if (tan.length == 6) {
                            StoreProvider.of<AppState>(context).dispatch(
                              ConfirmTransferCommandAction(
                                changeRequestId: viewModel.changeRequestId,
                                tan: tan,
                              ),
                            );
                          }                      
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
