import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateUserNameUseCase {
  final AuthRepository repository;

  const UpdateUserNameUseCase(this.repository);

  Future<UserEntity> call({required String userId, required String fullName}) {
    return repository.updateUserName(fullName: fullName);
  }
}
