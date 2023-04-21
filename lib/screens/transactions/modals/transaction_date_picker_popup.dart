import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:solarisdemo/themes/default_theme.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/date_range_picker.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utilities/format.dart';

class TransactionDatePickerPopup extends StatefulWidget {
  final Function(DateTimeRange) onDateRangeSelected;
  const TransactionDatePickerPopup({
    super.key,
    required this.onDateRangeSelected,
  });

  @override
  State<TransactionDatePickerPopup> createState() =>
      _TransactionDatePickerPopupState();
}

class _TransactionDatePickerPopupState
    extends State<TransactionDatePickerPopup> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 440,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultScreenHorizontalPadding,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DateRangePicker(
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange &&
                      args.value.startDate != null &&
                      args.value.endDate != null) {
                    final DateTime rangeStartDate = args.value.startDate;
                    final DateTime rangeEndDate = args.value.endDate;

                    setState(() {
                      _dateRange = DateTimeRange(
                        start: rangeStartDate,
                        end: rangeEndDate,
                      );
                    });
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: "Apply date",
                      onPressed: () {
                        widget.onDateRangeSelected(_dateRange);
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}