import 'package:equatable/equatable.dart';

class ReferenceAccount extends Equatable {
  final String name;
  final String iban;

  const ReferenceAccount({
    required this.name,
    required this.iban,
  });

  @override
  List<Object?> get props => [name, iban];
}
