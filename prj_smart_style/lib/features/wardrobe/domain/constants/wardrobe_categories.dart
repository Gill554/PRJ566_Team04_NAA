import '../entities/wardrobe_entity.dart';

class WardrobeCategories {
  static const tops = WardrobeEntity(id: 'wardrobe_001', categoryName: 'Tops');

  static const outerwear = WardrobeEntity(
    id: 'wardrobe_002',
    categoryName: 'Outerwear',
  );

  static const bottoms = WardrobeEntity(
    id: 'wardrobe_003',
    categoryName: 'Bottoms',
  );

  static const footwear = WardrobeEntity(
    id: 'wardrobe_004',
    categoryName: 'Footwear',
  );

  static const accessories = WardrobeEntity(
    id: 'wardrobe_005',
    categoryName: 'Accessories',
  );

  static const List<WardrobeEntity> all = [
    tops,
    outerwear,
    bottoms,
    footwear,
    accessories,
  ];
}
