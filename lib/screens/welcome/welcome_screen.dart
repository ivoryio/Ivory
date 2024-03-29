import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/auth/auth_presenter.dart';
import 'package:solarisdemo/ivory_app.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/screens/login/login_with_biometrics_screen.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_start_screen.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/button.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = "/welcomeScreen";

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      extendBodyBehindAppBar: true,
      body: ScrollableScreenContainer(
        child: StoreConnector<AppState, AuthViewModel>(
          onInit: (store) {
            store.dispatch(LoadCredentialsCommandAction());
          },
          distinct: true,
          converter: (store) => AuthPresenter.presentAuth(authState: store.state.authState),
          onWillChange: (previousViewModel, newViewModel) {
            if (previousViewModel is AuthLoadingViewModel &&
                newViewModel is AuthCredentialsLoadedViewModel &&
                newViewModel.email!.isNotEmpty &&
                newViewModel.password!.isNotEmpty &&
                newViewModel.deviceId!.isEmpty) {
              Navigator.pushNamed(context, LoginScreen.routeName);
              FlutterNativeSplash.remove();
            }
            if (previousViewModel is AuthLoadingViewModel &&
                newViewModel is AuthCredentialsLoadedViewModel &&
                newViewModel.email!.isNotEmpty &&
                newViewModel.password!.isNotEmpty &&
                newViewModel.deviceId!.isNotEmpty) {
              StoreProvider.of<AppState>(context).dispatch(
                InitUserAuthenticationCommandAction(
                  email: newViewModel.email!,
                  password: newViewModel.password!,
                ),
              );
            }
            if (previousViewModel is AuthLoadingViewModel &&
                newViewModel is AuthInitializedViewModel &&
                newViewModel.authType == AuthType.withBiometrics) {
              Navigator.pushNamedAndRemoveUntil(context, LoginWithBiometricsScreen.routeName, (route) => false);
              FlutterNativeSplash.remove();
            }
          },
          builder: (context, viewModel) {
            if (viewModel is AuthLoadingViewModel) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel is AuthInitializedViewModel && viewModel.authType == AuthType.withBiometrics) {
              return const SizedBox();
            }

            return const Column(
              children: [
                HeroVideo(),
                WelcomeScreenContent(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HeroVideo extends StatefulWidget {
  const HeroVideo({super.key});

  @override
  State<HeroVideo> createState() => _HeroVideoState();
}

class _HeroVideoState extends State<HeroVideo> with WidgetsBindingObserver, RouteAware {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    final videoPath = ClientConfig.getClientConfig().uiSettings.welcomeVideoPath;
    _controller =
        VideoPlayerController.asset(videoPath, videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false));

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Remove splash screen after video is loaded
      FlutterNativeSplash.remove();

      if (IvoryApp.generalRouteObserver.routeStack.last == WelcomeScreen.routeName) {
        _controller.play();
        log("Playing video", name: "initState");
      }
    });

    _controller.setLooping(true);
    _controller.setVolume(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    IvoryApp.generalRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (IvoryApp.generalRouteObserver.routeStack.last != WelcomeScreen.routeName) {
      return;
    }

    if (state == AppLifecycleState.paused && _controller.value.isPlaying) {
      log("Pausing video", name: "didChangeAppLifecycleState: paused");
      _controller.pause();
    } else if (state == AppLifecycleState.resumed && !_controller.value.isPlaying) {
      log("Playing video", name: "didChangeAppLifecycleState: resumed");
      _controller.play();
    }
  }

  @override
  didPopNext() {
    _controller.play();
    log("Playing video", name: "didPopNet");

    super.didPopNext();
  }

  @override
  void didPushNext() {
    _controller.pause();
    log("Pausing video", name: "didPushNext");

    super.didPushNext();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    IvoryApp.generalRouteObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading video",
                style: ClientConfig.getTextStyleScheme()
                    .heading4
                    .copyWith(color: ClientConfig.getClientConfig().uiSettings.colorscheme.primary),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized) {
            return FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _controller.value.size.height,
                width: _controller.value.size.width,
                child: VideoPlayer(_controller),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}

class WelcomeScreenContent extends StatelessWidget {
  const WelcomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          children: [
            _Carousel(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: SecondaryButton(
                borderWidth: 2,
                text: "Log in",
                onPressed: () => Navigator.pushNamed(context, LoginScreen.routeName),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "Sign up",
                onPressed: () => Navigator.pushNamed(context, OnboardingStartScreen.routeName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Carousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    const List<_Slide> slides = [
      _Slide(
        title: "Manage your finances with our credit card",
        content:
            "From easy transaction monitoring to convenient bill payments, our app empowers you to stay on top of your finances, anytime and anywhere.",
      ),
      _Slide(
        title: "Seamless secure transactions",
        content:
            "Whether you're shopping online, in-store or abroad, our credit provides you with the confidence and convenience you deserve.",
      ),
      _Slide(
        title: "Generous credit limit",
        content:
            "Enjoy competitive interest rates and flexible repayment options tailored to your needs be it fixed or percentage-based.",
      )
    ];

    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: pageController,
            itemBuilder: (context, index) => slides[index],
            itemCount: slides.length,
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: pageController,
          count: slides.length,
          effect: SlideEffect(
            dotWidth: 8,
            dotHeight: 4,
            activeDotColor: ClientConfig.getColorScheme().secondary,
            dotColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.23),
          ),
        )
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final String content;

  const _Slide({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: ClientConfig.getTextStyleScheme().heading2,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Text(
            content,
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
