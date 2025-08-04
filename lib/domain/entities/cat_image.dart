import 'package:equatable/equatable.dart';

class CatImage extends Equatable {
  final String id;
  final String url;
  final int width;
  final int height;
  final String? breedId;

  const CatImage({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    this.breedId,
  });

  @override
  List<Object?> get props => [id, url, width, height, breedId];
}