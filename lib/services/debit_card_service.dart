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
