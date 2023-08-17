import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}