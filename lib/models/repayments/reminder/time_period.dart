enum TimePeriod { hours, days, weeks }

extension TimePeriodExtension on TimePeriod {
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

  String description(int value) {
    switch (this) {
      case TimePeriod.hours:
        return value > 1 ? '$value hours before' : '1 hour before';
      case TimePeriod.days:
        return value > 1 ? '$value days before' : '1 day before';
      case TimePeriod.weeks:
        return value > 1 ? '$value weeks before' : '1 week before';
    }
  }
}
