enum Currency { euro }

extension CurrencyExtension on Currency {
  String get name {
    switch (this) {
      case Currency.euro:
        return 'EUR';
      default:
        return 'EUR';
    }
  }

  String get symbol {
    switch (this) {
      case Currency.euro:
        return '€';
      default:
        return '€';
    }
  }

  static Currency fromString(String currency) {
    switch (currency) {
      case 'EUR':
        return Currency.euro;
      default:
        return Currency.euro;
    }
  }
}
