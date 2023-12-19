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

  Future<OnboardingCardConfigurationResponse> onboardingCreateCard({required User user}) async {
    this.user = user;
    try {
      await post("/account/cards");
      return OnboardingCardConfigurationSuccessResponse();
    } catch (e) {
      return OnboardingCardConfigurationErrorResponse();
    }
  }

  Future<OnboardingCardConfigurationResponse> onboardingGetCardInfo({required User user}) async {
    this.user = user;
    try {
      final response = await get("/account/cards");
      final cardData = (response as List).first["representation"];
      return GetCardInfoSuccessResponse(
        cardholderName: cardData["line_1"] ?? "",
        maskedPAN: cardData["masked_pan"] ?? "",
        expiryDate: cardData["formatted_expiration_date"] ?? "",
      );
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

class GetCardInfoSuccessResponse extends OnboardingCardConfigurationResponse {
  final String cardholderName;
  final String maskedPAN;
  final String expiryDate;

  GetCardInfoSuccessResponse({
    required this.cardholderName,
    required this.maskedPAN,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [cardholderName, maskedPAN, expiryDate];
}

class OnboardingCardConfigurationSuccessResponse extends OnboardingCardConfigurationResponse {}

class OnboardingCardConfigurationErrorResponse extends OnboardingCardConfigurationResponse {}
