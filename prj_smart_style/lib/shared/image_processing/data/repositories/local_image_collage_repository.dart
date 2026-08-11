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
    const collageHeight = 1600;

    const outerPadding = 20;
    const spacing = 20;

    final collage = img.Image(width: collageWidth, height: collageHeight);

    img.fill(collage, color: img.ColorRgb8(250, 250, 250));

    final availableHeight =
        collageHeight - outerPadding * 2 - spacing * (validImages.length - 1);

    final itemHeight = availableHeight ~/ validImages.length;

    for (var i = 0; i < validImages.length; i++) {
      final y = outerPadding + i * (itemHeight + spacing);

      _drawImage(
        collage: collage,
        source: validImages[i],
        x: outerPadding,
        y: y,
        width: collageWidth - outerPadding * 2,
        height: itemHeight,
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
    // ---------- Crop superior e inferior ----------
    final cropTop = (source.height * 0.20).toInt();
    final cropBottom = (source.height * 0.10).toInt();

    final croppedHeight = source.height - cropTop - cropBottom;

    final croppedSource = img.copyCrop(
      source,
      x: 0,
      y: cropTop,
      width: source.width,
      height: croppedHeight,
    );

    // ---------- Resize manteniendo aspecto ----------
    final resized = img.copyResize(
      croppedSource,
      width: width,
      interpolation: img.Interpolation.average,
    );

    // ---------- Si sobra altura, recortamos verticalmente ----------
    img.Image finalImage;

    if (resized.height > height) {
      final offsetY = (resized.height - height) ~/ 2;

      finalImage = img.copyCrop(
        resized,
        x: 0,
        y: offsetY,
        width: width,
        height: height,
      );
    } else {
      finalImage = img.Image(width: width, height: height);

      img.fill(finalImage, color: img.ColorRgb8(250, 250, 250));

      img.compositeImage(
        finalImage,
        resized,
        dstX: 0,
        dstY: (height - resized.height) ~/ 2,
      );
    }

    img.compositeImage(collage, finalImage, dstX: x, dstY: y);
  }
}
