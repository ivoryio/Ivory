import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionDatePickerPopup extends StatefulWidget {
  const TransactionDatePickerPopup({super.key});

  @override
  State<TransactionDatePickerPopup> createState() =>
      _TransactionDatePickerPopupState();
}

class _TransactionDatePickerPopupState
    extends State<TransactionDatePickerPopup> {
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
            horizontal: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                ),
                child: SfDateRangePicker(
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
                  headerHeight: 65,
                  initialDisplayDate: DateTime.now(),
                  selectionMode: DateRangePickerSelectionMode.range,
                  showNavigationArrow: true,
                  selectionShape: DateRangePickerSelectionShape.rectangle,
                  selectionTextStyle: const TextStyle(color: Colors.white),
                  selectionColor: Colors.black,
                  startRangeSelectionColor: Colors.black,
                  endRangeSelectionColor: Colors.black,
                  rangeSelectionColor: Colors.black,
                  rangeTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
