import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/models/transaction_model.dart';
import 'package:solarisdemo/screens/home/modals/new_transfer_popup.dart';
import 'package:solarisdemo/themes/default_theme.dart';
import 'package:solarisdemo/widgets/screen.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';
import 'package:solarisdemo/widgets/transaction_listing_item.dart';

import '../../cubits/splitpay_cubit/splitpay_cubit.dart';
import '../../widgets/button.dart';

class SplitpaySelectionScreen extends StatefulWidget {
  final Transaction transaction;
  final bool _optionOneSelected = true;
  final bool _optionTwoSelected = false;
  final bool _optionThreeSelected = false;

  const SplitpaySelectionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<SplitpaySelectionScreen> createState() =>
      _SplitpaySelectionScreenState();
}

class _SplitpaySelectionScreenState extends State<SplitpaySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Convert into instalments',
      hideBottomNavbar: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: defaultScreenHorizontalPadding,
          right: defaultScreenHorizontalPadding,
          top: defaultScreenVerticalPadding,
          bottom: defaultScreenVerticalPadding + 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedColumn(
              space: 40,
              children: [
                TransactionListItem(
                  transaction: widget.transaction,
                  isClickable: false,
                ),
                SpacedColumn(
                  space: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SpacedColumn(
                      space: 8,
                      children: [
                        BorderedContainer(
                          borderColor: widget._optionOneSelected
                              ? Colors.black
                              : const Color(0xFFEAECF0),
                          customHeight: 90,
                          customPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pay in 3 months',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Total € 355.85',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '- \$ 150',
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      RadioButton(
                                        checked: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        BorderedContainer(
                          borderColor: widget._optionTwoSelected
                              ? Colors.black
                              : const Color(0xFFEAECF0),
                          customHeight: 90,
                          customPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pay in 6 months',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Total € 366.85',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '- \$ 150',
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      RadioButton(
                                        checked: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        BorderedContainer(
                          borderColor: widget._optionThreeSelected
                              ? Colors.black
                              : const Color(0xFFEAECF0),
                          customHeight: 90,
                          customPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pay in 9 months',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Total € 355.85',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '- \$ 150',
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      RadioButton(
                                        checked: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: PrimaryButton(
                  text: "Convert into instalments",
                  onPressed: () {
                    context
                        .read<SplitpayCubit>()
                        .setSelected(widget.transaction);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
