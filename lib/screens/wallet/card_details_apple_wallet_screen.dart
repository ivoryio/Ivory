import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config.dart';
import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';

class BankCardDetailsAppleWalletScreen extends StatelessWidget {
  const BankCardDetailsAppleWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      customBackButtonCallback: () {
        context.read<BankCardDetailsCubit>().startPinSetup(state.card!);
      },
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      trailingActions: [
        IconButton(
          icon: Image.asset(ClientConfig.getAssetIconPath('small_logo.png')),
          iconSize: 40,
          onPressed: () {},
        ),
      ],
      bottomProgressBarPages: const BottomProgressBarPagesIndicator(
        pageNumber: 4,
        numberOfPages: 4,
      ),
      child: Padding(
          padding:
              ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 16,
                  children: const [
                    Text(
                      'Add your credit card to Apple Wallet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 32 / 24,
                      ),
                    ),
                    Text(
                      'Add your Porsche credit card to Apple Wallet to start making seamless POS purchases.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/apple_wallet_logo.svg')
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 0,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: PlatformTextButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 23.0),
                        child: const Text(
                          'Maybe later',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<BankCardDetailsCubit>()
                              .successActivation(state.card!);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      // height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                  'assets/icons/apple_wallet_logo.png'),
                              iconSize: 40,
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Add to Apple Wallet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
