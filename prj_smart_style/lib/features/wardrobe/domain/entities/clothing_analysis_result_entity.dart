class ClothingAnalysisResultEntity {
  final bool isValid;
  final String? errorMessage;
  final String? wardrobeId;
  final List<String>? styleIds;
  final List<String>? colorIds;
  final String? description;

  const ClothingAnalysisResultEntity({
    required this.isValid,
    this.errorMessage,
    this.wardrobeId,
    this.styleIds,
    this.colorIds,
    this.description,
  });
}
