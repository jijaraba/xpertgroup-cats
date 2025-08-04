import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/breed_model.dart';
import '../models/cat_image_model.dart';

abstract class CatRemoteDataSource {
  Future<List<BreedModel>> getBreeds();
  Future<List<CatImageModel>> getImagesByBreed(String breedId, {int limit = 10});
  Future<bool> voteForImage(String imageId, bool isPositive);
}

class CatRemoteDataSourceImpl implements CatRemoteDataSource {
  final http.Client client;

  CatRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BreedModel>> getBreeds() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.breeds}'),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> breedsJson = json.decode(response.body);
      return breedsJson.map((json) => BreedModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  @override
  Future<List<CatImageModel>> getImagesByBreed(String breedId, {int limit = 10}) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.images}?limit=$limit&breed_ids=$breedId'),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> imagesJson = json.decode(response.body);
      return imagesJson.map((json) => CatImageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Future<bool> voteForImage(String imageId, bool isPositive) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.votes}'),
      headers: ApiConstants.headers,
      body: json.encode({
        'image_id': imageId,
        'value': isPositive ? 1 : 0,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}