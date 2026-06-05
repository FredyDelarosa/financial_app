class Transaction {
  final String id;
  final String usuarioId;
  final String categoriaId;
  final double monto;
  final String descripcion;
  final DateTime fecha;
  final String tipo; // 'ingreso' o 'gasto'
  final bool esRecurrente;
  final String? frecuencia;
  final String metodoPago;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Datos enriquecidos (opcionales, para UI)
  final String? categoriaNombre;
  final String? categoriaIcono;
  final String? categoriaColor;

  const Transaction({
    required this.id,
    required this.usuarioId,
    required this.categoriaId,
    required this.monto,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
    required this.esRecurrente,
    this.frecuencia,
    required this.metodoPago,
    required this.createdAt,
    required this.updatedAt,
    this.categoriaNombre,
    this.categoriaIcono,
    this.categoriaColor,
  });
}