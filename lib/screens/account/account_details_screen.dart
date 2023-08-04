import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../../cubits/account_summary_cubit/account_summary_cubit.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/user.dart';
import '../../router/routing_constants.dart';
import '../../services/person_service.dart';
import '../../utilities/format.dart';
import '../../widgets/screen.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  void showAlertDialog(BuildContext context, String stringToCopy) async {
    copyToClipboard(stringToCopy);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(
          child: Text(
            "Copied to clipboard",
            style: TextStyle(color: Colors.black),
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
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

    AccountSummaryCubit accountSummaryCubit =
        AccountSummaryCubit(personService: PersonService(user: user.cognito))
          ..getAccountSummary();

    late String iban;
    late String bic;

    return Screen(
      onRefresh: () async {
        accountSummaryCubit.getAccountSummary();
      },
      scrollPhysics: const NeverScrollableScrollPhysics(),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      customBackButtonCallback: () {
        context.push(homeRoute.path);
      },
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      child: Column(
        children: [
          Padding(
            padding:
                ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account',
                  style: ClientConfig.getTextStyleScheme().heading1,
                ),
                const SizedBox(height: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: ClientConfig.getTextStyleScheme().labelLarge,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
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
                                    style: ClientConfig.getTextStyleScheme()
                                        .labelSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  BlocProvider<AccountSummaryCubit>.value(
                                    value: accountSummaryCubit,
                                    child: BlocBuilder<AccountSummaryCubit,
                                        AccountSummaryCubitState>(
                                      builder: (context, state) {
                                        if (state
                                            is AccountSummaryCubitLoaded) {
                                          iban = state.data!.iban ?? '';
                                          iban = Format.iban(iban);

                                          return Text(
                                            iban,
                                            style: ClientConfig
                                                    .getTextStyleScheme()
                                                .bodyLargeRegular,
                                          );
                                        }

                                        return const Text('');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              CopyContentButton(
                                onPressed: () {
                                  inspect(iban);
                                  showAlertDialog(context, iban);
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
                                    style: ClientConfig.getTextStyleScheme()
                                        .labelSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  BlocProvider<AccountSummaryCubit>.value(
                                    value: accountSummaryCubit,
                                    child: BlocBuilder<AccountSummaryCubit,
                                        AccountSummaryCubitState>(
                                      builder: (context, state) {
                                        if (state
                                            is AccountSummaryCubitLoaded) {
                                          bic = state.data!.bic ?? '';

                                          return Text(
                                            bic,
                                            style: ClientConfig
                                                    .getTextStyleScheme()
                                                .bodyLargeRegular,
                                          );
                                        }

                                        return const Text('');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CopyContentButton(
                                onPressed: () {
                                  inspect(bic);
                                  showAlertDialog(context, bic);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
