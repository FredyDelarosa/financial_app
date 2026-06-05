abstract class TransactionService {
  Future<double> getGastosPorCategoria(String usuarioId, String categoriaId, int mes, int anio);
  Future<Map<String, double>> getGastosPorCategorias(String usuarioId, int mes, int anio);
}