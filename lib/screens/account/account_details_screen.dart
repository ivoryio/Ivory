import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../../router/routing_constants.dart';
import '../../widgets/modal.dart';
import '../../widgets/screen.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding:
                ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 32,
                    height: 40 / 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        height: 24 / 18,
                        fontWeight: FontWeight.w600,
                      ),
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
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'IBAN',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 18 / 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF56555E),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'DE43 1101 0100 2919 3290 34',
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 24 / 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF15141E),
                                    ),
                                  ),
                                ],
                              ),
                              CopyContentButton(
                                onPressed: () {
                                  inspect(const ClipboardData(
                                    text: 'IBAN pressed',
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
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BIC',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 18 / 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF56555E),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'SOLARIS35',
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 24 / 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF15141E),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CopyContentButton(
                                onPressed: () {
                                  inspect(const ClipboardData(
                                    text: 'BIC pressed',
                                  ));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Statements',
                      style: TextStyle(
                        fontSize: 18,
                        height: 24 / 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StatementButton(
                        alignment: Alignment.centerLeft,
                        icon: Icons.ios_share,
                        onPressed: () {
                          log('Share button pressed');
                        },
                        iconColor: const Color(0xFFCC0000),
                      ),
                      const SizedBox(width: 16),
                      const Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Generate statement',
                              style: TextStyle(
                                fontSize: 16,
                                height: 24 / 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),
                              ),
                            ),
                            Text(
                              'Select the period and export your statement',
                              style: TextStyle(
                                fontSize: 14,
                                height: 18 / 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF56555E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      StatementButton(
                        alignment: Alignment.centerRight,
                        icon: Icons.arrow_forward_ios,
                        onPressed: () {
                          showBottomModal(
                            context: context,
                            child: const ContentOfModal(),
                          );
                          log('Modal button pressed');
                        },
                        iconColor: const Color(0xFF000000),
                      )
                    ],
                  ),
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

class ContentOfModal extends StatelessWidget {
  const ContentOfModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Outstanding balance',
                  style: TextStyle(
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF15141E),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatementButton(
                alignment: Alignment.center,
                icon: Icons.close,
                onPressed: () {
                  context.pop();
                  log('Close button pressed');
                },
                iconColor: const Color(0xFF000000),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Flexible(
                child: Text(
                  'The outstanding balance includes any carried-over balance from previous billing cycles, new purchases, fees, and accrued interest. It represents the total amount that you owe.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF15141E),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
