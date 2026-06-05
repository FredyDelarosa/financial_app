import '../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repository;
  const DeleteCategoryUseCase(this.repository);

  Future<void> execute(String usuarioId, String categoryId) async {
    await repository.deleteCategory(usuarioId, categoryId);
  }
}