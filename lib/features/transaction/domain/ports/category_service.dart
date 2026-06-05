import '../../../category/domain/entities/category.dart';

abstract class CategoryService {
  Future<List<Category>> getCategories(String usuarioId, {String? tipo});
  Future<Category?> getCategoryById(String categoriaId);
}