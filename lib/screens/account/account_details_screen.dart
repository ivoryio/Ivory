import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/widgets/yvory_list_tile.dart';

import '../../config.dart';
import '../../router/routing_constants.dart';
import '../../widgets/screen.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String iban = 'DE43 1101 0100 2919 3290 34';
    const String bic = 'SOLARIS35';

    return Screen(
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
            padding: EdgeInsets.fromLTRB(
              ClientConfig.getCustomClientUiSettings()
                  .defaultScreenVerticalPadding,
              ClientConfig.getCustomClientUiSettings()
                  .defaultScreenVerticalPadding,
              ClientConfig.getCustomClientUiSettings()
                  .defaultScreenVerticalPadding,
              8,
            ),
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
                    Material(
                      color: const Color(0xFFF8F9FA),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
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
                                    Text(
                                      iban,
                                      style: ClientConfig.getTextStyleScheme()
                                          .bodyLargeRegular,
                                    ),
                                  ],
                                ),
                                CopyContentButton(
                                  onPressed: () {
                                    inspect(const ClipboardData(
                                      text: iban,
                                    ));
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
                                    Text(
                                      bic,
                                      style: ClientConfig.getTextStyleScheme()
                                          .bodyLargeRegular,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                CopyContentButton(
                                  onPressed: () {
                                    inspect(const ClipboardData(
                                      text: bic,
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Statements',
                      style: ClientConfig.getTextStyleScheme().heading4,
                    ),
                  ],
                ),
              ],
            ),
          ),
          YvoryListTile(
            startIcon: Icons.ios_share,
            title: 'Generate statement',
            subtitle: 'Select the period and export your statement',
            onTap: () {
              log('Generate statement button pressed');
            },
          )
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
