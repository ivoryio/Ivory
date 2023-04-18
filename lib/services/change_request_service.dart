import '../models/change_request.dart';
import 'api_service.dart';

class ChangeRequestService extends ApiService {
  ChangeRequestService({required super.user});

  Future<ChangeRequestConfirmed> confirmChangeRequest(
      String changeRequestId, String tan) async {
    try {
      String path = 'change_requests/$changeRequestId/confirm';

      var data = await post(
        path,
        body: ChangeRequestConfirm(tan: tan).toJson(),
      );

      return ChangeRequestConfirmed.fromJson(data);
    } catch (e) {
      throw Exception("Failed to confirm change request");
    }
  }

  Future<ChangeRequestToken> getChangeRequestToken(
      String changeRequestId) async {
    try {
      String path = 'change_requests/$changeRequestId/token';

      var data = await get(path);

      return ChangeRequestToken.fromJson(data);
    } catch (e) {
      throw Exception("Failed to get change request token");
    }
  }
}
