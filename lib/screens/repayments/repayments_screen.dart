import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_action.dart';
import 'package:solarisdemo/screens/repayments/bills/bills_screen.dart';
import 'package:solarisdemo/screens/repayments/change_repayment_rate.dart';
import 'package:solarisdemo/screens/repayments/more_credit/more_credit_screen.dart';
import 'package:solarisdemo/screens/repayments/more_credit/more_credit_waitlist_screen.dart';
import 'package:solarisdemo/screens/repayments/repayment_reminder.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/expanded_details_row.dart';
import 'package:solarisdemo/widgets/ivory_error_widget.dart';
import 'package:solarisdemo/widgets/ivory_list_tile.dart';
import 'package:solarisdemo/widgets/ivory_list_title.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/skeleton.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../config.dart';
import '../../redux/repayments/more_credit/more_credit_action.dart';
import '../../widgets/app_toolbar.dart';

class RepaymentsScreen extends StatelessWidget {
  static const routeName = "/repaymentsScreen";

  const RepaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;
    final ScrollController scrollController = ScrollController();

    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            title: "Repayments",
            scrollController: scrollController,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              child: StoreConnector<AppState, CreditLineViewModel>(
                onInit: (store) {
                  store.dispatch(GetCreditLineCommandAction());
                  store.dispatch(GetMoreCreditCommandAction());
                },
                converter: (store) => RepaymentsPresenter.presentCreditLine(
                  creditLineState: store.state.creditLineState,
                  moreCreditState: store.state.moreCreditState,
                  user: user,
                ),
                distinct: true,
                builder: (context, viewModel) {
                  if (viewModel is CreditLineLoadingViewModel) {
                    return _buildLoadingSkeleton();
                  }

                  return _buildRepaymentsContent(context, viewModel);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenTitle(
          "Repayments",
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        ),
        Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              SkeletonContainer(
                colorTheme: SkeletonColorTheme.darkReverse,
                child: Container(
                  decoration: BoxDecoration(
                    color: ClientConfig.getCustomColors().neutral100.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Skeleton(height: 16, width: 136, transparent: true),
                            SizedBox(height: 12),
                            Skeleton(height: 32, width: 192, transparent: true),
                          ],
                        ),
                      ),
                      Divider(height: 24, color: Colors.transparent.withOpacity(0)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Skeleton(height: 16, width: 136, transparent: true),
                            SizedBox(height: 12),
                            Skeleton(height: 32, width: 192, transparent: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Skeleton(height: 10, width: 64, transparent: true),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: Colors.transparent.withOpacity(0)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(height: 18),
                            Center(
                              child: Skeleton(height: 18, width: 160, transparent: true),
                            ),
                            SizedBox(height: 19),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const IvoryListTitle(title: 'Actions'),
        Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          child: SkeletonContainer(
            child: Column(
              children: [
                for (var i = 0; i < 5; i++) const ActionSkeleton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepaymentsContent(context, CreditLineViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenTitle("Repayments"),
              const SizedBox(height: 24),
              Material(
                clipBehavior: Clip.none,
                color: ClientConfig.getCustomColors().neutral100,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: viewModel is CreditLineErrorViewModel
                    ? Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: const IvoryErrorWidget('Error loading credit line details'),
                      )
                    : _DetailsContent(viewModel: viewModel as CreditLineFetchedViewModel),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const IvoryListTitle(title: 'Actions'),
        IvoryListTile(
          leftIcon: Icons.sync,
          title: 'Change repayment rate',
          subtitle: 'And choose between percentage or fixed',
          onTap: () {
            Navigator.pushNamed(context, ChangeRepaymentRateScreen.routeName);
          },
        ),
        IvoryListTile(
          leftIcon: Icons.notifications_active_outlined,
          title: 'Set repayment reminder',
          subtitle: 'Before we debit your reference account',
          onTap: () {
            Navigator.pushNamed(context, RepaymentReminderScreen.routeName);
          },
        ),
        IvoryListTile(
          leftIcon: Icons.content_paste_search_rounded,
          title: 'View bills',
          subtitle: 'View all your repayment bills',
          onTap: () {
            Navigator.pushNamed(context, BillsScreen.routeName);
          },
        ),
        IvoryListTile(
          leftIcon: Icons.analytics_outlined,
          title: 'Repayments analytics',
          subtitle: 'Check your repayment analytics',
          onTap: () {
            log('Repayments analytics');
          },
        ),
        IvoryListTile(
          leftIcon: Icons.back_hand_outlined,
          title: 'Need more credit?',
          subtitle: (viewModel is CreditLineFetchedViewModel && viewModel.waitlist == false)
              ? ('Sign up for our waitlist')
              : ('You\'re on our waitlist'),
          onTap: () {
            (viewModel is CreditLineFetchedViewModel && viewModel.waitlist == false)
                ? Navigator.pushNamed(context, MoreCreditScreen.routeName)
                : Navigator.pushNamed(context, MoreCreditWaitlistScreen.routeName);
          },
        ),

        //     if (viewModel is MoreCreditErrorViewModel) {
        //       return const Text('Error loading more credit details');
        //     }
      ],
    );
  }
}

class _DetailsContent extends StatefulWidget {
  final CreditLineFetchedViewModel viewModel;

  const _DetailsContent({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<_DetailsContent> createState() => _DetailsContentState();
}

class _DetailsContentState extends State<_DetailsContent> {
  bool _detailsExpanded = false;

  @override
  Widget build(BuildContext context) {
    var outstandingAmount = widget.viewModel.creditLine.outstandingAmount.value;
    var currentBillAmount = widget.viewModel.creditLine.currentBillAmount.value;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailsItem(
            title: 'Outstanding balance',
            subtitle: outstandingAmount == 0 ? '€ 0' : Format.euro(outstandingAmount),
            onInfoIconTap: () {
              showBottomModal(
                context: context,
                title: 'Outstanding balance',
                textWidget: Text(
                  'The outstanding balance includes any carried-over balance from previous billing cycles, new purchases, fees, and accrued interest. It represents the total amount that you owe. It updates after the bill is generated each month.',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                ),
              );
            },
          ),
          const Divider(height: 24),
          _DetailsItem(
            title: 'Next full repayment',
            subtitle: currentBillAmount == 0 ? '€ 0' : Format.euro(currentBillAmount),
            onInfoIconTap: () {
              showBottomModal(
                context: context,
                title: 'Next full repayment',
                textWidget: Text(
                  'This is the amount that will be automatically debited from your reference account this billing cycle. It includes your chosen repayment rate and the applicable interest rate. It updates after the bill is generated each month.',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Due on ${Format.date(widget.viewModel.creditLine.dueDate, pattern: 'MMM dd')}',
              style: ClientConfig.getTextStyleScheme()
                  .labelSmall
                  .copyWith(color: ClientConfig.getCustomColors().neutral900),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _detailsExpanded
                ? Column(children: [_ExpandedDetails(viewModel: widget.viewModel), const Divider(height: 1)])
                : const SizedBox(),
          ),
          MaterialButton(
            onPressed: () => setState(() => _detailsExpanded = !_detailsExpanded),
            minWidth: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  !_detailsExpanded ? 'View Details' : 'View less',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                        color: ClientConfig.getColorScheme().secondary,
                      ),
                ),
                const SizedBox(width: 8),
                Transform.rotate(
                  angle: !_detailsExpanded ? 1.57 : -1.57,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: ClientConfig.getColorScheme().secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onInfoIconTap;

  const _DetailsItem({
    required this.title,
    required this.subtitle,
    this.onInfoIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
              ),
              if (onInfoIconTap != null) ...[
                const SizedBox(width: 4),
                InfoIconButton(onTap: onInfoIconTap),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: ClientConfig.getTextStyleScheme().heading2,
          ),
        ],
      ),
    );
  }
}

class _ExpandedDetails extends StatelessWidget {
  final CreditLineFetchedViewModel viewModel;

  const _ExpandedDetails({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    num repaymentPercentageRate = viewModel.creditLine.repaymentPercentageRate;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpacedColumn(
            space: 8,
            children: [
              ExpandedDetailsRow(title: 'Amount spent', trailing: Format.currency(viewModel.creditLine.spentAmount)),
              if (repaymentPercentageRate < 10) ...[
                ExpandedDetailsRow(
                  title: 'Fixed repayment rate',
                  trailing: Format.currency(viewModel.creditLine.fixedRate.value),
                  onInfoIconTap: () {
                    showBottomModal(
                      context: context,
                      title: 'Repayment rate',
                      textWidget: Text(
                        'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.'
                        '\n\nThe repayment rate will be automatically deducted from your reference account and added to your credit account which will increase your available spending balance.'
                        '\n\nPlease note that the repayment rate does not include any applicable interest charges.',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      ),
                    );
                  },
                ),
              ],
              if (repaymentPercentageRate >= 10) ...[
                ExpandedDetailsRow(
                  title: 'Percentage repayment rate',
                  trailing: '$repaymentPercentageRate%',
                  onInfoIconTap: () {
                    showBottomModal(
                      context: context,
                      title: 'Repayment rate',
                      textWidget: Text(
                        'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.'
                        '\n\nThe repayment rate will be automatically deducted from your reference account and added to your credit account which will increase your available spending balance.'
                        '\n\nPlease note that the repayment rate does not include any applicable interest charges.',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      ),
                    );
                  },
                ),
                ExpandedDetailsRow(
                  title: 'Repayment amount',
                  trailing: Format.currency(viewModel.creditLine.spentAmount * (repaymentPercentageRate / 100)),
                ),
              ],
              ExpandedDetailsRow(
                title: 'Interest rate',
                trailing: '5%', //'${viewModel.creditLine.interestRate}%',
                onInfoIconTap: () {
                  showBottomModal(
                    context: context,
                    title: 'Interest rate',
                    textWidget: Text(
                      'Our fixed interest rate of 5% remains the same, no matter the repayment type or rate you select. It will accrue based on your outstanding balance after the repayment has been deducted.',
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                  );
                },
              ),
              ExpandedDetailsRow(
                title: 'Interest amount',
                trailing: Format.currency(viewModel.creditLine.accumulatedInterestAmount.value),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpacedColumn(
            space: 8,
            children: [
              Row(
                children: [
                  Text(
                    'Reference account',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const SizedBox(width: 4),
                  InfoIconButton(onTap: () {
                    showBottomModal(
                      context: context,
                      title: 'Reference account',
                      textWidget: Text(
                        'For your convenience, we automatically deduct the amount due from your designated reference account on the 4th of each month.'
                        '\n\nIf you want to change your reference account, please contact us at +49 151 23456789.',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      ),
                    );
                  }),
                ],
              ),
              ExpandedDetailsRow(title: 'Account owner', trailing: viewModel.creditLine.referenceAccount.ownerName),
              ExpandedDetailsRow(title: 'IBAN', trailing: Format.iban(viewModel.creditLine.referenceAccount.iban)),
            ],
          ),
        ),
      ],
    );
  }
}

class ActionSkeleton extends StatelessWidget {
  const ActionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Skeleton(height: 24, width: 24, borderRadius: BorderRadius.circular(100)),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Skeleton(height: 16, width: 128),
                SizedBox(height: 8),
                Skeleton(height: 10, width: 200),
                SizedBox(height: 4),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
