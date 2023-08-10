import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_action.dart';
import 'package:solarisdemo/screens/repayments/repayment_reminder.dart';
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

    final screenPadding =
        EdgeInsets.symmetric(horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding);
    return ScreenScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppToolbar(padding: screenPadding),
            Column(
              children: [
                Padding(
                  padding: screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          converter: (store) =>
                              CreditLinePresenter.presentCreditLine(creditLineState: store.state.creditLineState),
                          distinct: true,
                          builder: (context, viewModel) {
                            Widget child;
                            if (viewModel is CreditLineLoadingViewModel || viewModel is CreditLineInitialViewModel) {
                              child = Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                child: const CircularProgressIndicator(),
                              );
                            } else if (viewModel is CreditLineErrorViewModel) {
                              child = Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                child: const IvoryErrorWidget('Error loading credit line details'),
                              );
                            } else {
                              child = _DetailsContent(viewModel: viewModel as CreditLineFetchedViewModel);
                            }
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: child,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Actions',
                        style: ClientConfig.getTextStyleScheme().heading4,
                      ),
                    ],
                  ),
                ),
                IvoryListTile(
                  startIcon: Icons.sync,
                  title: 'Change repayment rate',
                  subtitle: 'And choose between percentage or fixed',
                  onTap: () {
                    log('Change repayment rate');
                  },
                ),
                IvoryListTile(
                  startIcon: Icons.notifications_active_outlined,
                  title: 'Set repayment reminder',
                  subtitle: 'Before we debit your reference account',
                  onTap: () {
                    Navigator.pushNamed(context, RepaymentReminder.routeName);
                  },
                ),
                IvoryListTile(
                  startIcon: Icons.content_paste_search_rounded,
                  title: 'View bills',
                  subtitle: 'View all your repayment bills',
                  onTap: () {
                    log('View bills');
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
            subtitle: '€2,580.37',
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
            subtitle: '€595.46',
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Due on Aug 4',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                _detailsExpanded ? const Column(children: [_ExpandedDetails(), Divider(height: 1)]) : const SizedBox(),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCC0000),
                  ),
                ),
                const SizedBox(width: 8),
                Transform.rotate(
                  angle: !_detailsExpanded ? 1.57 : -1.57,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFFCC0000),
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
                _InfoIconButton(onTap: onInfoIconTap),
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
  const _ExpandedDetails();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpacedColumn(
            space: 8,
            children: [
              const _ExpandedDetailsRow(title: 'Amount spent', trailing: '€1,000.00'),
              const _ExpandedDetailsRow(title: 'Percentage repayment rate', trailing: '20%'),
              const _ExpandedDetailsRow(title: 'Repayment amount', trailing: '€200.00'),
              _ExpandedDetailsRow(
                title: 'Interest rate',
                trailing: '5%',
                onInfoIconTap: () {
                  showBottomModal(
                    context: context,
                    title: 'Interest rate',
                    message:
                        'Our fixed interest rate of 5% remains the same, no matter the repayment type or rate you select. It will accrue based on your outstanding balance after the repayment has been deducted.',
                  );
                },
              ),
              const _ExpandedDetailsRow(title: 'Interest amount', trailing: '€50.00'),
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
                  _InfoIconButton(onTap: () {
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
              const _ExpandedDetailsRow(title: 'Account owner', trailing: 'Laura'),
              const _ExpandedDetailsRow(title: 'IBAN', trailing: 'DE12 3456 7890 1234 5678 90'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpandedDetailsRow extends StatelessWidget {
  final String title;
  final String trailing;
  final VoidCallback? onInfoIconTap;

  const _ExpandedDetailsRow({
    required this.title,
    required this.trailing,
    this.onInfoIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
        ),
        if (onInfoIconTap != null) ...[
          const SizedBox(width: 4),
          _InfoIconButton(onTap: onInfoIconTap),
        ],
        const Spacer(),
        Text(
          trailing,
          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
        ),
      ],
    );
  }
}

class _InfoIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _InfoIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.info_outline_rounded),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
