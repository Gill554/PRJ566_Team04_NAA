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

/// OUTFIT
import '../../features/outfit/data/repositories/gemini_outfit_repository.dart';
import '../../features/outfit/domain/usecases/prepare_outfit_input_usecase.dart';
import '../../features/outfit/domain/usecases/generate_outfits_with_collage_usecase.dart';
import '../../features/outfit/presentation/controllers/outfit_controller.dart';

/// FAVORITES
import '../../features/favorites/data/datasources/favorites_local_datasource.dart';
import '../../features/favorites/data/repositories/sqlite_favorites_repository.dart';
import '../../features/favorites/domain/usecases/delete_favorite_usecase.dart';
import '../../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/save_favorite_usecase.dart';
import '../../features/favorites/presentation/controllers/favorites_controller.dart';

/// CAMERA
import 'package:image_picker/image_picker.dart';
import 'package:prj_smart_style/shared/camera/data/repositories/image_picker_repository.dart';
import 'package:prj_smart_style/shared/camera/domain/usecases/pick_image_from_gallery_usecase.dart';
import 'package:prj_smart_style/shared/camera/domain/usecases/take_photo_usecase.dart';

/// IMAGE PROCESSING
import '../../shared/image_processing/data/repositories/local_image_collage_repository.dart';
import '../../shared/image_processing/domain/usecases/create_outfit_collage_usecase.dart';

class AppProviders {
  /// DATABASE
  static final AppDatabase appDatabase = AppDatabase.instance;

  /// GEMINI
  static final geminiService = GeminiService();

  static final DatabaseService databaseService = DatabaseService(
    appDatabase: appDatabase,
  );

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

  /// OUTFIT
  static final outfitRepository = GeminiOutfitRepository(
    geminiService: geminiService,
  );

  /// FAVORITES
  static final favoritesLocalDatasource = FavoritesLocalDatasource(
    databaseService: databaseService,
  );

  static final favoritesRepository = SQLiteFavoritesRepository(
    localDatasource: favoritesLocalDatasource,
  );

  /// CAMERA
  static final imagePickerRepository = ImagePickerRepositoryImpl(
    imagePicker: ImagePicker(),
  );

  /// IMAGE PROCESSING
  static final imageCollageRepository = LocalImageCollageRepository();

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

    /// OUTFIT INPUT
    Provider(
      create: (_) {
        return PrepareOutfitInputUseCase(wardrobeRepository);
      },
    ),

    /// OUTFIT
    ChangeNotifierProvider(
      create: (_) {
        final createOutfitCollageUseCase = CreateOutfitCollageUseCase(
          imageCollageRepository,
        );

        return OutfitController(
          generateOutfitsWithCollageUseCase: GenerateOutfitsWithCollageUseCase(
            outfitRepository: outfitRepository,
            createOutfitCollageUseCase: createOutfitCollageUseCase,
          ),
        );
      },
    ),

    /// FAVORITES
    ChangeNotifierProvider(
      create: (_) {
        return FavoritesController(
          getFavoritesUseCase: GetFavoritesUseCase(favoritesRepository),
          saveFavoriteUseCase: SaveFavoriteUseCase(favoritesRepository),
          deleteFavoriteUseCase: DeleteFavoriteUseCase(favoritesRepository),
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
