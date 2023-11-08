import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/mobile_number/mobile_number.dart';
import 'package:solarisdemo/models/mobile_number/mobile_number_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class MobileNumberService extends ApiService {
  MobileNumberService({super.user});

  Future<MobileNumberServiceResponse> createMobileNumber({
    required CreateVerifyMobileNumberRequestBody reqBody,
    required User user,
  }) async {
    this.user = user;

    try {
      String path = 'person/create_mobile_number';

      await post(
        path,
        body: reqBody.toJson(),
      );
      return CreateMobileNumberSuccessResponse();
    } catch (e) {
      return MobileNumberServiceErrorResponse(errorType: MobileNumberErrorType.cantCreateMobileNumber);
    }
  }

  Future<MobileNumberServiceResponse> confirmMobileNumber({
    required ConfirmMobileNumberRequestBody reqBody,
    required User user,
  }) async {
    this.user = user;

    try {
      String path = 'person/confirm_mobile_number';

      await post(
        path,
        body: reqBody.toJson(),
      );
      return ConfirmMobileNumberSuccessResponse();
    } catch (e) {
      return MobileNumberServiceErrorResponse(errorType: MobileNumberErrorType.cantConfirmMobileNumber);
    }
  }

  Future<MobileNumberServiceResponse> verifyMobileNumber({
    required CreateVerifyMobileNumberRequestBody reqBody,
    required User user,
  }) async {
    this.user = user;

    try {
      String path = 'person/verify_mobile_number';

      await post(
        path,
        body: reqBody.toJson(),
      );
      return VerifyMobileNumberSuccessResponse();
    } catch (e) {
      return MobileNumberServiceErrorResponse(errorType: MobileNumberErrorType.cantVerifyMobileNumber);
    }
  }
}

abstract class MobileNumberServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateMobileNumberSuccessResponse extends MobileNumberServiceResponse {
  CreateMobileNumberSuccessResponse();
}

class ConfirmMobileNumberSuccessResponse extends MobileNumberServiceResponse {
  ConfirmMobileNumberSuccessResponse();
}

class VerifyMobileNumberSuccessResponse extends MobileNumberServiceResponse {
  VerifyMobileNumberSuccessResponse();
}

class MobileNumberServiceErrorResponse extends MobileNumberServiceResponse {
  final MobileNumberErrorType errorType;

  MobileNumberServiceErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
