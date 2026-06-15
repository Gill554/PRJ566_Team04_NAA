import '../entities/preferences_style_entity.dart';

class PreferenceStyles {
  static const casual = PreferencesStyleEntity(
    id: 'style_001',
    title: 'Casual',
    prompt:
        'Create comfortable, relaxed outfits for everyday use. Prioritize ease of movement, simple combinations, and practical pieces.',
  );

  static const professional = PreferencesStyleEntity(
    id: 'style_002',
    title: 'Professional',
    prompt:
        'Create polished workplace outfits. Prioritize clean silhouettes, structured pieces, modest combinations, and business-appropriate styling.',
  );

  static const formal = PreferencesStyleEntity(
    id: 'style_003',
    title: 'Formal',
    prompt:
        'Create elegant outfits for formal occasions. Prioritize refined pieces, coordinated colors, polished shoes, and a sophisticated appearance.',
  );

  static const smartCasual = PreferencesStyleEntity(
    id: 'style_004',
    title: 'Smart Casual',
    prompt:
        'Create outfits that balance casual comfort with a polished look. Combine relaxed pieces with one or two refined elements.',
  );

  static const sporty = PreferencesStyleEntity(
    id: 'style_005',
    title: 'Sporty',
    prompt:
        'Create active and comfortable outfits. Prioritize breathable pieces, athletic silhouettes, sneakers, and practical layering.',
  );

  static const minimalist = PreferencesStyleEntity(
    id: 'style_006',
    title: 'Minimalist',
    prompt:
        'Create clean and simple outfits. Prioritize neutral basics, few visual details, balanced proportions, and uncluttered combinations.',
  );

  static const List<PreferencesStyleEntity> all = [
    casual,
    professional,
    formal,
    smartCasual,
    sporty,
    minimalist,
  ];
}
