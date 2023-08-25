import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class ChangeRequestService extends ApiService {
  ChangeRequestService({super.user});

  Future<ChangeRequestServiceResponse> confirmChangeRequest({
    User? user,
    required String changeRequestId,
    required String tan,
  }) async {
    try {
      String path = 'change_requests/$changeRequestId/confirm';

      final data = await post(
        path,
        body: {"tan": tan},
      );

      print(data);

      return ChangeRequestConfirmSuccessResponse();
    } catch (e) {
      return ChangeRequestConfirmErrorResponse();
    }
  }
}

abstract class ChangeRequestServiceResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeRequestConfirmSuccessResponse extends ChangeRequestServiceResponse {}

class ChangeRequestConfirmErrorResponse extends ChangeRequestServiceResponse {}
