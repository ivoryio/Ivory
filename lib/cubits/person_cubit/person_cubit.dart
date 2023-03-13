import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/person_model.dart';
import '../../services/person_service.dart';

part 'person_cubit_state.dart';

class PersonCubit extends Cubit<PersonCubitState> {
  final PersonService personService;

  PersonCubit({required this.personService})
      : super(const PersonCubitInitial());

  Future<void> getPerson() async {
    try {
      emit(const PersonCubitLoading());
      Person? person = await personService.getPerson();

      if (person is Person) {
        emit(PersonCubitLoaded(person));
      } else {
        emit(const PersonCubitInitial());
      }
    } catch (e) {
      emit(const PersonCubitError());
    }
  }
}
