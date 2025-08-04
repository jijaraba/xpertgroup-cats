import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cat_providers.dart';
import '../../domain/entities/breed.dart';

class VotingPage extends ConsumerWidget {
  const VotingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedsAsyncValue = ref.watch(votingBreedsProvider);
    final currentIndex = ref.watch(currentVotingIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votación de Razas'),
        backgroundColor: Colors.purple.shade100,
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
                onPressed: () => ref.refresh(votingBreedsProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (breeds) {
          if (breeds.isEmpty) {
            return const Center(
              child: Text('No hay razas disponibles para votar'),
            );
          }

          if (currentIndex >= breeds.length) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 64),
                  SizedBox(height: 16),
                  Text(
                    '¡Has votado por todas las razas!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Gracias por tu participación'),
                ],
              ),
            );
          }

          final currentBreed = breeds[currentIndex];
          return VotingCard(breed: currentBreed);
        },
      ),
    );
  }
}

class VotingCard extends ConsumerStatefulWidget {
  final Breed breed;

  const VotingCard({super.key, required this.breed});

  @override
  ConsumerState<VotingCard> createState() => _VotingCardState();
}

class _VotingCardState extends ConsumerState<VotingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isVoting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _vote(bool isPositive) async {
    if (_isVoting) return;

    setState(() {
      _isVoting = true;
    });

    try {
      // Animar la tarjeta hacia la izquierda
      await _animationController.forward();

      // Votar por la imagen (usamos el ID de la raza como imagen para este ejemplo)
      await ref.read(voteForImageProvider).call(widget.breed.id, isPositive);

      // Mostrar feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPositive ? '¡Te gusta ${widget.breed.name}!' : 'No te gusta ${widget.breed.name}',
            ),
            backgroundColor: isPositive ? Colors.green : Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // Avanzar al siguiente
      _nextBreed();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al votar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVoting = false;
        });
      }
    }
  }

  void _nextBreed() {
    final currentIndex = ref.read(currentVotingIndexProvider);
    ref.read(currentVotingIndexProvider.notifier).state = currentIndex + 1;
    
    // Reiniciar la animación para la siguiente tarjeta
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Prevenir deslizar hacia la derecha
        if (details.primaryVelocity! > 0) {
          return;
        }
        
        // Deslizar hacia la izquierda para siguiente
        if (details.primaryVelocity! < -500) {
          _nextBreed();
        }
      },
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen de la raza
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: widget.breed.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: widget.breed.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.pets, size: 64, color: Colors.grey.shade400),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.breed.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.pets, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.breed.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                
                // Información de la raza
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          widget.breed.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.breed.origin} • Inteligencia: ${widget.breed.intelligence}/5',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Botones de votación
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botón de dislike
                      GestureDetector(
                        onTap: _isVoting ? null : () => _vote(false),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _isVoting ? Colors.grey : Colors.red.shade100,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isVoting ? Colors.grey : Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.thumb_down,
                            color: _isVoting ? Colors.grey : Colors.red,
                            size: 32,
                          ),
                        ),
                      ),
                      
                      // Botón de like
                      GestureDetector(
                        onTap: _isVoting ? null : () => _vote(true),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _isVoting ? Colors.grey : Colors.green.shade100,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isVoting ? Colors.grey : Colors.green,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.thumb_up,
                            color: _isVoting ? Colors.grey : Colors.green,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Instrucciones
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Desliza hacia la izquierda para siguiente',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}