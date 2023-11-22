import 'package:flutter/material.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnboardingBankVerificationScreenParams {
  final String url;

  OnboardingBankVerificationScreenParams({required this.url});
}

class OnboardingBankVerificationScreen extends StatefulWidget {
  static const routeName = "/onboardingBankVerificationScreen";

  final OnboardingBankVerificationScreenParams params;

  const OnboardingBankVerificationScreen({super.key, required this.params});

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
            if (url == null) {
              return;
            }

            if (url.endsWith("?success")) {
              Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.routeName, (route) => false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.params.url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
