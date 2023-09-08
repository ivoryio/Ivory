import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/user.dart';

class GetPersonAccountCommandAction {
  final User user;

  GetPersonAccountCommandAction({required this.user});
}

class PersonAccountLoadingEventAction {}

class PersonAccountFetchedEventAction {
  final PersonAccount personAccount;

  PersonAccountFetchedEventAction(this.personAccount);
}

class GetPersonAccountFailedEventAction {}
