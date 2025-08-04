import '../entities/cat_image.dart';
import '../repositories/cat_repository.dart';

class GetImagesByBreed {
  final CatRepository repository;

  GetImagesByBreed(this.repository);

  Future<List<CatImage>> call(String breedId, {int limit = 10}) async {
    return await repository.getImagesByBreed(breedId, limit: limit);
  }
}