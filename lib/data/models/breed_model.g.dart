// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreedModel _$BreedModelFromJson(Map<String, dynamic> json) => BreedModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  origin: json['origin'] as String,
  lifeSpan: json['lifeSpan'] as String,
  intelligence: (json['intelligence'] as num).toInt(),
  wikipediaUrl: json['wikipediaUrl'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$BreedModelToJson(BreedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'origin': instance.origin,
      'lifeSpan': instance.lifeSpan,
      'intelligence': instance.intelligence,
      'wikipediaUrl': instance.wikipediaUrl,
      'imageUrl': instance.imageUrl,
    };
