import 'dart:developer';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_presenter.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../utilities/format.dart';

class AccountDetailsScreen extends StatelessWidget {
  static const routeName = "/accountDetailsScreen";

  const AccountDetailsScreen({super.key});

  void showAlertDialog(BuildContext context, String stringToCopy) async {
    copyToClipboard(stringToCopy);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        margin: EdgeInsets.only(bottom: 60, left: 90, right: 90),
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.content_copy,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              "Copied to clipboard",
              style: TextStyle(
                fontFamily: 'Sofia Pro',
                fontSize: 16,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          side: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }

  void copyToClipboard(String stringToCopy) {
    Clipboard.setData(ClipboardData(text: stringToCopy));
  }

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            const SizedBox(height: 24),
            Text(
              'Account',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 24),
            Text(
              'Details',
              style: ClientConfig.getTextStyleScheme().labelLarge,
            ),
            const SizedBox(height: 8),
            Material(
              color: const Color(0xFFF8F9FA),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: StoreConnector<AppState, AccountSummaryViewModel>(
                onInit: (store) {
                  store.dispatch(GetAccountSummaryCommandAction(user: user.cognito));
                },
                converter: (store) =>
                    AccountSummaryPresenter.presentAccountSummary(accountSummaryState: store.state.accountSummaryState),
                builder: (context, viewModel) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'IBAN',
                                  style:
                                  ClientConfig
                                      .getTextStyleScheme()
                                      .labelSmall,
                                ),
                                const SizedBox(height: 4),
                               ibanFromViewModel(viewModel),
                              ],
                            ),
                            CopyContentButton(
                              onPressed: () {
                                inspect(viewModel.accountSummary?.iban ?? '');
                                showAlertDialog(context, viewModel.accountSummary?.iban ?? '');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BIC',
                                  style:
                                  ClientConfig
                                      .getTextStyleScheme()
                                      .labelSmall,
                                ),
                                const SizedBox(height: 4),
                               bicFromViewModel(viewModel),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CopyContentButton(
                              onPressed: () {
                                inspect(viewModel.accountSummary?.bic ?? '');
                                showAlertDialog(context, viewModel.accountSummary?.bic ?? '');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ),
          ],
        ),
      ),
    );
  }

  Widget ibanFromViewModel(AccountSummaryViewModel viewModel) {
    if(viewModel is AccountSummaryFetchedViewModel) {
      String iban = viewModel.accountSummary?.iban ?? '';
      iban = Format.iban(iban);

      return Text(
        iban,
        style: ClientConfig
            .getTextStyleScheme()
            .bodyLargeRegular,
      );
    }
    return const Text(' ');
  }

  Widget bicFromViewModel(AccountSummaryViewModel viewModel) {
    if(viewModel is AccountSummaryFetchedViewModel) {
      String bic = viewModel.accountSummary?.bic ?? '';

      return Text(
        bic,
        style: ClientConfig
            .getTextStyleScheme()
            .bodyLargeRegular,
      );
    }
    return const Text(' ');
  }
}

class CopyContentButton extends StatelessWidget {
  final Function? onPressed;

  const CopyContentButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 24,
        icon: const Icon(
          Icons.content_copy,
          color: Colors.black,
        ),
        onPressed: () {
          onPressed!();
        },
      ),
    );
  }
}

class StatementButton extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final Function onPressed;
  final Color iconColor;

  const StatementButton({
    super.key,
    required this.alignment,
    required this.icon,
    required this.onPressed,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: 24,
      alignment: alignment,
      constraints: const BoxConstraints(),
      icon: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: () {
        onPressed();
      },
    );
  }
}
