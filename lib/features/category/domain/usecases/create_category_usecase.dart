import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategoryUseCase {
  final CategoryRepository repository;
  const CreateCategoryUseCase(this.repository);

  Future<Category> execute(String usuarioId, String nombre, String icono, String color, String tipo) async {
    if (nombre.isEmpty) throw Exception('El nombre es requerido');
    if (icono.isEmpty) throw Exception('El icono es requerido');
    if (!color.startsWith('#') || color.length != 7) throw Exception('Color inválido (ej. #4CAF50)');
    if (!['ingreso', 'gasto'].contains(tipo)) throw Exception('Tipo inválido');
    return await repository.createCategory(usuarioId, nombre, icono, color, tipo);
  }
}