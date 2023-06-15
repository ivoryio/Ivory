import 'api_service.dart';

class BackOfficeServices extends ApiService {
  BackOfficeServices({required super.user});

  Future<void> processQueuedBooking(String personId) async {
    try {
      await post('/transactions/processQueuedBooking');

      return;
    } catch (e) {
      throw Exception("Failed to add transaction");
    }
  }
}
