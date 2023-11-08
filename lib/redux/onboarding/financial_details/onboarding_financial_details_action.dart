import 'package:solarisdemo/models/onboarding/onboarding_financial_details_error_type.dart';

class CreateTaxIdCommandAction {
  final String taxId;

  CreateTaxIdCommandAction({required this.taxId});
}

class CreateTaxIdLoadingEventAction {}

class CreateTaxIdSuccessEventAction {
  final String taxId;

  CreateTaxIdSuccessEventAction({required this.taxId});
}

class CreateTaxIdFailedEventAction {
  final FinancialDetailsErrorType errorType;

  CreateTaxIdFailedEventAction({required this.errorType});
}
