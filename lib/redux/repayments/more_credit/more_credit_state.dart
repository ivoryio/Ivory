import 'package:equatable/equatable.dart';

abstract class MoreCreditState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoreCreditInitialState extends MoreCreditState {}

class MoreCreditLoadingState extends MoreCreditState {}

class MoreCreditErrorState extends MoreCreditState {}

class MoreCreditFetchedState extends MoreCreditState {
  final bool waitlist;

  MoreCreditFetchedState(this.waitlist);

  @override
  List<Object?> get props => [waitlist];
}
