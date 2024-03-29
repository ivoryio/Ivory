import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/documents/documents_presenter.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_identity_verification_error_screen.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_sign_with_tan_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/documents_list_view.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/skeleton.dart';

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
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.isAuthorized == true) {
          Navigator.pushNamedAndRemoveUntil(context, OnboardingSignWithTanScreen.routeName, (_) => false);
        } else if (newViewModel.errorType != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            OnboardingIdentityVerificationErrorScreen.routeName,
            (route) => false,
          );
        }
      },
      distinct: true,
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
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
          ),
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
            Text("Review updated contract", style: ClientConfig.getTextStyleScheme().heading2),
            const SizedBox(height: 24),
            Text(
              "Please bear with us a couple of seconds while we update your contract...",
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            Expanded(
              child: Center(
                child: _buildLoadingSkeleton(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return SkeletonContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          for (var i = 0; i < 2; i++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Skeleton(width: 24, height: 24, borderRadius: BorderRadius.circular(100)),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Skeleton(width: 128, height: 16),
                    SizedBox(height: 8),
                    Skeleton(width: 200, height: 10),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    OnboardingIdentityVerificationViewModel identityVerificationViewModel,
  ) {
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
