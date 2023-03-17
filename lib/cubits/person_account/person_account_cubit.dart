import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/person_account.dart';
import '../../services/person_service.dart';

part 'person_account_state.dart';

class PersonAccountCubit extends Cubit<PersonAccountState> {
  final PersonService personService;

  PersonAccountCubit({
    required this.personService,
  }) : super(PersonAccountInitial());

  Future<void> getPersonAccounts() async {
    try {
      String personId = 'mockpersonkontistgmbh';

      emit(const PersonAccountLoading());
      List<PersonAccount>? personAccounts =
          await personService.getPersonAccounts(personId: personId);

      if (personAccounts?[0] != null) {
        emit(PersonAccountLoaded(personAccounts![0]));
      } else {
        emit(const PersonAccountError());
      }
    } catch (e) {
      emit(const PersonAccountError());
    }
  }
}
