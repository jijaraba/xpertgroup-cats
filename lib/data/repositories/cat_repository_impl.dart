import '../../domain/entities/breed.dart';
import '../../domain/entities/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_remote_data_source.dart';

class CatRepositoryImpl implements CatRepository {
  final CatRemoteDataSource remoteDataSource;

  CatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Breed>> getBreeds() async {
    final breedModels = await remoteDataSource.getBreeds();
    return breedModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CatImage>> getImagesByBreed(String breedId, {int limit = 10}) async {
    final imageModels = await remoteDataSource.getImagesByBreed(breedId, limit: limit);
    return imageModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> voteForImage(String imageId, bool isPositive) async {
    return await remoteDataSource.voteForImage(imageId, isPositive);
  }
}