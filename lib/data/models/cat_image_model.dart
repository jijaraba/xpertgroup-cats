import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cat_image.dart';

part 'cat_image_model.g.dart';

@JsonSerializable()
class CatImageModel extends CatImage {
  const CatImageModel({
    required super.id,
    required super.url,
    required super.width,
    required super.height,
    super.breedId,
  });

  factory CatImageModel.fromJson(Map<String, dynamic> json) {
    return CatImageModel(
      id: json['id'] as String,
      url: json['url'] as String,
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      breedId: json['breed_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$CatImageModelToJson(this);

  CatImage toEntity() => CatImage(
        id: id,
        url: url,
        width: width,
        height: height,
        breedId: breedId,
      );
}