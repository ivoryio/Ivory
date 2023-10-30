import 'package:solarisdemo/models/person_account.dart';

class GetPersonAccountCommandAction {}

class PersonAccountLoadingEventAction {}

class PersonAccountFetchedEventAction {
  final PersonAccount personAccount;

  PersonAccountFetchedEventAction(this.personAccount);
}

class GetPersonAccountFailedEventAction {}
