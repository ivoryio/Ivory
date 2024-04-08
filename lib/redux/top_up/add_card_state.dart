import 'package:equatable/equatable.dart';

abstract class AddCardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddCardInfoInitialState extends AddCardInfoState {}

class AddCardInfoErrorState extends AddCardInfoState {}

class AddCardInfoState extends AddCardState {
  final String? cardHolder;
  final String? cardNumber;
  final String? month;
  final String? year;
  final String? cvv;

  AddCardInfoState({
    this.cardHolder,
    this.cardNumber,
    this.month,
    this.year,
    this.cvv,
  });
}