import '../entities/breed.dart';
import '../repositories/cat_repository.dart';

class GetBreeds {
  final CatRepository repository;

  GetBreeds(this.repository);

  Future<List<Breed>> call() async {
    return await repository.getBreeds();
  }
}