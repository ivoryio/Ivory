import 'package:equatable/equatable.dart';

class PersonReferenceAccount extends Equatable {
  final String name;
  final String iban;

  const PersonReferenceAccount({
    required this.name,
    required this.iban,
  });

  @override
  List<Object?> get props => [name, iban];
}
