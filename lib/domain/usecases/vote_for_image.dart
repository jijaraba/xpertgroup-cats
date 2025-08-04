import '../repositories/cat_repository.dart';

class VoteForImage {
  final CatRepository repository;

  VoteForImage(this.repository);

  Future<bool> call(String imageId, bool isPositive) async {
    return await repository.voteForImage(imageId, isPositive);
  }
}