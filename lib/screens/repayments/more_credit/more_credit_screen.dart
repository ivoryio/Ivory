import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_action.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config.dart';
import '../../../utilities/ivory_color_mapper.dart';
import '../../../widgets/app_toolbar.dart';
import '../../../widgets/button.dart';
import 'more_credit_waitlist_screen.dart';

class MoreCreditScreen extends StatefulWidget {
  static const routeName = "/repaymentMoreCredit";

  const MoreCreditScreen({super.key});

  @override
  State<MoreCreditScreen> createState() => _MoreCreditScreenState();
}

class _MoreCreditScreenState extends State<MoreCreditScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            Text(
              'Need more credit?',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            Text.rich(
              TextSpan(
                style: ClientConfig.getTextStyleScheme().mixedStyles,
                children: [
                  const TextSpan(
                    text:
                        'We currently do not have a rescoring system or a loyalty program for credit increases. However, you can join our waitlist, and once we implement these features, you will be the first to know and enjoy the benefits of a credit increase.\n\nIf you need more information and help, please contact us at ',
                  ),
                  TextSpan(
                    text: '+49 151 23456789',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Uri phoneNumber = Uri(
                          scheme: 'tel',
                          path: '+4915123456789',
                        );

                        if (await canLaunchUrl(phoneNumber)) {
                          await launchUrl(phoneNumber);
                        } else {
                          throw 'Could not launch $phoneNumber';
                        }
                      },
                    style:
                        ClientConfig.getTextStyleScheme().labelLarge.copyWith(
                              color: ClientConfig.getColorScheme().secondary,
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
                child: SvgPicture(
                  SvgAssetLoader(
                    'assets/images/repayment_more_credit.svg',
                    colorMapper: IvoryColorMapper(baseColor: ClientConfig.getColorScheme().secondary,),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: StoreConnector<AppState, MoreCreditViewModel>(
                onInit: (store) => {},
                converter: (store) => MoreCreditPresenter.presentMoreCredit(
                  moreCreditState: store.state.moreCreditState,
                ),
                distinct: true,
                builder: (context, viewModel) => Button(
                  text: 'Get on the waitlist',
                  disabledColor: ClientConfig.getCustomColors().neutral300,
                  color:ClientConfig.getColorScheme().tertiary,
                  textColor: ClientConfig.getColorScheme().surface,
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(
                      UpdateMoreCreditCommandAction(),
                    );
                    Navigator.pushNamed(
                      context,
                      MoreCreditWaitlistScreen.routeName,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
