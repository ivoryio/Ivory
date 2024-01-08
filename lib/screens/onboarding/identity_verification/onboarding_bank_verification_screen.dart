import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_review_updated_contracts_screen.dart';
import 'package:solarisdemo/widgets/circular_loading_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnboardingBankVerificationScreen extends StatefulWidget {
  static const routeName = "/onboardingBankVerificationScreen";

  const OnboardingBankVerificationScreen({super.key});

  @override
  State<OnboardingBankVerificationScreen> createState() => _OnboardingBankVerificationScreenState();
}

class _OnboardingBankVerificationScreenState extends State<OnboardingBankVerificationScreen> {
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange urlChange) {
            final url = urlChange.url;

            if (url != null && url.endsWith("?success")) {
              Navigator.pushNamedAndRemoveUntil(
                  context, OnboardingReviewUpdatedContractsScreen.routeName, (route) => false);
            }
          },
        ),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, OnboardingIdentityVerificationViewModel>(
        converter: (store) => OnboardingIdentityVerificationPresenter.present(
          identityVerificationState: store.state.onboardingIdentityVerificationState,
        ),
        onInitialBuild: (viewModel) {
          if (viewModel.urlForIntegration != null) {
            controller.loadRequest(Uri.parse(viewModel.urlForIntegration!));
          }
        },
        builder: (context, viewModel) => viewModel.urlForIntegration == null
            ? const Center(child: CircularLoadingIndicator(width: 128))
            : GestureDetector(
                onVerticalDragUpdate: (dragUpdateDetails) {},
                child: WebViewWidget(controller: controller),
              ),
      ),
    );
  }
}
