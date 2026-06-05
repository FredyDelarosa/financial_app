import '../domain/ports/category_service.dart';
import '../../category/domain/repositories/category_repository.dart';
import '../../category/domain/entities/category.dart';

class CategoryServiceAdapter implements CategoryService {
  final CategoryRepository categoryRepository;

  CategoryServiceAdapter(this.categoryRepository);

  @override
  Future<List<Category>> getCategories(String usuarioId, {String? tipo}) async {
    return await categoryRepository.getCategories(usuarioId, tipo: tipo);
  }

  @override
  Future<Category?> getCategoryById(String categoriaId) async {
    try {
      return await categoryRepository.getCategoryById(categoriaId);
    } catch (_) {
      return null;
    }
  }
}