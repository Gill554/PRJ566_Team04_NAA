import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// LOCAL DATABASE
import '../../shared/local_database/app_database.dart';
import '../../shared/local_database/database_service.dart';

/// AUTH
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/update_user_name_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

class AppProviders {
  /// DATABASE
  static final AppDatabase appDatabase = AppDatabase.instance;

  static final DatabaseService databaseService = DatabaseService(
    appDatabase: appDatabase,
  );

  /// AUTH
  static final authRepository = FirebaseAuthRepository(
    firebaseAuth: FirebaseAuth.instance,
  );

  static List<SingleChildWidget> providers = [
    /// AUTH
    ChangeNotifierProvider(
      create: (_) {
        return AuthController(
          loginUseCase: LoginUseCase(authRepository),
          registerUseCase: RegisterUseCase(authRepository),
          logoutUseCase: LogoutUseCase(authRepository),
          getCurrentUserUseCase: GetCurrentUserUseCase(authRepository),
          updateUserNameUseCase: UpdateUserNameUseCase(authRepository),
        );
      },
    ),
  ];
}
