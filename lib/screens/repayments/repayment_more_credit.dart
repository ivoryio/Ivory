import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/button.dart';
import 'repayment_more_credit_waitlist.dart';

class RepaymentMoreCreditScreen extends StatelessWidget {
  static const routeName = "/repaymentMoreCredit";

  const RepaymentMoreCreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = context.read<AuthCubit>().state.user!;
    bool _waitlist = false;

    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings()
              .defaultScreenHorizontalPadding,
          vertical: 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            const SizedBox(height: 24),
            Text(
              'Need more credit?',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                style: ClientConfig.getTextStyleScheme().mixedStyles,
                children: [
                  const TextSpan(
                    text:
                        'We currently do not have a rescoring system or a loyalty program for credit increases. However, you can join our waitlist, and once we implement these features, you will be the first to know and enjoy the benefits of a credit increase.\nIf you need more information and help, please contact us at ',
                  ),
                  TextSpan(
                    text: '+49 151 23456789',
                    style:
                        ClientConfig.getTextStyleScheme().mixedStyles.copyWith(
                              color: Color(0xFF406FE6),
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                  const TextSpan(
                    text: '.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child:
                    SvgPicture.asset('assets/images/repayment_more_credit.svg'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Button(
                text: 'Get on the waitlist',
                disabledColor: const Color(0xFFDFE2E6),
                color: const Color(0xFF2575FC),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RepaymentMoreCreditWaitlistScreen.routeName,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
