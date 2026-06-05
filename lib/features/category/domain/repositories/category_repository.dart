import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories(String usuarioId, {String? tipo});
  Future<Category> createCategory(String usuarioId, String nombre, String icono, String color, String tipo);
  Future<Category> updateCategory(String usuarioId, String categoryId, {String? nombre, String? icono, String? color});
  Future<void> deleteCategory(String usuarioId, String categoryId);
  Future<Category> getCategoryById(String categoryId);
}