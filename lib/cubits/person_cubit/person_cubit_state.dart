part of 'person_cubit.dart';

abstract class PersonCubitState extends Equatable {
  final bool loading;
  final Person? person;

  const PersonCubitState({this.loading = false, this.person});

  @override
  List<Object> get props => [loading];
}

class PersonCubitInitial extends PersonCubitState {
  const PersonCubitInitial() : super(loading: true, person: null);
}

class PersonCubitLoading extends PersonCubitState {
  const PersonCubitLoading() : super(loading: true, person: null);
}

class PersonCubitLoaded extends PersonCubitState {
  const PersonCubitLoaded(Person person)
      : super(loading: false, person: person);
}

class PersonCubitError extends PersonCubitState {
  const PersonCubitError() : super(loading: false, person: null);
}
