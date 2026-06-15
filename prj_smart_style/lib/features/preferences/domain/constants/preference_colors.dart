import '../entities/preferences_color_entity.dart';

class PreferenceColors {
  static const warmTones = PreferencesColorEntity(
    id: 'color_001',
    title: 'Warm Tones',
    prompt:
        'Prefer warm colors such as beige, cream, camel, brown, rust, burgundy, orange, and warm red. Avoid very cold or icy palettes unless needed for balance.',
  );

  static const darkTones = PreferencesColorEntity(
    id: 'color_002',
    title: 'Dark Tones',
    prompt:
        'Prefer dark colors such as black, charcoal, navy, espresso, deep green, burgundy, and dark gray. Create strong contrast when possible.',
  );

  static const neutral = PreferencesColorEntity(
    id: 'color_003',
    title: 'Neutral',
    prompt:
        'Prefer neutral colors such as white, black, gray, beige, cream, taupe, denim blue, and soft brown. Keep combinations versatile and easy to wear.',
  );

  static const coolTones = PreferencesColorEntity(
    id: 'color_004',
    title: 'Cool Tones',
    prompt:
        'Prefer cool colors such as blue, navy, teal, lavender, cool gray, icy white, mint, and soft green. Avoid overly warm combinations.',
  );

  static const earthTones = PreferencesColorEntity(
    id: 'color_005',
    title: 'Earth Tones',
    prompt:
        'Prefer natural colors such as olive, khaki, tan, sand, brown, cream, terracotta, forest green, and muted orange.',
  );

  static const lightTones = PreferencesColorEntity(
    id: 'color_006',
    title: 'Light Tones',
    prompt:
        'Prefer light and soft colors such as white, cream, pastel blue, pastel pink, light gray, beige, and soft lavender. Keep the outfit fresh and gentle.',
  );

  static const boldColors = PreferencesColorEntity(
    id: 'color_007',
    title: 'Bold Colors',
    prompt:
        'Prefer expressive colors such as red, royal blue, emerald green, purple, bright yellow, hot pink, or strong contrast combinations. Keep the outfit balanced and avoid visual clutter.',
  );

  static const monochrome = PreferencesColorEntity(
    id: 'color_008',
    title: 'Monochrome',
    prompt:
        'Create outfits using one dominant color family or close shades of the same color. Prioritize tonal harmony and subtle contrast through texture or shade.',
  );

  static const List<PreferencesColorEntity> all = [
    warmTones,
    darkTones,
    neutral,
    coolTones,
    earthTones,
    lightTones,
    boldColors,
    monochrome,
  ];
}
