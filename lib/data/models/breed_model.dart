import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/breed.dart';

part 'breed_model.g.dart';

@JsonSerializable()
class BreedModel extends Breed {
  const BreedModel({
    required super.id,
    required super.name,
    required super.description,
    required super.origin,
    required super.lifeSpan,
    required super.intelligence,
    super.wikipediaUrl,
    super.imageUrl,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      lifeSpan: json['life_span'] as String? ?? '',
      intelligence: json['intelligence'] as int? ?? 0,
      wikipediaUrl: json['wikipedia_url'] as String?,
      imageUrl: json['image']?['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$BreedModelToJson(this);

  Breed toEntity() => Breed(
        id: id,
        name: name,
        description: description,
        origin: origin,
        lifeSpan: lifeSpan,
        intelligence: intelligence,
        wikipediaUrl: wikipediaUrl,
        imageUrl: imageUrl,
      );
}