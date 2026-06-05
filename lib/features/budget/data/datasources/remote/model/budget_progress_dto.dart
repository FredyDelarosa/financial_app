class BudgetProgressDto {
  final String budgetId;
  final String categoriaId;
  final String categoriaNombre;
  final double montoLimite;
  final double gastado;
  final double porcentaje;
  final double restante;
  final String estado;

  BudgetProgressDto({
    required this.budgetId,
    required this.categoriaId,
    required this.categoriaNombre,
    required this.montoLimite,
    required this.gastado,
    required this.porcentaje,
    required this.restante,
    required this.estado,
  });

  factory BudgetProgressDto.fromJson(Map<String, dynamic> json) => BudgetProgressDto(
        budgetId: json['budget_id'],
        categoriaId: json['categoria_id'],
        categoriaNombre: json['categoria_nombre'],
        montoLimite: (json['monto_limite'] as num).toDouble(),
        gastado: (json['gastado'] as num).toDouble(),
        porcentaje: (json['porcentaje'] as num).toDouble(),
        restante: (json['restante'] as num).toDouble(),
        estado: json['estado'],
      );
}