import '../entities/preferences_color_entity.dart';
import '../repositories/preferences_repository.dart';

class GetPreferenceColorsUseCase {
  final PreferencesRepository repository;

  const GetPreferenceColorsUseCase(this.repository);

  Future<List<PreferencesColorEntity>> call() {
    return repository.getPreferenceColors();
  }
}
