// import '../../domain/constants/wardrobe_categories.dart';
// import '../../domain/entities/cloth_item_entity.dart';
// import '../../domain/entities/wardrobe_entity.dart';
// import '../../domain/repositories/wardrobe_repository.dart';

// class MockWardrobeRepository implements WardrobeRepository {
//   final List<ClothItemEntity> _items = [
//     ClothItemEntity(
//       id: 'cloth_001',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.upperBody.id,
//       photoPath: 'mock_work_upper_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 1, 10),
//       aiDescription: 'Black blazer',
//       aiStyleId: 'style_002',
//       aiColorId: 'color_002',
//     ),
//     ClothItemEntity(
//       id: 'cloth_002',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.upperBody.id,
//       photoPath: 'mock_work_upper_002.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 1, 12),
//       aiDescription: 'Navy button-up shirt',
//       aiStyleId: 'style_002',
//       aiColorId: 'color_002',
//     ),
//     ClothItemEntity(
//       id: 'cloth_003',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.lowerBody.id,
//       photoPath: 'mock_work_lower_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 1, 15),
//       aiDescription: 'Dark formal pants',
//       aiStyleId: 'style_002',
//       aiColorId: 'color_002',
//     ),
//     ClothItemEntity(
//       id: 'cloth_004',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.lowerBody.id,
//       photoPath: 'mock_work_lower_002.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 1, 16),
//       aiDescription: 'Charcoal office trousers',
//       aiStyleId: 'style_002',
//       aiColorId: 'color_002',
//     ),
//     ClothItemEntity(
//       id: 'cloth_005',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.footwear.id,
//       photoPath: 'mock_work_footwear_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 1, 18),
//       aiDescription: 'Black dress shoes',
//       aiStyleId: 'style_002',
//       aiColorId: 'color_002',
//     ),
//     ClothItemEntity(
//       id: 'cloth_006',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.footwear.id,
//       photoPath: 'mock_work_footwear_002.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 1, 19),
//       aiDescription: 'Dark brown loafers',
//       aiStyleId: 'style_002',
//       aiColorId: 'color_002',
//     ),
//     ClothItemEntity(
//       id: 'cloth_007',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.accessories.id,
//       photoPath: 'mock_work_accessory_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 1, 20),
//       aiDescription: 'Black leather belt',
//       aiStyleId: 'style_002',
//       aiColorId: 'color_002',
//     ),

//     ClothItemEntity(
//       id: 'cloth_008',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.upperBody.id,
//       photoPath: 'mock_formal_upper_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 2, 1),
//       aiDescription: 'White formal dress shirt',
//       aiStyleId: 'style_003',
//       aiColorId: 'color_003',
//     ),
//     ClothItemEntity(
//       id: 'cloth_009',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.upperBody.id,
//       photoPath: 'mock_formal_upper_002.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 2, 2),
//       aiDescription: 'Light gray suit jacket',
//       aiStyleId: 'style_003',
//       aiColorId: 'color_003',
//     ),
//     ClothItemEntity(
//       id: 'cloth_010',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.lowerBody.id,
//       photoPath: 'mock_formal_lower_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 2, 3),
//       aiDescription: 'Black tailored trousers',
//       aiStyleId: 'style_003',
//       aiColorId: 'color_003',
//     ),
//     ClothItemEntity(
//       id: 'cloth_011',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.lowerBody.id,
//       photoPath: 'mock_formal_lower_002.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 2, 4),
//       aiDescription: 'Gray formal pants',
//       aiStyleId: 'style_003',
//       aiColorId: 'color_003',
//     ),
//     ClothItemEntity(
//       id: 'cloth_012',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.footwear.id,
//       photoPath: 'mock_formal_footwear_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 2, 5),
//       aiDescription: 'Polished black oxford shoes',
//       aiStyleId: 'style_003',
//       aiColorId: 'color_003',
//     ),
//     ClothItemEntity(
//       id: 'cloth_013',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.footwear.id,
//       photoPath: 'mock_formal_footwear_002.jpg',
//       isImageAvailable: false,
//       createdAt: DateTime(2026, 2, 6),
//       aiDescription: 'Classic gray dress shoes',
//       aiStyleId: 'style_003',
//       aiColorId: 'color_003',
//     ),
//     ClothItemEntity(
//       id: 'cloth_014',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.accessories.id,
//       photoPath: 'mock_formal_accessory_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 2, 7),
//       aiDescription: 'Neutral silk tie',
//       aiStyleId: 'style_003',
//       aiColorId: 'color_003',
//     ),

//     ClothItemEntity(
//       id: 'cloth_015',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.upperBody.id,
//       photoPath: 'mock_casual_upper_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 3, 1),
//       aiDescription: 'Blue casual hoodie',
//       aiStyleId: 'style_001',
//       aiColorId: 'color_001',
//     ),
//     ClothItemEntity(
//       id: 'cloth_016',
//       userId: 'user_001',
//       wardrobeId: WardrobeCategories.lowerBody.id,
//       photoPath: 'mock_casual_lower_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 3, 2),
//       aiDescription: 'Light denim jeans',
//       aiStyleId: 'style_001',
//       aiColorId: 'color_004',
//     ),

//     ClothItemEntity(
//       id: 'cloth_017',
//       userId: 'user_002',
//       wardrobeId: WardrobeCategories.upperBody.id,
//       photoPath: 'mock_user2_upper_001.jpg',
//       isImageAvailable: true,
//       createdAt: DateTime(2026, 2, 2),
//       aiDescription: 'Blue casual hoodie',
//       aiStyleId: 'style_001',
//       aiColorId: 'color_001',
//     ),
//   ];

//   @override
//   Future<List<WardrobeEntity>> getWardrobeCategories() async {
//     await Future.delayed(const Duration(milliseconds: 500));

//     return WardrobeCategories.all;
//   }

//   @override
//   Future<List<ClothItemEntity>> getClothingItemsByCategory({
//     required String userId,
//     required String wardrobeId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));

//     return _items.where((item) {
//       return item.userId == userId && item.wardrobeId == wardrobeId;
//     }).toList();
//   }

//   @override
//   Future<List<ClothItemEntity>> getAllClothingItems({
//     required String userId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));

//     return _items.where((item) {
//       return item.userId == userId;
//     }).toList();
//   }

//   @override
//   Future<ClothItemEntity> addClothingItem({
//     required ClothItemEntity clothItem,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 600));

//     _items.add(clothItem);

//     return clothItem;
//   }

//   @override
//   Future<void> deleteClothingItem({
//     required String userId,
//     required String clothItemId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 400));

//     _items.removeWhere((item) {
//       return item.userId == userId && item.id == clothItemId;
//     });
//   }
// }
