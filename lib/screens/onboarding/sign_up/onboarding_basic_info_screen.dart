import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
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

  @override
  void initState() {
    super.initState();
    _selectTitleController = IvorySelectOptionController();
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
                  const IvoryTextField(
                    label: "First name(s)",
                    placeholder: "Type first name",
                  ),
                  const SizedBox(height: 24),
                  const IvoryTextField(
                    label: "Last name(s)",
                    placeholder: "Type last name",
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: "Continue",
                        onPressed: () {
                          log(_selectTitleController.options.toString());
                        },
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
