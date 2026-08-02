import 'dart:convert';
import 'dart:io';
import '../../../outfit/domain/entities/outfit_details_entity.dart';
import '../../../outfit/domain/entities/outfit_image_entity.dart';
import '../../../outfit/domain/entities/outfit_output_entity.dart';
import '../../../preferences/domain/constants/preference_colors.dart';
import '../../../preferences/domain/constants/preference_styles.dart';
import '../../../preferences/domain/entities/user_profile_preferences_entity.dart';
import '../../../wardrobe/data/models/cloth_item_model.dart';
import '../../domain/entities/favorite_outfit_entity.dart';

class FavoriteOutfitModel {
  final String id;
  final String userId;
  final DateTime createdAt;

  final String detailsId;
  final String occasion;
  final String weather;

  final String preferenceProfileId;
  final String preferenceProfileName;
  final String preferenceProfileDescription;
  final String preferenceStyleId;
  final String preferenceColorId;

  final String outfitId;
  final DateTime outfitDate;
  final String outfitTitle;
  final String outfitDescription;
  final String outfitInputId;

  final String? outfitImageId;
  final String? outfitImagePath;

  final String selectedClothingItemsJson;

  const FavoriteOutfitModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.detailsId,
    required this.occasion,
    required this.weather,
    required this.preferenceProfileId,
    required this.preferenceProfileName,
    required this.preferenceProfileDescription,
    required this.preferenceStyleId,
    required this.preferenceColorId,
    required this.outfitId,
    required this.outfitDate,
    required this.outfitTitle,
    required this.outfitDescription,
    required this.outfitInputId,
    required this.outfitImageId,
    required this.outfitImagePath,
    required this.selectedClothingItemsJson,
  });

  factory FavoriteOutfitModel.fromMap(Map<String, dynamic> map) {
    return FavoriteOutfitModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      detailsId: map['detailsId'] as String,
      occasion: map['occasion'] as String,
      weather: map['weather'] as String,
      preferenceProfileId: map['preferenceProfileId'] as String,
      preferenceProfileName: map['preferenceProfileName'] as String,
      preferenceProfileDescription:
          map['preferenceProfileDescription'] as String,
      preferenceStyleId: map['preferenceStyleId'] as String,
      preferenceColorId: map['preferenceColorId'] as String,
      outfitId: map['outfitId'] as String,
      outfitDate: DateTime.parse(map['outfitDate'] as String),
      outfitTitle: map['outfitTitle'] as String,
      outfitDescription: map['outfitDescription'] as String,
      outfitInputId: map['outfitInputId'] as String,
      outfitImageId: map['outfitImageId'] as String?,
      outfitImagePath: map['outfitImagePath'] as String?,
      selectedClothingItemsJson: map['selectedClothingItemsJson'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'detailsId': detailsId,
      'occasion': occasion,
      'weather': weather,
      'preferenceProfileId': preferenceProfileId,
      'preferenceProfileName': preferenceProfileName,
      'preferenceProfileDescription': preferenceProfileDescription,
      'preferenceStyleId': preferenceStyleId,
      'preferenceColorId': preferenceColorId,
      'outfitId': outfitId,
      'outfitDate': outfitDate.toIso8601String(),
      'outfitTitle': outfitTitle,
      'outfitDescription': outfitDescription,
      'outfitInputId': outfitInputId,
      'outfitImageId': outfitImageId,
      'outfitImagePath': outfitImagePath,
      'selectedClothingItemsJson': selectedClothingItemsJson,
    };
  }

  factory FavoriteOutfitModel.fromEntity(FavoriteOutfitEntity entity) {
    final selectedClothingItemsJson = jsonEncode(
      entity.outfit.selectedClothingItems.map((item) {
        return ClothItemModel.fromEntity(item).toMap();
      }).toList(),
    );

    return FavoriteOutfitModel(
      id: entity.id,
      userId: entity.userId,
      createdAt: entity.createdAt,
      detailsId: entity.details.id,
      occasion: entity.details.occasion,
      weather: entity.details.weather,
      preferenceProfileId: entity.details.userProfilePreferences.id,
      preferenceProfileName: entity.details.userProfilePreferences.profileName,
      preferenceProfileDescription:
          entity.details.userProfilePreferences.description,
      preferenceStyleId:
          entity.details.userProfilePreferences.preferencesStyle.id,
      preferenceColorId:
          entity.details.userProfilePreferences.preferencesColor.id,
      outfitId: entity.outfit.id,
      outfitDate: entity.outfit.date,
      outfitTitle: entity.outfit.title,
      outfitDescription: entity.outfit.description,
      outfitInputId: entity.outfit.outfitInputId,
      outfitImageId: entity.outfit.outfitImage?.id,
      outfitImagePath: entity.outfit.outfitImage?.photoAddress,
      selectedClothingItemsJson: selectedClothingItemsJson,
    );
  }

  FavoriteOutfitEntity toEntity() {
    final decodedItems = jsonDecode(selectedClothingItemsJson) as List;

    final selectedClothingItems = decodedItems.map((item) {
      final model = ClothItemModel.fromMap(
        Map<String, dynamic>.from(item as Map),
      );

      return model.toEntity(isImageAvailable: true);
    }).toList();

    final preferencesStyle = PreferenceStyles.all.firstWhere(
      (style) => style.id == preferenceStyleId,
    );

    final preferencesColor = PreferenceColors.all.firstWhere(
      (color) => color.id == preferenceColorId,
    );

    final preferenceProfile = UserProfilePreferencesEntity(
      id: preferenceProfileId,
      profileName: preferenceProfileName,
      description: preferenceProfileDescription,
      userId: userId,
      preferencesStyle: preferencesStyle,
      preferencesColor: preferencesColor,
    );

    final details = OutfitDetailsEntity(
      id: detailsId,
      userProfilePreferences: preferenceProfile,
      occasion: occasion,
      weather: weather,
    );

    final isOutfitImageAvailable = outfitImagePath != null
        ? File(outfitImagePath!).existsSync()
        : false;

    final outfitImage = outfitImageId != null && outfitImagePath != null
        ? OutfitImageEntity(
            id: outfitImageId!,
            photoAddress: outfitImagePath!,
            isImageAvailable: isOutfitImageAvailable,
          )
        : null;

    final outfit = OutfitOutputEntity(
      id: outfitId,
      date: outfitDate,
      title: outfitTitle,
      description: outfitDescription,
      selectedClothingItems: selectedClothingItems,
      outfitImage: outfitImage,
      outfitInputId: outfitInputId,
    );

    return FavoriteOutfitEntity(
      id: id,
      userId: userId,
      createdAt: createdAt,
      details: details,
      outfit: outfit,
    );
  }
}
