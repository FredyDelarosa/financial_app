import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../ports/category_service.dart';

class CreateTransactionUseCase {
  final TransactionRepository repository;
  final CategoryService categoryService;

  const CreateTransactionUseCase(this.repository, this.categoryService);

  Future<Transaction> execute(
    String usuarioId,
    String categoriaId,
    double monto,
    String descripcion,
    DateTime fecha,
    String tipo,
    String metodoPago, {
    bool esRecurrente = false,
    String? frecuencia,
  }) async {
    // Validar que la categoría exista y coincida con el tipo
    final categoria = await categoryService.getCategoryById(categoriaId);
    if (categoria == null) throw Exception('Categoría no encontrada');
    if (categoria.tipo != tipo) throw Exception('La categoría no corresponde al tipo de transacción');
    if (monto <= 0) throw Exception('El monto debe ser mayor a cero');
    if (descripcion.trim().isEmpty) throw Exception('La descripción es requerida');

    return await repository.createTransaction(
      usuarioId,
      categoriaId,
      monto,
      descripcion,
      fecha,
      tipo,
      metodoPago,
      esRecurrente: esRecurrente,
      frecuencia: frecuencia,
    );
  }
}