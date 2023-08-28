import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_action.dart';
import 'package:solarisdemo/screens/repayments/bills/bills_screen.dart';
import 'package:solarisdemo/screens/repayments/change_repayment_rate.dart';
import 'package:solarisdemo/screens/repayments/repayment_reminder.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/expanded_details_row.dart';
import 'package:solarisdemo/widgets/ivory_error_widget.dart';
import 'package:solarisdemo/widgets/ivory_list_tile.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../config.dart';
import '../../widgets/app_toolbar.dart';

class RepaymentsScreen extends StatelessWidget {
  static const routeName = "/repaymentsScreen";

  const RepaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            Text(
              'Repayments',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 24),
            Material(
              color: const Color(0xFFF8F9FA),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: StoreConnector<AppState, CreditLineViewModel>(
                onInit: (store) {
                  store.dispatch(GetCreditLineCommandAction(user: user.cognito));
                },
                converter: (store) => CreditLinePresenter.presentCreditLine(
                  creditLineState: store.state.creditLineState,
                  user: user,
                ),
                distinct: true,
                builder: (context, viewModel) {
                  if (viewModel is CreditLineLoadingViewModel) {
                    return Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: const CircularProgressIndicator(),
                    );
                  } else if (viewModel is CreditLineErrorViewModel) {
                    return Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: const IvoryErrorWidget('Error loading credit line details'),
                    );
                  }

                  return _DetailsContent(viewModel: viewModel as CreditLineFetchedViewModel);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Actions',
              style: ClientConfig.getTextStyleScheme().heading4,
            ),
            IvoryListTile(
              startIcon: Icons.sync,
              title: 'Change repayment rate',
              subtitle: 'And choose between percentage or fixed',
              onTap: () {
                Navigator.pushNamed(context, ChangeRepaymentRateScreen.routeName);
              },
            ),
            IvoryListTile(
              startIcon: Icons.notifications_active_outlined,
              title: 'Set repayment reminder',
              subtitle: 'Before we debit your reference account',
              onTap: () {
                Navigator.pushNamed(context, RepaymentReminderScreen.routeName);
              },
            ),
            IvoryListTile(
              startIcon: Icons.content_paste_search_rounded,
              title: 'View bills',
              subtitle: 'View all your repayment bills',
              onTap: () {
                Navigator.pushNamed(context, BillsScreen.routeName);
              },
            ),
            IvoryListTile(
              startIcon: Icons.analytics_outlined,
              title: 'Repayments analytics',
              subtitle: 'Check your repayment analytics',
              onTap: () {
                log('Repayments analytics');
              },
            ),
          ],
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailsItem(
            title: 'Outstanding balance',
            subtitle: Format.euro(widget.viewModel.creditLine.outstandingAmount.value),
            onInfoIconTap: () {
              showBottomModal(
                context: context,
                title: 'Outstanding balance',
                message:
                    'The outstanding balance includes any carried-over balance from previous billing cycles, new purchases, fees, and accrued interest. It represents the total amount that you owe.',
              );
            },
          ),
          const Divider(height: 24),
          _DetailsItem(
            title: 'Next full repayment',
            subtitle: Format.euro(widget.viewModel.creditLine.currentBillAmount.value),
            onInfoIconTap: () {
              showBottomModal(
                context: context,
                title: 'Next full repayment',
                message:
                    'This is the amount that will be automatically debited from your reference account this billing cycle. It includes your chosen repayment rate and the applicable interest rate.',
              );
            },
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Due on ${Format.date(widget.viewModel.creditLine.dueDate, pattern: 'MMM dd')}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpacedColumn(
            space: 8,
            children: [
              ExpandedDetailsRow(title: 'Amount spent', trailing: Format.euro(viewModel.creditLine.spentAmount.value)),
              ExpandedDetailsRow(
                title: 'Percentage repayment rate',
                trailing: '${viewModel.creditLine.repaymentRatePercentage}%',
                onInfoIconTap: () {
                  showBottomModal(
                    context: context,
                    title: 'Repayment rate',
                    message:
                        'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.'
                        '\n\nThe repayment rate will be automatically deducted from your reference account and added to your credit account which will increase your available spending balance.'
                        '\n\nPlease note that the repayment rate does not include any applicable interest charges.',
                  );
                },
              ),
              ExpandedDetailsRow(
                  title: 'Repayment amount', trailing: Format.euro(viewModel.creditLine.previousBillAmount.value)),
              ExpandedDetailsRow(
                title: 'Interest rate',
                trailing: '${viewModel.creditLine.interestRate}%',
                onInfoIconTap: () {
                  showBottomModal(
                    context: context,
                    title: 'Interest rate',
                    message:
                        'Our fixed interest rate of 5% remains the same, no matter the repayment type or rate you select. It will accrue based on your outstanding balance after the repayment has been deducted.',
                  );
                },
              ),
              ExpandedDetailsRow(
                title: 'Interest amount',
                trailing: Format.euro(viewModel.creditLine.accumulatedInterestAmount.value),
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
                      message:
                          'For your convenience, we automatically deduct the amount due from your designated reference account on the 4th of each month.'
                          '\n\nIf you want to change your reference account, please contact us at +49 151 23456789.',
                    );
                  }),
                ],
              ),
              ExpandedDetailsRow(title: 'Account owner', trailing: viewModel.ownerName),
              ExpandedDetailsRow(title: 'IBAN', trailing: Format.iban(viewModel.iban)),
            ],
          ),
        ),
      ],
    );
  }
}
