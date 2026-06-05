class Budget {
  final String id;
  final String usuarioId;
  final String categoriaId;
  final int mes;
  final int anio;
  final double montoLimite;

  // Datos enriquecidos (opcionales, para UI)
  final String? categoriaNombre;
  final String? categoriaIcono;
  final String? categoriaColor;
  final double? gastado;
  final double? porcentaje;
  final String? estado; // 'normal', 'advertencia', 'excedido'

  const Budget({
    required this.id,
    required this.usuarioId,
    required this.categoriaId,
    required this.mes,
    required this.anio,
    required this.montoLimite,
    this.categoriaNombre,
    this.categoriaIcono,
    this.categoriaColor,
    this.gastado,
    this.porcentaje,
    this.estado,
  });
}