import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/date_range_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../config.dart';

class TransactionDatePickerPopup extends StatefulWidget {
  final DateTimeRange? initialSelectedRange;
  final Function(DateTimeRange) onDateRangeSelected;
  const TransactionDatePickerPopup({
    super.key,
    required this.onDateRangeSelected,
    this.initialSelectedRange,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DateRangePicker(
          initialSelectedRange: widget.initialSelectedRange,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value is PickerDateRange) {
              final DateTime rangeStartDate =
                  args.value.startDate ?? args.value.endDate;
              final DateTime rangeEndDate =
                  args.value.endDate ?? args.value.startDate;

              setState(() {
                _dateRange = DateTimeRange(
                  start: rangeStartDate,
                  end: rangeEndDate,
                );
              });
            }
          },
        ),
        const SizedBox(height: 24,),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return ClientConfig.getColorScheme().tertiary;
              }),
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)))),
            ),
            child: Text(
              "Apply dates",
              style: ClientConfig.getTextStyleScheme()
                  .bodyLargeRegularBold
                  .copyWith(color: ClientConfig.getColorScheme().surface),
            ),
            onPressed: () {
              widget.onDateRangeSelected(_dateRange);
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
