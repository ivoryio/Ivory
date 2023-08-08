import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/models/transaction_model.dart';
import 'package:solarisdemo/screens/home/modals/new_transfer_popup.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';
import 'package:solarisdemo/widgets/transaction_listing_item.dart';

import '../../cubits/splitpay_cubit/splitpay_cubit.dart';
import '../../utilities/format.dart';
import '../../widgets/button.dart';

// ignore: must_be_immutable
class SplitpaySelectionScreen extends StatefulWidget {
  static const routeName = '/splitpaySelectionScreen';

  final Transaction transaction;
  late bool _optionOneSelected = true;
  late bool _optionTwoSelected = false;
  late bool _optionThreeSelected = false;

  SplitpaySelectionScreen({
    super.key,
    required this.transaction,
  });

  @override
  @override
  State<SplitpaySelectionScreen> createState() =>
      _SplitpaySelectionScreenState();
}

class _SplitpaySelectionScreenState extends State<SplitpaySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final SplitpayInfo optionOneSplitpayInfo = SplitpayInfo(
      widget.transaction,
      3,
    );
    final SplitpayInfo optionTwoSplitpayInfo = SplitpayInfo(
      widget.transaction,
      6,
    );
    final SplitpayInfo optionThreeSplitpayInfo = SplitpayInfo(
      widget.transaction,
      9,
    );

    SplitpayInfo selectedSplitpayInfo = widget._optionOneSelected
        ? optionOneSplitpayInfo
        : widget._optionTwoSelected
            ? optionTwoSplitpayInfo
            : optionThreeSplitpayInfo;

    final String currencySymbol =
        Format.getCurrencySymbol(widget.transaction.amount!.currency!);

    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          children: [
            const AppToolbar(title: 'Convert into instalments'),
            Expanded(
              child: Column(
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
                                onTap: () {
                                  setState(() {
                                    widget._optionOneSelected = true;
                                    widget._optionTwoSelected = false;
                                    widget._optionThreeSelected = false;
                                    selectedSplitpayInfo =
                                        optionOneSplitpayInfo;
                                  });
                                },
                                borderColor: widget._optionOneSelected
                                    ? Colors.black
                                    : const Color(0xFFEAECF0),
                                customHeight: 90,
                                customPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pay in ${optionOneSplitpayInfo.nrOfMonths} months',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Total $currencySymbol ${optionOneSplitpayInfo.totalAmount}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF667085),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '$currencySymbol ${optionOneSplitpayInfo.monthlyAmount}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            RadioButton(
                                              checked:
                                                  widget._optionOneSelected,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              BorderedContainer(
                                onTap: () {
                                  setState(() {
                                    widget._optionOneSelected = false;
                                    widget._optionTwoSelected = true;
                                    widget._optionThreeSelected = false;
                                    selectedSplitpayInfo =
                                        optionTwoSplitpayInfo;
                                  });
                                },
                                borderColor: widget._optionTwoSelected
                                    ? Colors.black
                                    : const Color(0xFFEAECF0),
                                customHeight: 90,
                                customPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pay in ${optionTwoSplitpayInfo.nrOfMonths} months',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Total $currencySymbol ${optionTwoSplitpayInfo.totalAmount}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF667085),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '$currencySymbol ${optionTwoSplitpayInfo.monthlyAmount}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            RadioButton(
                                              checked:
                                                  widget._optionTwoSelected,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              BorderedContainer(
                                onTap: () {
                                  setState(() {
                                    widget._optionOneSelected = false;
                                    widget._optionTwoSelected = false;
                                    widget._optionThreeSelected = true;
                                    selectedSplitpayInfo =
                                        optionThreeSplitpayInfo;
                                  });
                                },
                                borderColor: widget._optionThreeSelected
                                    ? Colors.black
                                    : const Color(0xFFEAECF0),
                                customHeight: 90,
                                customPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pay in ${optionThreeSplitpayInfo.nrOfMonths} months',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Total $currencySymbol ${optionThreeSplitpayInfo.totalAmount}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF667085),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '$currencySymbol ${optionThreeSplitpayInfo.monthlyAmount}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            RadioButton(
                                              checked:
                                                  widget._optionThreeSelected,
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
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: PrimaryButton(
                      text: "Convert into instalments",
                      onPressed: () {
                        context.read<SplitpayCubit>().setSelected(
                              widget.transaction,
                              selectedSplitpayInfo,
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
