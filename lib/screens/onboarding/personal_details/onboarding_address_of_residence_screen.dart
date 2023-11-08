import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_presenter.dart';
import 'package:solarisdemo/infrastructure/suggestions/address/address_suggestions_presenter.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_action.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_mobile_number_screen.dart';
import 'package:solarisdemo/utilities/debouncer.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../../config.dart';

class OnboardingAddressOfResidenceScreen extends StatefulWidget {
  static const routeName = '/onboardingAddressOfResidenceScreen';

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

  final _debouncer = Debouncer(seconds: 1);

  @override
  void initState() {
    _addressController = IvoryTextFieldController();
    _houseNumberController = IvoryTextFieldController();
    _addressLineController = IvoryTextFieldController();
    _addressFocusNode = FocusNode();
    _houseNumberFocusNode = FocusNode();
    _addressLineFocusNode = FocusNode();
    _continueButtonController = ContinueButtonController();
    super.initState();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingPersonalDetailsViewModel>(
      converter: (store) => OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
        onboardingPersonalDetailsState: store.state.onboardingPersonalDetailsState,
      ),
      onWillChange: (previousViewModel, viewModel) {
        if (viewModel.isAddressSaved == true) {
          log("success");
          // TODO: Navigate to next screen
        }

        if (viewModel.isLoading) {
          _continueButtonController.setLoading();
        } else if (previousViewModel?.isLoading == true && viewModel.isLoading == false) {
          _continueButtonController.setEnabled();
        }
        
        if (previousViewModel!.isAddressSaved == null && newViewModel.isAddressSaved == true) {
          Navigator.pushNamed(context, OnboardingMobileNumberScreen.routeName);
        }
        
      },
      builder: (context, onboardingViewModel) {
        return ScreenScaffold(
          shouldPop: !onboardingViewModel.isLoading,
          body: Column(
            children: [
              AppToolbar(
                richTextTitle: StepRichTextTitle(step: 2, totalSteps: 4),
                actions: const [AppbarLogo()],
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                backButtonAppearanceDisabled: onboardingViewModel.isLoading,
              ),
              AnimatedLinearProgressIndicator.step(current: 2, totalSteps: 4),
              Expanded(
                child: ScrollableScreenContainer(
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
                      StoreConnector<AppState, AddressSuggestionsViewModel>(
                        converter: (store) => AddressSuggestionsPresenter.present(
                          addressSuggestionsState: store.state.addressSuggestionsState,
                        ),
                        builder: (context, addressSuggestionsViewModel) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IvoryTextField(
                                label: 'Search address',
                                placeholder: 'Search address',
                                suffix: addressSuggestionsViewModel is AddressSuggestionsLoadingViewModel
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(strokeWidth: 3),
                                      )
                                    : Icon(Icons.search, color: ClientConfig.getCustomColors().neutral700, size: 20),
                                controller: _addressController,
                                focusNode: _addressFocusNode,
                                inputType: TextFieldInputType.text,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (value) {
                                  _debouncer.run(() {
                                    if (value.isNotEmpty) {
                                      StoreProvider.of<AppState>(context).dispatch(
                                        FetchAddressSuggestionsCommandAction(
                                          query: value,
                                        ),
                                      );
                                    }
                                  });
                                },
                              ),
                              if (_addressController.text.isNotEmpty &&
                                  addressSuggestionsViewModel is AddressSuggestionsFetchedViewModel &&
                                  _addressController.text !=
                                      onboardingViewModel.attributes.selectedAddress?.address) ...[
                                const SizedBox(height: 16),
                                ..._buildAddressSuggestions(addressSuggestionsViewModel.suggestions),
                              ],
                              if (onboardingViewModel.attributes.selectedAddress?.address == _addressController.text &&
                                  addressSuggestionsViewModel is AddressSuggestionsFetchedViewModel) ...[
                                const SizedBox(height: 16),
                                IvoryTextField(
                                  placeholder: 'Please type',
                                  label: 'House number (Optional)',
                                  controller: _houseNumberController,
                                  focusNode: _houseNumberFocusNode,
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                IvoryTextField(
                                  placeholder: 'Please type',
                                  label: 'Address line (Optional)',
                                  controller: _addressLineController,
                                  focusNode: _addressLineFocusNode,
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
                                  onboardingViewModel.attributes.selectedAddress?.city ?? "",
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
                                  onboardingViewModel.attributes.selectedAddress?.country ?? "",
                                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => PrimaryButton(
                      text: "Continue",
                      isLoading: _continueButtonController.isLoading,
                      onPressed: _continueButtonController.isEnabled
                          ? () {
                              StoreProvider.of<AppState>(context).dispatch(
                                CreatePersonAccountCommandAction(
                                  houseNumber: _houseNumberController.text,
                                  addressLine: _addressLineController.text,
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildAddressSuggestions(List<AddressSuggestion> suggestions) {
    return suggestions
        .map(
          (suggestion) => SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                StoreProvider.of<AppState>(context).dispatch(
                  SelectOnboardingAddressSuggestionCommandAction(suggestion: suggestion),
                );

                _addressController.text = suggestion.address;
                _addressFocusNode.unfocus();
                _continueButtonController.setEnabled();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: suggestion.address,
                        style: ClientConfig.getTextStyleScheme().heading4,
                      ),
                      TextSpan(
                        text: '\n${suggestion.city}, ${suggestion.country}',
                        style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
