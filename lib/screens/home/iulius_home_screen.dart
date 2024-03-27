import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/widgets/rewards.dart';
import 'package:solarisdemo/widgets/skeleton.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/widgets/button_with_icon.dart';
import 'package:solarisdemo/screens/top_up/choose_method_screen.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_presenter.dart';

import '../../config.dart';
import '../../redux/app_state.dart';
import '../../widgets/account_balance_text.dart';
import '../../redux/person/account_summary/account_summay_action.dart';


class IuliusHomeScreen extends StatelessWidget {
  static const routeName = "/homeScreen";

  const IuliusHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;

    return Screen(
      title: 'Welcome ${user.cognito.firstName}!',
      hideBackButton: true,
      appBarColor: ClientConfig.getColorScheme().primary,
      trailingActions: [
        IconButton(
          icon: const Icon(
            Icons.savings_outlined,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
      titleTextStyle: ClientConfig.getTextStyleScheme().heading3.copyWith(color: Colors.white),
      centerTitle: false,
      child: const HomePageContent(),
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
          SizedBox(height: 12),
          Skeleton(height: 16, width: 136),
          SizedBox(height: 12),
          Skeleton(height: 40, width: 192),
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
    final creditLimitPercent =
        ((viewModel.accountSummary?.outstandingAmount ?? 0) / (viewModel.accountSummary?.creditLimit ?? 0.01));

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available Balance",
                style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8), 
              AccountBalanceText(
                value: viewModel.accountSummary?.availableBalance?.value ?? 0,
                numberStyle: ClientConfig.getTextStyleScheme().display.copyWith(color: Colors.white),
                centsStyle: const TextStyle(color: Colors.white, fontSize: 24),
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
              AccountBalanceText(
                value: viewModel.accountSummary?.outstandingAmount ?? 0,
                numberStyle: ClientConfig.getTextStyleScheme().labelLarge.copyWith(color: Colors.white),
                centsStyle: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
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
            horizontalPadding: 0.0,
            verticalPadding: 4.0,
          ),
        ],
      ),
    );
  }
}


class AccountOptionsButton extends StatelessWidget {
  final String textLabel;
  final Widget icon;
  final Function onPressed;

  const AccountOptionsButton({super.key, required this.textLabel, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFFFFF),
            fixedSize: const Size(50, 50),
            shape: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
          ),
          child: Center(
            child: IconButton(
              icon: icon,
              splashColor: Colors.transparent,
              color: Colors.black,
              onPressed: () => onPressed(),
              iconSize: 24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            textLabel,
            style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
          ),
        )
      ],
    );
  }
}

