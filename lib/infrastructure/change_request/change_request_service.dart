import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/transfer/transfer_confirmation.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class ChangeRequestService extends ApiService {
  ChangeRequestService({super.user});

  Future<ChangeRequestServiceResponse> confirmTransferChangeRequest({
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

      return ConfirmTransferChangeRequestSuccessResponse(
        transferConfirmation: TransferConfirmation(
          success: data['success'],
        ),
      );
    } catch (e) {
      return ChangeRequestServiceErrorResponse();
    }
  }
}

abstract class ChangeRequestServiceResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class ConfirmTransferChangeRequestSuccessResponse extends ChangeRequestServiceResponse {
  final TransferConfirmation transferConfirmation;

  ConfirmTransferChangeRequestSuccessResponse({
    required this.transferConfirmation,
  });

  @override
  List<Object> get props => [transferConfirmation];
}

class ChangeRequestServiceErrorResponse extends ChangeRequestServiceResponse {}
