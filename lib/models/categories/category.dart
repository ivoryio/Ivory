import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  IconData get icon {
    switch (id) {
      case "transportationAndTravel":
        return Icons.local_taxi_outlined;
      case "foodAndDining":
        return Icons.fastfood_outlined;
      case "retailAndShopping":
        return Icons.shopping_bag_outlined;
      case "fuelAndAuto":
        return Icons.local_gas_station_outlined;
      case "healthAndWellness":
        return Icons.health_and_safety_outlined;
      case "technologyAndOnlineServices":
        return Icons.devices_outlined;
      case "entertainmentAndRecreation":
        return Icons.live_tv_outlined;
      case "homeAndUtilities":
        return Icons.house_outlined;
      case "governmentAndTaxes":
        return Icons.receipt_long_outlined;
      case "educationAndServices":
        return Icons.school_outlined;
      case "financialServices":
        return Icons.account_balance_outlined;
      case "other":
        return Icons.local_offer_outlined;
      default:
        return Icons.local_offer_outlined;
    }
  }

  @override
  List<Object?> get props => [id, name];

  factory Category.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? "other";
    final name = json['name'] ?? "Other";

    return Category(
      id: id,
      name: name,
    );
  }
}
