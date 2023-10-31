class AddressSuggestion {
  String address;
  String city;
  String country;

  AddressSuggestion({
    required this.address,
    required this.city,
    required this.country,
  });

  factory AddressSuggestion.fromJson(Map<String, dynamic> json) {
    return AddressSuggestion(
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }
}
