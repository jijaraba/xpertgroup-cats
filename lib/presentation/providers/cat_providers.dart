import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/cat_remote_data_source.dart';
import '../../data/repositories/cat_repository_impl.dart';
import '../../domain/entities/breed.dart';
import '../../domain/entities/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';
import '../../domain/usecases/get_breeds.dart';
import '../../domain/usecases/get_images_by_breed.dart';
import '../../domain/usecases/vote_for_image.dart';

// HTTP Client Provider
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Data Source Provider
final catRemoteDataSourceProvider = Provider<CatRemoteDataSource>((ref) {
  return CatRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

// Repository Provider
final catRepositoryProvider = Provider<CatRepository>((ref) {
  return CatRepositoryImpl(remoteDataSource: ref.read(catRemoteDataSourceProvider));
});

// Use Cases Providers
final getBreedsProvider = Provider<GetBreeds>((ref) {
  return GetBreeds(ref.read(catRepositoryProvider));
});

final getImagesByBreedProvider = Provider<GetImagesByBreed>((ref) {
  return GetImagesByBreed(ref.read(catRepositoryProvider));
});

final voteForImageProvider = Provider<VoteForImage>((ref) {
  return VoteForImage(ref.read(catRepositoryProvider));
});

// State Providers
final breedsProvider = StateNotifierProvider<BreedsNotifier, AsyncValue<List<Breed>>>((ref) {
  return BreedsNotifier(ref.read(getBreedsProvider));
});

final selectedBreedProvider = StateProvider<Breed?>((ref) => null);

final breedImagesProvider = StateNotifierProvider.family<BreedImagesNotifier, AsyncValue<List<CatImage>>, String>(
  (ref, breedId) {
    return BreedImagesNotifier(ref.read(getImagesByBreedProvider), breedId);
  },
);

// Voting State Provider
final votingBreedsProvider = StateNotifierProvider<VotingBreedsNotifier, AsyncValue<List<Breed>>>((ref) {
  return VotingBreedsNotifier(ref.read(getBreedsProvider));
});

final currentVotingIndexProvider = StateProvider<int>((ref) => 0);

// Notifiers
class BreedsNotifier extends StateNotifier<AsyncValue<List<Breed>>> {
  final GetBreeds _getBreeds;

  BreedsNotifier(this._getBreeds) : super(const AsyncValue.loading()) {
    loadBreeds();
  }

  Future<void> loadBreeds() async {
    try {
      state = const AsyncValue.loading();
      final breeds = await _getBreeds();
      state = AsyncValue.data(breeds);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class BreedImagesNotifier extends StateNotifier<AsyncValue<List<CatImage>>> {
  final GetImagesByBreed _getImagesByBreed;
  final String breedId;

  BreedImagesNotifier(this._getImagesByBreed, this.breedId) : super(const AsyncValue.loading()) {
    loadImages();
  }

  Future<void> loadImages() async {
    try {
      state = const AsyncValue.loading();
      final images = await _getImagesByBreed(breedId);
      state = AsyncValue.data(images);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class VotingBreedsNotifier extends StateNotifier<AsyncValue<List<Breed>>> {
  final GetBreeds _getBreeds;

  VotingBreedsNotifier(this._getBreeds) : super(const AsyncValue.loading()) {
    loadBreeds();
  }

  Future<void> loadBreeds() async {
    try {
      state = const AsyncValue.loading();
      final breeds = await _getBreeds();
      // Shuffle breeds for voting
      final shuffledBreeds = [...breeds]..shuffle();
      state = AsyncValue.data(shuffledBreeds);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}