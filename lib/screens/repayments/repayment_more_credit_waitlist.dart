import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/button.dart';
import 'repayments_screen.dart';

class RepaymentMoreCreditWaitlistScreen extends StatelessWidget {
  static const routeName = "/repaymentMoreCreditWaitlist";

  const RepaymentMoreCreditWaitlistScreen({super.key});

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
              'You have been successfully added to the waitlist',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 16),
            Text(
              'When we introduce support for credit increases, we will notify you through a push notification and/or email. Thank you!',
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                    'assets/images/repayment_more_credit_waitlist.svg'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Button(
                text: 'Back to “Repayments”',
                disabledColor: const Color(0xFFDFE2E6),
                color: const Color(0xFF2575FC),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RepaymentsScreen.routeName,
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
