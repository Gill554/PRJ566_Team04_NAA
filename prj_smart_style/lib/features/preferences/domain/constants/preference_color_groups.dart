class PreferenceColorGroups {
  static const Map<String, List<String>> compatibleColorIds = {
    'color_001': [
      'color_001', // Warm Tones
      'color_003', // Neutral
      'color_005', // Earth Tones
    ],

    'color_002': [
      'color_002', // Dark Tones
      'color_003', // Neutral
      'color_008', // Monochrome
    ],

    'color_003': [
      'color_003', // Neutral
      'color_006', // Light Tones
      'color_002', // Dark Tones
    ],

    'color_004': [
      'color_004', // Cool Tones
      'color_003', // Neutral
      'color_006', // Light Tones
    ],

    'color_005': [
      'color_005', // Earth Tones
      'color_001', // Warm Tones
      'color_003', // Neutral
    ],

    'color_006': [
      'color_006', // Light Tones
      'color_003', // Neutral
      'color_004', // Cool Tones
    ],

    'color_007': [
      'color_007', // Bold Colors
      'color_003', // Neutral
      'color_002', // Dark Tones
    ],

    'color_008': [
      'color_008', // Monochrome
      'color_003', // Neutral
      'color_002', // Dark Tones
    ],
  };

  static List<String> getCompatibleColorIds(String selectedColorId) {
    return compatibleColorIds[selectedColorId] ?? [selectedColorId];
  }
}
