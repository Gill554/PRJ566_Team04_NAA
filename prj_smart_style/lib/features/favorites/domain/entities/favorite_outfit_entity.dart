import '../../../outfit/domain/entities/outfit_details_entity.dart';
import '../../../outfit/domain/entities/outfit_output_entity.dart';

class FavoriteOutfitEntity {
  final String id;
  final String userId;
  final DateTime createdAt;

  final OutfitDetailsEntity details;

  final OutfitOutputEntity outfit;

  const FavoriteOutfitEntity({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.details,
    required this.outfit,
  });
}
