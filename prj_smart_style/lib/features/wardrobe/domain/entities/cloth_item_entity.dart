class ClothItemEntity {
  final String id;
  final String photoPath;
  final bool isImageAvailable;
  final DateTime createdAt;
  final String userId;
  final String wardrobeId;
  final String aiDescription;
  final List<String> aiStyleIds;
  final List<String> aiColorIds;

  const ClothItemEntity({
    required this.id,
    required this.photoPath,
    required this.isImageAvailable,
    required this.createdAt,
    required this.userId,
    required this.wardrobeId,
    required this.aiDescription,
    required this.aiStyleIds,
    required this.aiColorIds,
  });
}
