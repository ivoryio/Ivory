import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/services/api_service.dart';

class BankCardsService extends ApiService {
  BankCardsService({required super.user});

  Future<List<BankCard>?> getCards({
    BankCardsListFilter? filter,
  }) async {
    try {
      var data =
          await get('/account/cards', queryParameters: filter?.toMap() ?? {});

      List<BankCard>? cards =
          (data as List).map((card) => BankCard.fromJson(card)).toList();

      return cards;
    } catch (e) {
      throw Exception("Failed to load cards");
    }
  }

  Future<BankCard?> getBankCardById(String id) async {
    try {
      var data = await get('/account/cards/$id');
      BankCard card = BankCard.fromJson(data);
      return card;
    } catch (e) {
      throw Exception("Failed to load card by id");
    }
  }

  Future<dynamic> createCard(CreateBankCard card) async {
    try {
      String path = '/account/cards';

      var data = await post(path, body: card.toJson());
      return data;
    } catch (e) {
      throw Exception("Failed to create card");
    }
  }

  Future<dynamic> activateCard(String id) async {
    String path = '/account/cards/$id';

    try {
      var data = await post(path, body: {id: id});
      return data;
    } catch (e) {
      throw Exception("Failed to activate card");
    }
  }

  Future<BankCard> freezeBankCard(String cardId) async {
    try {
      String path = 'account/cards/$cardId/block';
      var data = await post(path);
      BankCard card = BankCard.fromJson(data);
      return card;
    } catch (e) {
      throw Exception("Failed to freeze card");
    }
  }

  Future<BankCard> unfreezeCard(String cardId) async {
    try {
      String path = 'account/cards/$cardId/unblock';
      var data = await post(path);
      BankCard card = BankCard.fromJson(data);

      return card;
    } catch (e) {
      throw Exception("Failed to unfreeze card");
    }
  }

  Future<GetCardDetailsResponse> getCardDetails({
    required String cardId,
    required GetCardDetailsRequestBody requestBody,
  }) async {
    try {
      String path = '/account/cards/$cardId/details';
      var data = await post(
        path,
        body: requestBody.toJson(),
      );
      return data;
    } catch (e) {
      throw Exception("Failed to get card details");
    }
  }
}

class BankCardsListFilter {
  final int? page;
  final int? size;

  BankCardsListFilter({
    this.page,
    this.size,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {};

    if (page != null) {
      map["page[number]"] = page.toString();
    }

    if (size != null) {
      map["page[size]"] = size.toString();
    }

    return map;
  }
}
