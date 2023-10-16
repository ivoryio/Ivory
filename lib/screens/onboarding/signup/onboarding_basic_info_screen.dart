import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/basic_info/onboarding_basic_info_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingBasicInfoScreen extends StatefulWidget {
  static const routeName = '/onboardingBasicInfoScreen';

  const OnboardingBasicInfoScreen({super.key});

  @override
  State<OnboardingBasicInfoScreen> createState() => _OnboardingBasicInfoScreenState();
}

class _OnboardingBasicInfoScreenState extends State<OnboardingBasicInfoScreen> {
  late IvorySelectOptionController _selectTitleController;
  late ContinueButtonController _continueButtonController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _selectTitleController = IvorySelectOptionController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _continueButtonController = ContinueButtonController();

    _selectTitleController.addListener(onChange);
    _firstNameController.addListener(onChange);
    _lastNameController.addListener(onChange);
  }

  void onChange() {
    if (_selectTitleController.selectedOptions.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      _continueButtonController.setDisabled();
    } else {
      _continueButtonController.setEnabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            richTextTitle: StepRichTextTitle(step: 1, totalSteps: 4),
            actions: const [AppbarLogo()],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          LinearProgressIndicator(
            value: 2 / 100,
            color: ClientConfig.getColorScheme().secondary,
            backgroundColor: const Color(0xFFE9EAEB),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preferred title, first & last name", style: ClientConfig.getTextStyleScheme().heading2),
                  const SizedBox(height: 16),
                  Text(
                    "Select your title and fill in your first and last name. Include all names if you have multiple.",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: "Preferred title",
                    bottomSheetLabel: "Select your preferred title",
                    controller: _selectTitleController,
                    options: const [
                      SelectOption(label: "Mr.", value: "mr"),
                      SelectOption(label: "Ms.", value: "ms"),
                      SelectOption(label: "Other", value: "other"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: "First name(s)",
                    placeholder: "Type first name",
                    controller: _firstNameController,
                  ),
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: "Last name(s)",
                    placeholder: "Type last name",
                    controller: _lastNameController,
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  SizedBox(
                      width: double.infinity,
                      child: ListenableBuilder(
                        listenable: _continueButtonController,
                        builder: (context, child) => PrimaryButton(
                          text: "Continue",
                          onPressed: _continueButtonController.isEnabled
                              ? () {
                                  log(_selectTitleController.selectedOptions.toString(), name: "selectedOptions");
                                  log(_firstNameController.text, name: "firstName");
                                  log(_lastNameController.text, name: "lastName");

                                  StoreProvider.of<AppState>(context).dispatch(
                                    SubmitOnboardingBasicInfoCommandAction(
                                      title: _selectTitleController.selectedOptions.first.value,
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                    ),
                                  );
                                }
                              : null,
                        ),
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
