import 'package:http/http.dart' as http;
import '../data/repositories/category_repository_impl.dart';
import '../domain/repositories/category_repository.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/create_category_usecase.dart';
import '../domain/usecases/update_category_usecase.dart';
import '../domain/usecases/delete_category_usecase.dart';
import '../presentation/providers/category_provider.dart';

class CategoryModule {
  late final CategoryRepository _repository;
  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final CreateCategoryUseCase _createCategoryUseCase;
  late final UpdateCategoryUseCase _updateCategoryUseCase;
  late final DeleteCategoryUseCase _deleteCategoryUseCase;
  late final CategoryProvider _categoryProvider;

  CategoryRepository get repository => _repository;

  CategoryModule({required http.Client httpClient, required String Function() getToken}) {
    _repository = CategoryRepositoryImpl(client: httpClient, getToken: getToken);
    _getCategoriesUseCase = GetCategoriesUseCase(_repository);
    _createCategoryUseCase = CreateCategoryUseCase(_repository);
    _updateCategoryUseCase = UpdateCategoryUseCase(_repository);
    _deleteCategoryUseCase = DeleteCategoryUseCase(_repository);
    _categoryProvider = CategoryProvider(
      getCategoriesUseCase: _getCategoriesUseCase,
      createCategoryUseCase: _createCategoryUseCase,
      updateCategoryUseCase: _updateCategoryUseCase,
      deleteCategoryUseCase: _deleteCategoryUseCase,
    );
  }

  CategoryProvider get categoryProvider => _categoryProvider;
}