class CreateBudgetRequest {
  final String categoriaId;
  final int mes;
  final int anio;
  final double montoLimite;

  CreateBudgetRequest({
    required this.categoriaId,
    required this.mes,
    required this.anio,
    required this.montoLimite,
  });

  Map<String, dynamic> toJson() => {
        'categoria_id': categoriaId,
        'mes': mes,
        'anio': anio,
        'monto_limite': montoLimite,
      };
}