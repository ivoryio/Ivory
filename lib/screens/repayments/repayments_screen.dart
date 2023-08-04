import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/yvory_list_tile.dart';

import '../../config.dart';
import '../../router/routing_constants.dart';
import '../../widgets/screen.dart';

class RepaymentsScreen extends StatelessWidget {
  const RepaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      customBackButtonCallback: () {
        context.push(homeRoute.path);
      },
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              ClientConfig.getCustomClientUiSettings()
                  .defaultScreenVerticalPadding,
              ClientConfig.getCustomClientUiSettings()
                  .defaultScreenVerticalPadding,
              ClientConfig.getCustomClientUiSettings()
                  .defaultScreenVerticalPadding,
              8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Repayments',
                  style: TextStyle(
                    fontSize: 32,
                    height: 40 / 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: const Color(0xFFF8F9FA),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CardItem(
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
                            _CardItem(
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
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            MaterialButton(
                              onPressed: () {
                                log('View Details button pressed');
                              },
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
                                  const Text(
                                    'View Details',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFCC0000),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Transform.rotate(
                                    angle: 1.57,
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 18,
                        height: 24 / 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          YvoryListTile(
            startIcon: Icons.sync,
            title: 'Change repayment rate',
            subtitle: 'And choose between percentage or fixed',
            onTap: () {
              log('Change repayment rate');
            },
          ),
          YvoryListTile(
            startIcon: Icons.notifications_active_outlined,
            title: 'Set repayment reminder',
            subtitle: 'Before we debit your reference account',
            onTap: () {
              log('Set repayment reminder');
            },
          ),
          YvoryListTile(
            startIcon: Icons.content_paste_search_rounded,
            title: 'View bills',
            subtitle: 'View all your repayment bills',
            onTap: () {
              log('View bills');
            },
          ),
          YvoryListTile(
            startIcon: Icons.analytics_outlined,
            title: 'Repayments analytics',
            subtitle: 'Check your repayment analytics',
            onTap: () {
              log('Repayments analytics');
            },
          ),
        ],
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onInfoIconTap;
  const _CardItem({
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
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onInfoIconTap,
                icon: const Icon(Icons.info_outline_rounded),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
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
