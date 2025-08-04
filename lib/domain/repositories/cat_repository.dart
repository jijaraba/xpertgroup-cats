import '../entities/breed.dart';
import '../entities/cat_image.dart';

abstract class CatRepository {
  Future<List<Breed>> getBreeds();
  Future<List<CatImage>> getImagesByBreed(String breedId, {int limit = 10});
  Future<bool> voteForImage(String imageId, bool isPositive);
}