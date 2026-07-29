import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../features/wardrobe/domain/constants/wardrobe_categories.dart';
import '../../../../features/wardrobe/domain/entities/cloth_item_entity.dart';
import '../../domain/repositories/image_collage_repository.dart';

class LocalImageCollageRepository implements ImageCollageRepository {
  @override
  Future<String> createCollage({
    required List<ClothItemEntity> clothingItems,
  }) async {
    final orderedItems = _sortItemsByOutfitOrder(clothingItems);

    final validImages = <img.Image>[];

    for (final item in orderedItems) {
      final file = File(item.photoPath);

      if (!await file.exists()) continue;

      final bytes = await file.readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      if (decodedImage != null) {
        validImages.add(decodedImage);
      }
    }

    if (validImages.isEmpty) {
      throw Exception('No valid images found to create collage.');
    }

    const collageWidth = 800;
    const collageHeight = 1200;

    final collage = img.Image(width: collageWidth, height: collageHeight);

    img.fill(collage, color: img.ColorRgb8(245, 245, 245));

    final itemHeight = collageHeight ~/ validImages.length;

    for (var i = 0; i < validImages.length; i++) {
      final y = i * itemHeight;

      final height = i == validImages.length - 1
          ? collageHeight - y
          : itemHeight;

      _drawImage(
        collage: collage,
        source: validImages[i],
        x: 0,
        y: y,
        width: collageWidth,
        height: height,
      );
    }

    final appDirectory = await getApplicationDocumentsDirectory();

    final collageDirectory = Directory(
      path.join(appDirectory.path, 'outfit_collages'),
    );

    if (!await collageDirectory.exists()) {
      await collageDirectory.create(recursive: true);
    }

    final fileName =
        'outfit_collage_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final collagePath = path.join(collageDirectory.path, fileName);

    final jpgBytes = img.encodeJpg(collage, quality: 90);

    await File(collagePath).writeAsBytes(jpgBytes);

    return collagePath;
  }

  List<ClothItemEntity> _sortItemsByOutfitOrder(List<ClothItemEntity> items) {
    final order = {
      WardrobeCategories.outerwear.id: 0,
      WardrobeCategories.tops.id: 1,
      WardrobeCategories.bottoms.id: 2,
      WardrobeCategories.footwear.id: 3,
      WardrobeCategories.accessories.id: 4,
    };

    final sortedItems = [...items];

    sortedItems.sort((a, b) {
      final aOrder = order[a.wardrobeId] ?? 99;
      final bOrder = order[b.wardrobeId] ?? 99;

      return aOrder.compareTo(bOrder);
    });

    return sortedItems.take(5).toList();
  }

  void _drawImage({
    required img.Image collage,
    required img.Image source,
    required int x,
    required int y,
    required int width,
    required int height,
  }) {
    final resized = img.copyResizeCropSquare(
      source,
      size: width > height ? width : height,
    );

    final cropped = img.copyCrop(
      resized,
      x: (resized.width - width) ~/ 2,
      y: (resized.height - height) ~/ 2,
      width: width,
      height: height,
    );

    img.compositeImage(collage, cropped, dstX: x, dstY: y);
  }
}
