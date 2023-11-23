import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/circular_loading_indicator.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../config.dart';
import '../../../infrastructure/onboarding/card_configuration/onboarding_card_configuration_presenter.dart';
import '../../../redux/app_state.dart';
import '../../../redux/onboarding/card_configuration/onboarding_card_configuration_action.dart';
import '../../../widgets/animated_linear_progress_indicator.dart';
import '../../../widgets/app_toolbar.dart';

class OnboardingOrderCardScreen extends StatefulWidget {
  static const routeName = "/onboardingOrderCardScreen";

  const OnboardingOrderCardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingOrderCardScreen> createState() => _OnboardingOrderCardScreenState();
}

class _OnboardingOrderCardScreenState extends State<OnboardingOrderCardScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(body:
    Column(
      children: [
       AppToolbar(
         richTextTitle: StepRichTextTitle(step: 1, totalSteps: 3),
         actions: const [AppbarLogo()],
         padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
       ),
       AnimatedLinearProgressIndicator.step(current: 1, totalSteps: 3),
       const SizedBox(height: 16,),
       Padding(
         padding: ClientConfig.getCustomClientUiSettings().defaultScreenVerticalPadding,
         child: Text(
           "Order your Ivory credit card",
           style: ClientConfig.getTextStyleScheme().heading2,
         ),
       ),
        StoreConnector<AppState, OnboardingCardConfigurationViewModel>(
          onInit: (store) {
            store.dispatch(GetCardPersonNameCommandAction());
          },
          converter: (store) => OnboardingCardConfigurationPresenter.presentCardConfiguration(
              cardConfigurationState: store.state.onboardingCardConfigurationState,
          ),
          builder: (context, viewModel) {
            return _buildFrom(viewModel);
          },
        ),
     ],),
    );
  }
}

Widget _buildFrom(OnboardingCardConfigurationViewModel viewModel) {
  return Expanded(
    child: Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      child: Column(
        children: [
          Text(
            'Please bear with us a couple of seconds while we create your card...',
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
          const Spacer(),
          const CircularLoadingIndicator(),
          const Spacer(),
          const PrimaryButton(text: "Order my card"),
          const SizedBox(height: 16,),
        ],
      ),
    ),
  );
}