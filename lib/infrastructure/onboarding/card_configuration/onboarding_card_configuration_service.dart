import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/api_service.dart';

import '../../../models/user.dart';

class OnboardingCardConfigurationService extends ApiService {
  OnboardingCardConfigurationService({super.user});

  Future<OnboardingCardConfigurationResponse> getCardholderName({required User user}) async {
    this.user = user;
    try {
      final response = await get("/signup/card_line_2");
      return GetCardholderNameSuccessResponse(cardholderName: response["line_2"]);
    } catch (e) {
      return OnboardingCardConfigurationErrorResponse();
    }
  }
}

abstract class OnboardingCardConfigurationResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCardholderNameSuccessResponse extends OnboardingCardConfigurationResponse {
  final String cardholderName;

  GetCardholderNameSuccessResponse({required this.cardholderName});

  @override
  List<Object?> get props => [cardholderName];
}
class OnboardingCardConfigurationErrorResponse extends OnboardingCardConfigurationResponse {}