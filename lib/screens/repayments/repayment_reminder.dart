import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_presenter.dart';
import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_error_widget.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../models/repayments/reminder/time_period.dart';

class RepaymentReminderScreen extends StatefulWidget {
  static const routeName = "/repaymentReminderScreen";

  const RepaymentReminderScreen({Key? key}) : super(key: key);

  @override
  State<RepaymentReminderScreen> createState() => _RepaymentReminderScreenState();
}

class _RepaymentReminderScreenState extends State<RepaymentReminderScreen> {
  final List<RepaymentReminder> _initialReminders = [];
  final List<RepaymentReminder> _reminders = [];

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;

    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          children: [
            const AppToolbar(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Set repayment reminder',
                style: ClientConfig.getTextStyleScheme().heading1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We will remind you before we trigger the automatic repayment from your reference account whenever it’s more convenient for you.',
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: StoreConnector<AppState, RepaymentReminderViewModel>(
                onInit: (store) => store.dispatch(GetRepaymentRemindersCommandAction(user: user.cognito)),
                converter: (store) => RepaymentReminderPresenter.presentRepaymentReminder(
                  repaymentReminderState: store.state.repaymentReminderState,
                  creditLineState: store.state.creditLineState,
                ),
                onDidChange: (oldViewModel, viewModel) {
                  if (viewModel is RepaymentReminderFetchedViewModel) {
                    _reminders.clear();
                    _initialReminders.clear();
                    setState(() {
                      _reminders.addAll(viewModel.repaymentReminders);
                      _initialReminders.addAll(viewModel.repaymentReminders);
                    });
                  }
                },
                distinct: true,
                builder: (context, viewModel) {
                  if (viewModel is RepaymentReminderLoadingViewModel) {
                    return const Align(alignment: Alignment.topCenter, child: CircularProgressIndicator());
                  }

                  if (viewModel is RepaymentReminderErrorViewModel) {
                    return const Align(
                      alignment: Alignment.topCenter,
                      child: IvoryErrorWidget('Error loading repayment reminders'),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_reminders.isNotEmpty) ...[
                          ..._reminders
                              .map(
                                (reminder) => ListTile(
                                  minLeadingWidth: 0,
                                  leading: Icon(Icons.notifications_none_rounded,
                                      color: ClientConfig.getColorScheme().secondary),
                                  title: Text(
                                    reminder.description,
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
                                        _onDeleteReminder(reminder);
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
                          color: ClientConfig.getCustomColors().neutral500,
                          strokeWidth: 1.5,
                          strokeCap: StrokeCap.round,
                          dashPattern: const [5, 5],
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: ClientConfig.getColorScheme().secondary,
                              minimumSize: const Size(double.infinity, 0),
                              padding: const EdgeInsets.symmetric(
                                vertical: 22,
                                horizontal: 24,
                              ),
                            ),
                            icon: Icon(
                              Icons.notifications_active_outlined,
                              color: ClientConfig.getColorScheme().secondary,
                            ),
                            label: Text(
                              'Add reminder',
                              style: ClientConfig.getTextStyleScheme()
                                  .bodyLargeRegularBold
                                  .copyWith(color: ClientConfig.getColorScheme().secondary),
                            ),
                            onPressed: () async {
                              final value = await showBottomModal(
                                context: context,
                                title: 'Add reminder',
                                content: _PopUpContent(
                                  reminders: _reminders,
                                  repaymentDueDate: (viewModel as RepaymentReminderFetchedViewModel).repaymentDueDate,
                                ),
                              );

                              if (value is TimePeriod) {
                                final reminderDate = viewModel.repaymentDueDate.subtract(value.duration);
                                final description = value.description(1);
                                setState(() {
                                  _reminders.add(RepaymentReminder(datetime: reminderDate, description: description));
                                });
                              } else if (value is RepaymentReminder) {
                                setState(() => _reminders.add(value));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Button(
                text: "Save",
                onPressed: _reminders.isNotEmpty ? () => _onSaveTap(user.cognito) : null,
                color: ClientConfig.getColorScheme().tertiary,
                textColor: ClientConfig.getColorScheme().surface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDeleteReminder(RepaymentReminder reminder) {
    if (reminder.id != null) {
      StoreProvider.of<AppState>(context).dispatch(DeleteRepaymentReminderCommandAction(reminder: reminder));
    }
  }

  void _onSaveTap(User user) {
    final remindersToAdd = _reminders.where((reminder) => !_initialReminders.contains(reminder)).toList();

    if (remindersToAdd.isNotEmpty) {
      StoreProvider.of<AppState>(context).dispatch(
        UpdateRepaymentRemindersCommandAction(user: user, reminders: remindersToAdd),
      );
    }

    Timer(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}

class _PopUpContent extends StatelessWidget {
  final List<RepaymentReminder> reminders;
  final DateTime repaymentDueDate;

  const _PopUpContent({required this.repaymentDueDate, required this.reminders});

  bool _isReminderSelected(TimePeriod value) {
    final existingReminder = reminders.firstWhereOrNull((reminder) {
      return reminder.datetime == repaymentDueDate.subtract(value.duration);
    });

    return existingReminder != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ReminderListTile(
          title: '1 hour before',
          value: TimePeriod.hours,
          groupValue: _isReminderSelected(TimePeriod.hours) ? TimePeriod.hours : null,
          onChanged: !_isReminderSelected(TimePeriod.hours) ? (value) => Navigator.pop(context, value) : null,
        ),
        _ReminderListTile(
          title: '1 day before',
          value: TimePeriod.days,
          groupValue: _isReminderSelected(TimePeriod.days) ? TimePeriod.days : null,
          onChanged: !_isReminderSelected(TimePeriod.days) ? (value) => Navigator.pop(context, value) : null,
        ),
        _ReminderListTile(
          title: '1 week before',
          value: TimePeriod.weeks,
          groupValue: _isReminderSelected(TimePeriod.weeks) ? TimePeriod.weeks : null,
          onChanged: !_isReminderSelected(TimePeriod.weeks) ? (value) => Navigator.pop(context, value) : null,
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
                final reminder = RepaymentReminder(
                  datetime: reminderDate,
                  description: value.$2.description(value.$1),
                );

                Navigator.pop(context, reminder);
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
  final _textController = IvoryTextFieldController(text: '1');
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
        const Divider(height: 24),
        SizedBox(
          width: double.infinity,
          child: Button(
            text: 'Done',
            color: ClientConfig.getColorScheme().tertiary,
            textColor: ClientConfig.getColorScheme().surface,
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
        if (onChanged != null && value != null) {
          onChanged!(value as T);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio(
              value: value ?? '',
              groupValue: groupValue,
              onChanged: (value) {
                if (onChanged != null && value != null) {
                  onChanged!(value as T);
                }
              },
              activeColor: ClientConfig.getColorScheme().secondary,
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
