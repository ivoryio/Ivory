import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/documents/documents_presenter.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identification_status.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/circular_loading_indicator.dart';
import 'package:solarisdemo/widgets/documents_list_view.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingReviewUpdatedContractsScreen extends StatelessWidget {
  static const routeName = "/onboardingReviewUpdatedContractsScreen";

  const OnboardingReviewUpdatedContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingIdentityVerificationViewModel>(
      onInit: (store) => store.dispatch(GetSignupIdentificationInfoCommandAction()),
      converter: (store) => OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: store.state.onboardingIdentityVerificationState,
      ),
      builder: (context, viewModel) {
        final isAuthorizationStatusValid = viewModel.identificationStatus == null ||
            viewModel.identificationStatus == OnboardingIdentificationStatus.authorizationRequired;

        return ScreenScaffold(
          body: isAuthorizationStatusValid && viewModel.errorType == null
              ? Column(
                  children: [
                    AppToolbar(
                      richTextTitle: StepRichTextTitle(step: 4, totalSteps: 7),
                      actions: const [AppbarLogo()],
                      padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                    ),
                    AnimatedLinearProgressIndicator.step(current: 4, totalSteps: 7),
                    const SizedBox(height: 16),
                    viewModel.isLoading == true && viewModel.identificationStatus == null
                        ? _buildLoadingContent()
                        : _buildPageContent(context, viewModel),
                    const SizedBox(height: 16),
                  ],
                )
              : _buildErrorPage(),
        );
      },
    );
  }

  Widget _buildLoadingContent() {
    return Expanded(
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Read & confirm contracts", style: ClientConfig.getTextStyleScheme().heading2),
            const SizedBox(height: 24),
            Text(
              "Please bear with us a couple of seconds while we update your contract...",
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            const Expanded(
              child: Center(
                child: CircularLoadingIndicator(width: 128),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPage() {
    return ScrollableScreenContainer(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppToolbar(),
          const ScreenTitle("Your identity verification has failed"),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
              children: [
                const TextSpan(text: 'We regret to inform you that your '),
                TextSpan(
                  text: 'identity verification ',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                ),
                const TextSpan(text: 'has not been successful due to either a '),
                TextSpan(
                  text: 'technical or issue',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                ),
                const TextSpan(text: '.\n\n'),
                const TextSpan(text: 'Please get in touch with us by tapping on the '),
                TextSpan(
                  text: 'button below',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          Expanded(
            child: IvoryAssetWithBadge(
              childWidget: SvgPicture(
                SvgAssetLoader(
                  'assets/images/repayment_more_credit.svg',
                  colorMapper: IvoryColorMapper(
                    baseColor: ClientConfig.getColorScheme().secondary,
                  ),
                ),
              ),
              childPosition: BadgePosition.topEnd(top: -5, end: 78),
              isSuccess: false,
            ),
          ),
          PrimaryButton(
            text: "Contact us",
            onPressed: () {},
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPageContent(
      BuildContext context, OnboardingIdentityVerificationViewModel identityVerificationViewModel) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Text("Review updated contract", style: ClientConfig.getTextStyleScheme().heading2),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Text.rich(
              TextSpan(
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                children: [
                  const TextSpan(text: "We've made "),
                  TextSpan(
                    text: "important updates ",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const TextSpan(
                      text:
                          "to the “Credit Card Application” contract. Please take a moment to carefully review these changes. \n\n"),
                  const TextSpan(text: "We've also prepared your "),
                  TextSpan(
                    text: "“Qualified Electronic Signature (QES)” ",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const TextSpan(
                      text:
                          "for digital signing. It will enable you to sign your “Application Contract” in the next step using a TAN code."),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          StoreConnector<AppState, DocumentsViewModel>(
            converter: (store) => DocumentsPresenter.present(
              documentsState: store.state.documentsState,
              downloadDocumentState: store.state.downloadDocumentState,
            ),
            builder: (context, viewModel) {
              if (viewModel is DocumentsFetchedViewModel) {
                return DocumentsListView(
                  documents: viewModel.documents,
                  downloadingDocument: viewModel is DocumentDownloadingViewModel ? viewModel.downloadingDocument : null,
                  enabled: identityVerificationViewModel.isLoading != true,
                  onTapDownload: (document) {
                    StoreProvider.of<AppState>(context).dispatch(
                      DownloadDocumentCommandAction(
                        document: document,
                        downloadLocation: DocumentDownloadLocation.person,
                      ),
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
          const Spacer(),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: PrimaryButton(
              isLoading: identityVerificationViewModel.isLoading,
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(AuthorizeIdentificationSigningCommandAction());
              },
              text: "Continue to signing",
            ),
          ),
        ],
      ),
    );
  }
}
