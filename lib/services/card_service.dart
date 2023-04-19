


import 'package:solarisdemo/services/api_service.dart';

class CardService extends ApiService {
  CardService({required super.user});

  Future<List<Card>?> getCards() async {
    try {
      var data = await get('/cards');

      List<Card>? cards = (data as List)
          .map((card) => Card.fromJson(card))
          .toList();

      return cards;
    } catch (e) {
      throw Exception("Failed to load cards");
    }
  }
}