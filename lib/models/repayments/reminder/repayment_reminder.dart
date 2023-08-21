import 'package:equatable/equatable.dart';

class RepaymentReminder extends Equatable {
  final String? id;
  final DateTime datetime;
  final String description;

  const RepaymentReminder({
    this.id,
    required this.datetime,
    required this.description,
  });

  @override
  List<Object?> get props => [datetime, description];
}
