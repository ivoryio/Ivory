import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../config.dart';

class DateRangePicker extends StatelessWidget {
  final DateTimeRange? initialSelectedRange;
  final void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;

  const DateRangePicker({
    super.key,
    this.onSelectionChanged,
    this.initialSelectedRange,
  });

  @override
  Widget build(BuildContext context) {
    final selectedRange = initialSelectedRange != null
        ? PickerDateRange(
            initialSelectedRange?.start, initialSelectedRange?.end)
        : null;

    return SfDateRangePicker(
      monthFormat: 'MMMM',
      yearCellStyle: DateRangePickerYearCellStyle(
        textStyle: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
        todayCellDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
        ),
        todayTextStyle: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
        cellDecoration: BoxDecoration(
          color: Colors.white,
         borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: const Color(0xFFDFE2E6),
          ),
        ),
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        leadingDatesTextStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Color(0xFFD6D8E1),
        ),
        trailingDatesTextStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Color(0xFFD6D8E1),
        ),
        todayTextStyle:  ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
        todayCellDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
        ),
        textStyle: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
      ),
      monthViewSettings: const DateRangePickerMonthViewSettings(
        enableSwipeSelection: true,
        firstDayOfWeek: 1,
        showTrailingAndLeadingDates: true,
        dayFormat: 'EEE',
        viewHeaderHeight: 30,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Proxima Nova',
            fontWeight: FontWeight.w600,
            color: Color(0xFF9B9EB2),
          ),
        ),
      ),
      headerStyle: const DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          height: 1.5,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      showNavigationArrow: true,
      selectionColor: Colors.black,
      rangeSelectionColor: const Color(0xFFDFE2E6),
      initialDisplayDate: DateTime.now(),
      endRangeSelectionColor: ClientConfig.getColorScheme().secondary,
      startRangeSelectionColor: ClientConfig.getColorScheme().secondary,
      selectionMode: DateRangePickerSelectionMode.range,
      selectionShape: DateRangePickerSelectionShape.circle,
      selectionTextStyle: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(color: Colors.white),
      initialSelectedRange: selectedRange,
      rangeTextStyle: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
      onSelectionChanged: onSelectionChanged,
    );
  }
}
