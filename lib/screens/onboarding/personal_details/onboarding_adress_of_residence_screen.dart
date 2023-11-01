import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../../config.dart';

class OnboardingAddressOfResidenceScreen extends StatefulWidget {
  static const routeName = '/onboardingAddressScreen';

  const OnboardingAddressOfResidenceScreen({super.key});

  @override
  State<OnboardingAddressOfResidenceScreen> createState() => _OnboardingAddressOfResidenceScreenState();
}

class _OnboardingAddressOfResidenceScreenState extends State<OnboardingAddressOfResidenceScreen> {
  late IvoryTextFieldController _addressController;
  late IvoryTextFieldController _houseNumberController;
  late IvoryTextFieldController _addressLineController;
  late FocusNode _addressFocusNode;
  late FocusNode _houseNumberFocusNode;
  late FocusNode _addressLineFocusNode;
  late ContinueButtonController _continueButtonController;
  Timer? _debounceTimer;
  String _previousText = "";

  void onChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 1000),
      () {
        if (_addressController.text.length >= 3 &&
            _addressController.text.toLowerCase() != _previousText.toLowerCase()) {
          StoreProvider.of<AppState>(context).dispatch(
            FetchOnboardingPersonalDetailsAddressSuggestionsCommandAction(queryString: _addressController.text),
          );
          _addressFocusNode.unfocus();
          _previousText = _addressController.text;
        }
      },
    );
  }

  void capitalizeWords(String originalString) {
    var words = originalString.split(' ');
    var capitalizedWords = <String>[];
    for (var word in words) {
      var capitalizedWord = word[0].toUpperCase() + word.substring(1);
      capitalizedWords.add(capitalizedWord);
    }
    _addressController.text = capitalizedWords.join(' ');
  }

  @override
  void initState() {
    _addressController = IvoryTextFieldController();
    _houseNumberController = IvoryTextFieldController();
    _addressLineController = IvoryTextFieldController();
    _addressFocusNode = FocusNode();
    _houseNumberFocusNode = FocusNode();
    _addressLineFocusNode = FocusNode();
    _continueButtonController = ContinueButtonController();
    _addressController.addListener(onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _addressController.removeListener(onChanged);
    _addressController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingPersonalDetailsViewModel>(
        converter: (store) => OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
            onboardingPersonalDetailsState: store.state.onboardingPersonalDetailsState),
        builder: (context, viewModel) {
          return ScreenScaffold(
            body: Column(
              children: [
                AppToolbar(
                  richTextTitle: StepRichTextTitle(step: 2, totalSteps: 4),
                  actions: const [AppbarLogo()],
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                ),
                AnimatedLinearProgressIndicator.step(current: 2, totalSteps: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text('Address of residence', style: ClientConfig.getTextStyleScheme().heading2),
                        const SizedBox(height: 16),
                        Text(
                          'Search for your residential address below and provide any additional information if needed.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You will receive your credit card at this address.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const SizedBox(height: 24),
                        IvoryTextField(
                          enabled: viewModel is! OnboardingPersonalDetailsLoadingViewModel,
                          label: 'Search address',
                          placeholder: 'Search address',
                          suffix: Icon(
                            Icons.search,
                            color: ClientConfig.getCustomColors().neutral700,
                            size: 20,
                          ),
                          controller: _addressController,
                          focusNode: _addressFocusNode,
                          inputType: TextFieldInputType.text,
                        ),
                        const SizedBox(height: 24),
                        if (viewModel is OnboardingPersonalDetailsFetchedViewModel ||
                            _addressController.text.isNotEmpty)
                          Expanded(
                            child: ScrollableScreenContainer(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: (viewModel is OnboardingPersonalDetailsFetchedViewModel)
                                    ? MediaQuery.of(context).size.height * 0.4
                                    : 0,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (viewModel is OnboardingPersonalDetailsFetchedViewModel)
                                      ? (viewModel).suggestions!.length
                                      : 0,
                                  separatorBuilder: (context, index) => const Divider(
                                    height: 32,
                                    color: Colors.transparent,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        StoreProvider.of<AppState>(context).dispatch(
                                          SelectOnboardingPersonalDetailsAddressSuggestionCommandAction(
                                            selectedSuggestion: viewModel.suggestions![index],
                                          ),
                                        );
                                        _previousText = viewModel.suggestions![index].address;
                                        capitalizeWords(viewModel.suggestions![index].address);
                                        _addressFocusNode.unfocus();
                                        _continueButtonController.setEnabled();
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: (viewModel as OnboardingPersonalDetailsFetchedViewModel)
                                                  .suggestions?[index]
                                                  .address,
                                              style: ClientConfig.getTextStyleScheme().heading4,
                                            ),
                                            TextSpan(
                                              text:
                                                  '\n${(viewModel).suggestions![index].city}, ${(viewModel).suggestions![index].country}',
                                              style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        if (viewModel is OnboardingPersonalDetailsLoadingViewModel)
                          const Center(child: CircularProgressIndicator()),
                        // if (viewModel is OnboardingPersonalDetailsAddressSuggestionSelectedViewModel)
                        if (viewModel is! OnboardingPersonalDetailsAddressSuggestionSelectedViewModel ||
                            viewModel is OnboardingPersonalDetailsFetchedViewModel)
                          const Spacer(),
                        if (viewModel is OnboardingPersonalDetailsAddressSuggestionSelectedViewModel)
                          _buildSelectedAddress(
                            viewModel: viewModel,
                            houseNumberController: _houseNumberController,
                            houseNumberFocusNode: _houseNumberFocusNode,
                            addressLineController: _addressLineController,
                            addressLineFocusNode: _addressLineFocusNode,
                          ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ListenableBuilder(
                            listenable: _continueButtonController,
                            builder: (context, child) => PrimaryButton(
                              text: "Continue",
                              isLoading: _continueButtonController.isLoading,
                              onPressed: _continueButtonController.isEnabled
                                  ? () {
                                      _continueButtonController.setLoading();
                                      _addressController.setEnabled(false);
                                      _houseNumberController.setEnabled(false);
                                      _addressLineController.setEnabled(false);
                                    }
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

Widget _buildSelectedAddress({
  required OnboardingPersonalDetailsAddressSuggestionSelectedViewModel viewModel,
  required IvoryTextFieldController houseNumberController,
  required FocusNode houseNumberFocusNode,
  required IvoryTextFieldController addressLineController,
  required FocusNode addressLineFocusNode,
}) {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IvoryTextField(
            placeholder: 'Please type',
            label: 'House number (Optional)',
            controller: houseNumberController,
            focusNode: houseNumberFocusNode,
          ),
          const SizedBox(
            height: 24,
          ),
          IvoryTextField(
            placeholder: 'Please type',
            label: 'Address line (Optional)',
            controller: addressLineController,
            focusNode: addressLineFocusNode,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Postcode',
            style: ClientConfig.getTextStyleScheme().labelSmall,
          ),
          Text(
            '43234',
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'City',
            style: ClientConfig.getTextStyleScheme().labelSmall,
          ),
          Text(
            viewModel.selectedSuggestion!.city,
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Country',
            style: ClientConfig.getTextStyleScheme().labelSmall,
          ),
          Text(
            viewModel.selectedSuggestion!.country,
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
        ],
      ),
    ),
  );
}
