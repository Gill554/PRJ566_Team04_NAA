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

/// PREFERENCES
import '../../features/preferences/data/datasources/preferences_local_datasource.dart';
import '../../features/preferences/data/repositories/sqlite_preferences_repository.dart';
import '../../features/preferences/domain/usecases/create_user_preference_profile_usecase.dart';
import '../../features/preferences/domain/usecases/delete_user_preference_profile_usecase.dart';
import '../../features/preferences/domain/usecases/get_preference_colors_usecase.dart';
import '../../features/preferences/domain/usecases/get_preference_styles_usecase.dart';
import '../../features/preferences/domain/usecases/get_user_preference_profiles_usecase.dart';
import '../../features/preferences/domain/usecases/update_user_preference_profile_usecase.dart';
import '../../features/preferences/presentation/controllers/preferences_controller.dart';

/// WARDROBE
import '../../shared/ai/data/services/gemini_service.dart';
import '../../features/wardrobe/data/datasources/wardrobe_local_datasource.dart';
import '../../features/wardrobe/data/repositories/sqlite_wardrobe_repository.dart';
import '../../features/wardrobe/data/repositories/gemini_clothing_analysis_repository.dart';
import '../../features/wardrobe/domain/usecases/add_clothing_item_usecase.dart';
import '../../features/wardrobe/domain/usecases/analyze_and_add_clothing_item_usecase.dart';
import '../../features/wardrobe/domain/usecases/delete_clothing_item_usecase.dart';
import '../../features/wardrobe/domain/usecases/get_all_clothing_items_usecase.dart';
import '../../features/wardrobe/domain/usecases/get_clothing_items_by_category_usecase.dart';
import '../../features/wardrobe/domain/usecases/get_wardrobe_categories_usecase.dart';
import '../../features/wardrobe/presentation/controllers/wardrobe_controller.dart';

/// CAMERA
import 'package:image_picker/image_picker.dart';
import '../../shared/camera/data/repositories/image_picker_repository.dart';
import '../../shared/camera/domain/usecases/pick_image_from_gallery_usecase.dart';
import '../../shared/camera/domain/usecases/take_photo_usecase.dart';

class AppProviders {
  /// DATABASE
  static final AppDatabase appDatabase = AppDatabase.instance;

  static final DatabaseService databaseService = DatabaseService(
    appDatabase: appDatabase,
  );

  /// GEMINI
  static final geminiService = GeminiService();

  /// AUTH
  static final authRepository = FirebaseAuthRepository(
    firebaseAuth: FirebaseAuth.instance,
  );

  /// PREFERENCES
  static final preferencesLocalDatasource = PreferencesLocalDatasource(
    databaseService: databaseService,
  );

  static final preferencesRepository = SQLitePreferencesRepository(
    localDatasource: preferencesLocalDatasource,
  );

  /// WARDROBE
  static final wardrobeLocalDatasource = WardrobeLocalDatasource(
    databaseService: databaseService,
  );

  static final wardrobeRepository = SQLiteWardrobeRepository(
    localDatasource: wardrobeLocalDatasource,
  );

  static final clothingAnalysisRepository = GeminiClothingAnalysisRepository(
    geminiService: geminiService,
  );

  /// CAMERA
  static final imagePickerRepository = ImagePickerRepositoryImpl(
    imagePicker: ImagePicker(),
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

    /// PREFERENCES
    ChangeNotifierProvider(
      create: (_) {
        return PreferencesController(
          getPreferenceStylesUseCase: GetPreferenceStylesUseCase(
            preferencesRepository,
          ),
          getPreferenceColorsUseCase: GetPreferenceColorsUseCase(
            preferencesRepository,
          ),
          getUserPreferenceProfilesUseCase: GetUserPreferenceProfilesUseCase(
            preferencesRepository,
          ),
          createUserPreferenceProfileUseCase:
              CreateUserPreferenceProfileUseCase(preferencesRepository),
          updateUserPreferenceProfileUseCase:
              UpdateUserPreferenceProfileUseCase(preferencesRepository),
          deleteUserPreferenceProfileUseCase:
              DeleteUserPreferenceProfileUseCase(preferencesRepository),
        );
      },
    ),

    /// WARDROBE
    ChangeNotifierProvider(
      create: (_) {
        return WardrobeController(
          getWardrobeCategoriesUseCase: GetWardrobeCategoriesUseCase(
            wardrobeRepository,
          ),
          getClothingItemsByCategoryUseCase: GetClothingItemsByCategoryUseCase(
            wardrobeRepository,
          ),
          getAllClothingItemsUseCase: GetAllClothingItemsUseCase(
            wardrobeRepository,
          ),
          addClothingItemUseCase: AddClothingItemUseCase(wardrobeRepository),
          deleteClothingItemUseCase: DeleteClothingItemUseCase(
            wardrobeRepository,
          ),
          analyzeAndAddClothingItemUseCase: AnalyzeAndAddClothingItemUseCase(
            analysisRepository: clothingAnalysisRepository,
            wardrobeRepository: wardrobeRepository,
          ),
        );
      },
    ),

    /// CAMERA
    Provider(
      create: (_) {
        return TakePhotoUseCase(imagePickerRepository);
      },
    ),

    Provider(
      create: (_) {
        return PickImageFromGalleryUseCase(imagePickerRepository);
      },
    ),
  ];
}
