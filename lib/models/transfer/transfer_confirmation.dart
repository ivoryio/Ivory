import 'package:equatable/equatable.dart';

class TransferConfirmation extends Equatable {
  final bool success;

  const TransferConfirmation({
    required this.success,
  });

  @override
  List<Object?> get props => [];
}
