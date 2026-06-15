import 'dart:convert';

import '../../domain/entities/cloth_item_entity.dart';

class ClothItemModel {
  final String id;
  final String photoPath;
  final DateTime createdAt;
  final String userId;
  final String wardrobeId;
  final String aiDescription;
  final List<String> aiStyleIds;
  final List<String> aiColorIds;

  const ClothItemModel({
    required this.id,
    required this.photoPath,
    required this.createdAt,
    required this.userId,
    required this.wardrobeId,
    required this.aiDescription,
    required this.aiStyleIds,
    required this.aiColorIds,
  });

  factory ClothItemModel.fromMap(Map<String, dynamic> map) {
    return ClothItemModel(
      id: map['id'] as String,
      photoPath: map['photoPath'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      userId: map['userId'] as String,
      wardrobeId: map['wardrobeId'] as String,
      aiDescription: map['aiDescription'] as String,

      aiStyleIds: _decodeStringList(map['aiStyleIds']),
      aiColorIds: _decodeStringList(map['aiColorIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoPath': photoPath,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'wardrobeId': wardrobeId,
      'aiDescription': aiDescription,

      'aiStyleIds': jsonEncode(aiStyleIds),
      'aiColorIds': jsonEncode(aiColorIds),
    };
  }

  factory ClothItemModel.fromEntity(ClothItemEntity entity) {
    return ClothItemModel(
      id: entity.id,
      photoPath: entity.photoPath,
      createdAt: entity.createdAt,
      userId: entity.userId,
      wardrobeId: entity.wardrobeId,
      aiDescription: entity.aiDescription,

      aiStyleIds: entity.aiStyleIds,
      aiColorIds: entity.aiColorIds,
    );
  }

  ClothItemEntity toEntity({required bool isImageAvailable}) {
    return ClothItemEntity(
      id: id,
      photoPath: photoPath,
      isImageAvailable: isImageAvailable,
      createdAt: createdAt,
      userId: userId,
      wardrobeId: wardrobeId,
      aiDescription: aiDescription,

      aiStyleIds: aiStyleIds,
      aiColorIds: aiColorIds,
    );
  }

  static List<String> _decodeStringList(dynamic value) {
    if (value == null) {
      return [];
    }

    final decoded = jsonDecode(value as String);

    if (decoded is! List) {
      return [];
    }

    return decoded.whereType<String>().toList();
  }
}
