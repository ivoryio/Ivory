import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../../router/routing_constants.dart';
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('ACCOUNT'),
                const SizedBox(height: 24),
                Column(
                  children: [
                    const Text('Details'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
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
                                  Text('IBAN'),
                                  Text('DE43 1101 0100 2919 3290 34'),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('BIC'),
                                  Text('SOLARIS35'),
                                ],
                              ),
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
              ],
            ),
          ),
        ],
      ),
      // child: Padding(
      //   padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
      //   child: const Column(
      //     children: [
      //       Row(
      //         children: [
      //           Text(
      //             'Account',
      //             style: TextStyle(
      //               fontSize: 32,
      //               height: 40 / 32,
      //               fontWeight: FontWeight.w400,
      //             ),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Column(
      //             children: [
      //               Row(
      //                 children: [
      //                   Text('Details'),
      //                 ],
      //               ),
      //               Column(
      //                 children: [
      //                   Text('IBAN'),
      //                   Text('BIC'),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ],
      //       )
      //     ],
      //   ),
      // ),
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
