import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/cat_providers.dart';
import '../../domain/entities/breed.dart';

class BreedsPage extends ConsumerWidget {
  const BreedsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedsAsyncValue = ref.watch(breedsProvider);
    final selectedBreed = ref.watch(selectedBreedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Razas de Gatos'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: breedsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 64),
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.refresh(breedsProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (breeds) => Column(
          children: [
            // Dropdown para seleccionar raza
            Container(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<Breed>(
                value: selectedBreed,
                hint: const Text('Selecciona una raza'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Raza de Gato',
                ),
                items: breeds.map((breed) => DropdownMenuItem(
                  value: breed,
                  child: Text(breed.name),
                )).toList(),
                onChanged: (breed) {
                  ref.read(selectedBreedProvider.notifier).state = breed;
                },
              ),
            ),
            // Contenido dinámico basado en la raza seleccionada
            Expanded(
              child: selectedBreed != null
                  ? BreedDetailsWidget(breed: selectedBreed)
                  : const Center(
                      child: Text(
                        'Selecciona una raza para ver sus detalles',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreedDetailsWidget extends ConsumerWidget {
  final Breed breed;

  const BreedDetailsWidget({super.key, required this.breed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagesAsyncValue = ref.watch(breedImagesProvider(breed.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título con información básica
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip('Origen: ${breed.origin}', Icons.location_on),
                      const SizedBox(width: 8),
                      _buildInfoChip('Expectativa de vida: ${breed.lifeSpan} años', Icons.favorite),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoChip('Inteligencia: ${breed.intelligence}/5', Icons.psychology),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Carrusel de imágenes
          imagesAsyncValue.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Error al cargar imágenes'),
              ),
            ),
            data: (images) => images.isNotEmpty
                ? CarouselSlider.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index, realIndex) {
                      final image = images[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: image.url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 250,
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                  )
                : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('No hay imágenes disponibles'),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          
          // Descripción
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    breed.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón de Wikipedia
                  if (breed.wikipediaUrl != null && breed.wikipediaUrl!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openWikipedia(context, breed.wikipediaUrl!),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Leer más en Wikipedia'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.blue.shade50,
    );
  }

  void _openWikipedia(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WikipediaWebView(url: url),
      ),
    );
  }
}

class WikipediaWebView extends StatefulWidget {
  final String url;

  const WikipediaWebView({super.key, required this.url});

  @override
  State<WikipediaWebView> createState() => _WikipediaWebViewState();
}

class _WikipediaWebViewState extends State<WikipediaWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}