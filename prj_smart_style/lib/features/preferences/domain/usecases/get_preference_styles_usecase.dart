import '../entities/preferences_style_entity.dart';
import '../repositories/preferences_repository.dart';

class GetPreferenceStylesUseCase {
  final PreferencesRepository repository;

  const GetPreferenceStylesUseCase(this.repository);

  Future<List<PreferencesStyleEntity>> call() {
    return repository.getPreferenceStyles();
  }
}
