import 'package:equatable/equatable.dart';

class AddressSuggestion extends Equatable {
  final String address;
  final String city;
  final String country;

  const AddressSuggestion({
    required this.address,
    required this.city,
    required this.country,
  });

  @override
  List<Object?> get props => [address, city, country];
}
