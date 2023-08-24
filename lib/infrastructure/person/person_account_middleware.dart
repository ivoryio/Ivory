import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/redux/app_state.dart';

class PersonAccountMiddleware extends MiddlewareClass<AppState> {
  final PersonService _personService;

  PersonAccountMiddleware(this._personService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
  }
}
