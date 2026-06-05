import '../entities/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;
  const UpdateCategoryUseCase(this.repository);

  Future<Category> execute(String usuarioId, String categoryId, {String? nombre, String? icono, String? color}) async {
    if (nombre != null && nombre.isEmpty) throw Exception('El nombre no puede estar vacío');
    if (color != null && (!color.startsWith('#') || color.length != 7)) throw Exception('Color inválido');
    return await repository.updateCategory(usuarioId, categoryId, nombre: nombre, icono: icono, color: color);
  }
}