import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/widgets/rewards.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/skeleton.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/widgets/button_with_icon.dart';
import 'package:solarisdemo/screens/top_up/choose_method_screen.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_presenter.dart';

import '../../config.dart';
import '../../redux/app_state.dart';
import '../../redux/person/account_summary/account_summay_action.dart';

class IuliusHomeScreen extends StatelessWidget {
  static const routeName = "/homeScreen";

  const IuliusHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;

    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            richTextTitle: RichText(
              text: TextSpan(
                style: ClientConfig.getTextStyleScheme().heading3.copyWith(color: Colors.white, fontSize: 18),
                children: [TextSpan(text: 'Welcome ${user.cognito.firstName}!')],
              ),
            ),
            centerTitle: false,
            backgroundColor: ClientConfig.getColorScheme().primary,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            actions: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
                onPressed: () {},
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: const HomePageContent(),
            ),
          )
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomePageHeader(),
          const SizedBox(height: 32),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: const Rewards(),
          ),
        ],
      ),
    );
  }
}

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountSummaryViewModel>(
      onInit: (store) {
        store.dispatch(GetAccountSummaryCommandAction(forceAccountSummaryReload: false));
      },
      converter: (store) =>
          AccountSummaryPresenter.presentAccountSummary(accountSummaryState: store.state.accountSummaryState),
      builder: (context, viewModel) {
        return Container(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: ClientConfig.getColorScheme().primary,
          ),
          child: Row(
            children: [
              viewModel is AccountSummaryFetchedViewModel
                  ? AccountSummary(
                      viewModel: viewModel,
                    )
                  : Center(child: AccountSummary.loadingSkeleton()),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class AccountSummary extends StatelessWidget {
  final AccountSummaryFetchedViewModel viewModel;

  const AccountSummary({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountBalance(
          viewModel: viewModel,
        ),
        AccountStats(
          viewModel: viewModel,
        ),
      ],
    );
  }

  static Widget loadingSkeleton() {
    return const SkeletonContainer(
      colorTheme: SkeletonColorTheme.light,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Skeleton(height: 16, width: 136),
                  SizedBox(height: 12),
                  Skeleton(height: 40, width: 192),
                ],
              ),
              SizedBox(width: 40),
              SizedBox(height: 12),
              Skeleton(height: 40, width: 104),
            ],
          ),
          SizedBox(height: 12),
          Skeleton(height: 8),
          SizedBox(height: 12),
          Row(
            children: [
              Skeleton(height: 10, width: 64),
              Skeleton(height: 10, width: 64),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Skeleton(height: 16, width: 88),
              Skeleton(height: 16, width: 88),
            ],
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}

class AccountBalance extends StatelessWidget {
  final AccountSummaryFetchedViewModel viewModel;

  const AccountBalance({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available Balance",
                style: ClientConfig.getTextStyleScheme()
                    .labelSmall
                    .copyWith(color: ClientConfig.getCustomColors().neutral400),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: Format.currencyWithSymbol(viewModel.accountSummary?.availableBalance?.value ?? 0),
                      style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white, fontSize: 32),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 40),
          const AccountOptions(),
        ],
      ),
    );
  }
}

class AccountStats extends StatelessWidget {
  final AccountSummaryFetchedViewModel viewModel;

  const AccountStats({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cashback available",
                style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.grey),
              ),
              const SizedBox(width: 5),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: Format.currencyWithSymbol(viewModel.accountSummary?.outstandingAmount ?? 0),
                      style: ClientConfig.getTextStyleScheme()
                          .labelSmall
                          .copyWith(color: ClientConfig.getCustomColors().neutral400, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountOptions extends StatelessWidget {
  const AccountOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          ButtonWithIcon(
            text: 'Top-up',
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(5),
            onPressed: () => Navigator.pushNamed(context, ChooseMethodScreen.routeName),
            iconWidget: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            buttonColor: Colors.deepOrange,
            horizontalPadding: 0,
            verticalPadding: 0,
          ),
        ],
      ),
    );
  }
}
