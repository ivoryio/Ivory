import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen.dart';

class RepaymentReminder extends StatefulWidget {
  static const routeName = "/repaymentReminderScreen";

  const RepaymentReminder({Key? key}) : super(key: key);

  @override
  State<RepaymentReminder> createState() => _RepaymentReminderState();
}

class _RepaymentReminderState extends State<RepaymentReminder> {
  final List<DateTime> _reminders = [];

  @override
  Widget build(BuildContext context) {
    return Screen(
      titleTextStyle: const TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: StoreConnector<AppState, DateTime?>(
          converter: (store) => store.state.creditLineState is CreditLineFetchedState
              ? (store.state.creditLineState as CreditLineFetchedState).creditLine.dueDate
              : DateTime.now(),
          distinct: true,
          builder: (context, repaymentDueDate) {
            if (repaymentDueDate == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set repayment reminder',
                  style: ClientConfig.getTextStyleScheme().heading1,
                ),
                const SizedBox(height: 24),
                Text(
                  'We will remind you before we trigger the automatic repayment from your reference account whenever it’s more convenient for you.',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                ),
                const SizedBox(height: 24),
                if (_reminders.isNotEmpty) ...[
                  ..._reminders
                      .map(
                        (reminderDateTime) => ListTile(
                          leading: const Icon(Icons.notifications_none_rounded, color: Color(0xFFCC0000)),
                          title: Text(
                            Format.date(reminderDateTime, pattern: 'dd MMM yyyy, HH:mm'),
                            style: ClientConfig.getTextStyleScheme().heading4,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Color(0xFFCC0000)),
                            onPressed: () async {
                              final value = await showBottomModal(
                                context: context,
                                title: 'Are you sure you want to remove the reminder?',
                                content: const _RemoveReminderPopUp(),
                              );
                              if (value == true) {
                                setState(() => _reminders.remove(reminderDateTime));
                              }
                            },
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                      .toList(growable: false),
                  const SizedBox(height: 24),
                ],
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(6),
                  color: const Color(0xFFADADB4),
                  strokeWidth: 1.5,
                  strokeCap: StrokeCap.round,
                  dashPattern: const [5, 5],
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFCC0000),
                      minimumSize: const Size(double.infinity, 0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: 24,
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: const Text('Add reminder'),
                    onPressed: () async {
                      final value = await showBottomModal(
                        context: context,
                        title: 'Add reminder',
                        content: _PopUpContent(repaymentDueDate: repaymentDueDate),
                      );

                      if (value is TimePeriod) {
                        final reminderDate = repaymentDueDate.subtract(value.duration);
                        setState(() => _reminders.add(reminderDate));
                      } else if (value is DateTime) {
                        setState(() => _reminders.add(value));
                      }
                    },
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Save',
                    onPressed: _reminders.isNotEmpty ? _onSaveTap : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onSaveTap() {
    Navigator.pop(context);
  }
}

class _PopUpContent extends StatelessWidget {
  final DateTime repaymentDueDate;
  const _PopUpContent({Key? key, required this.repaymentDueDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ReminderListTile(
          title: '1 hour before',
          value: TimePeriod.hours,
          onChanged: (value) => Navigator.pop(context, value),
        ),
        _ReminderListTile(
          title: '1 day before',
          value: TimePeriod.days,
          onChanged: (value) => Navigator.pop(context, value),
        ),
        _ReminderListTile(
          title: '1 week before',
          value: TimePeriod.weeks,
          onChanged: (value) => Navigator.pop(context, value),
        ),
        _ReminderListTile(
          title: 'Custom',
          onChanged: (value) {
            showBottomModal(
              context: context,
              title: 'Custom notification',
              content: const _CustomReminderPopUpContent(),
            ).then((value) {
              if (value is (int, TimePeriod)) {
                final reminderDate = repaymentDueDate.subtract(value.$2.duration * value.$1);
                Navigator.pop(context, reminderDate);
              }
            });
          },
        ),
      ],
    );
  }
}

class _CustomReminderPopUpContent extends StatefulWidget {
  const _CustomReminderPopUpContent();

  @override
  State<_CustomReminderPopUpContent> createState() => _CustomReminderPopUpContentState();
}

class _CustomReminderPopUpContentState extends State<_CustomReminderPopUpContent> {
  final _textController = TextEditingController(text: '1');
  TimePeriod _timePeriod = TimePeriod.hours;

  void onChangedTimePeriod(TimePeriod? value) {
    setState(() => _timePeriod = value!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IvoryTextField(controller: _textController, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _ReminderListTile(
          title: 'Hours',
          value: TimePeriod.hours,
          groupValue: _timePeriod,
          onChanged: onChangedTimePeriod,
        ),
        _ReminderListTile(
          title: 'Days',
          value: TimePeriod.days,
          groupValue: _timePeriod,
          onChanged: onChangedTimePeriod,
        ),
        _ReminderListTile(
          title: 'Weeks',
          value: TimePeriod.weeks,
          groupValue: _timePeriod,
          onChanged: onChangedTimePeriod,
        ),
        // const Divider(height: 16),
        // _ReminderListTile(
        //   title: 'As push notification',
        //   value: NotificationType.push,
        //   groupValue: _notificationType,
        //   onChanged: onChangedNotificationType,
        // ),
        // _ReminderListTile(
        //   title: 'As email',
        //   value: NotificationType.email,
        //   groupValue: _notificationType,
        //   onChanged: onChangedNotificationType,
        // ),
        const Divider(height: 24),
        SizedBox(
          width: double.infinity,
          child: Button(
            text: 'Done',
            color: const Color(0xFFCC0000),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop((int.parse(_textController.text), _timePeriod));
            },
          ),
        ),
      ],
    );
  }
}

class _RemoveReminderPopUp extends StatelessWidget {
  const _RemoveReminderPopUp();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(text: 'No, go back', onPressed: () => Navigator.of(context).pop()),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Button(
            text: 'Yes, remove reminder',
            color: const Color(0xFFCC0000),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
      ],
    );
  }
}

enum TimePeriod { hours, days, weeks }

class _ReminderListTile<T> extends StatelessWidget {
  final String title;
  final T? value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  const _ReminderListTile({
    required this.title,
    this.value,
    this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged?.call(value as T);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio(
              value: value ?? '',
              groupValue: groupValue,
              onChanged: (value) {},
              activeColor: const Color(0xFFCC0000),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
          ],
        ),
      ),
    );
  }
}

extension on TimePeriod {
  Duration get duration {
    switch (this) {
      case TimePeriod.hours:
        return const Duration(hours: 1);
      case TimePeriod.days:
        return const Duration(days: 1);
      case TimePeriod.weeks:
        return const Duration(days: 7);
    }
  }
}
