import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;
  const GetCategoriesUseCase(this.repository);

  Future<List<Category>> execute(String usuarioId, {String? tipo}) async {
    return await repository.getCategories(usuarioId, tipo: tipo);
  }
}