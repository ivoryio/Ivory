import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
      monthFormat: 'MMM',
      yearCellStyle: const DateRangePickerYearCellStyle(
        textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Colors.black,
        ),
        todayCellDecoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      monthCellStyle: const DateRangePickerMonthCellStyle(
        leadingDatesTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Color(0xFFD6D8E1),
        ),
        trailingDatesTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Color(0xFFD6D8E1),
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black,
        ),
        todayCellDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      monthViewSettings: const DateRangePickerMonthViewSettings(
        enableSwipeSelection: true,
        firstDayOfWeek: 1,
        showTrailingAndLeadingDates: true,
        dayFormat: 'EEE',
        viewHeaderHeight: 35,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      headerStyle: const DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          height: 1.5,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      showNavigationArrow: true,
      selectionColor: Colors.black,
      rangeSelectionColor: Colors.black,
      initialDisplayDate: DateTime.now(),
      endRangeSelectionColor: Colors.black,
      startRangeSelectionColor: Colors.black,
      selectionMode: DateRangePickerSelectionMode.range,
      selectionShape: DateRangePickerSelectionShape.rectangle,
      selectionTextStyle: const TextStyle(color: Colors.white),
      initialSelectedRange: selectedRange,
      rangeTextStyle: const TextStyle(
        color: Colors.white,
      ),
      onSelectionChanged: onSelectionChanged,
    );
  }
}
