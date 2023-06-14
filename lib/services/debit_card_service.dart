import 'dart:developer';

import 'package:solarisdemo/models/debit_card.dart';
import 'package:solarisdemo/services/api_service.dart';

class DebitCardsService extends ApiService {
  DebitCardsService({required super.user});

  Future<List<DebitCard>?> getDebitCards({
    DebitCardsListFilter? filter,
  }) async {
    try {
      var data =
          await get('/account/cards', queryParameters: filter?.toMap() ?? {});

      List<DebitCard>? cards =
          (data as List).map((card) => DebitCard.fromJson(card)).toList();

      return cards;
    } catch (e) {
      throw Exception("Failed to load cards");
    }
  }

  Future<DebitCard?> getDebitCardById(String id) async {
    try {
      var data = await get('/account/cards/$id');
      DebitCard card = DebitCard.fromJson(data);
      return card;
    } catch (e) {
      throw Exception("Failed to load card by id");
    }
  }

  Future<dynamic> createVirtualDebitCard(CreateDebitCard debitCard) async {
    try {
      String path = '/account/cards';

      var data = await post(path, body: debitCard.toJson());
      return data;
    } catch (e) {
      throw Exception("Failed to create debit card");
    }
  }

  Future<DebitCard> freezeDebitCard(String cardId) async {
    try {
      String path = 'account/cards/$cardId/block';
      var data = await post(path);
      DebitCard card = DebitCard.fromJson(data);
      inspect(card);
      return card;
    } catch (e) {
      throw Exception("Failed to freeze card");
    }
  }

  Future<DebitCard> unfreezeDebitCard(String cardId) async {
    try {
      String path = 'account/cards/$cardId/unblock';
      var data = await post(path);
      DebitCard card = DebitCard.fromJson(data);
      inspect(card);

      return card;
    } catch (e) {
      throw Exception("Failed to unfreeze card");
    }
  }
}

class DebitCardsListFilter {
  final int? page;
  final int? size;

  DebitCardsListFilter({
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
