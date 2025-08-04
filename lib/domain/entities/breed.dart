import 'package:equatable/equatable.dart';

class Breed extends Equatable {
  final String id;
  final String name;
  final String description;
  final String origin;
  final String lifeSpan;
  final int intelligence;
  final String? wikipediaUrl;
  final String? imageUrl;

  const Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.origin,
    required this.lifeSpan,
    required this.intelligence,
    this.wikipediaUrl,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        origin,
        lifeSpan,
        intelligence,
        wikipediaUrl,
        imageUrl,
      ];
}