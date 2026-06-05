class MonthlySummaryDto {
  final int mes;
  final int anio;
  final double totalIngresos;
  final double totalGastos;
  final double balance;

  MonthlySummaryDto({
    required this.mes,
    required this.anio,
    required this.totalIngresos,
    required this.totalGastos,
    required this.balance,
  });

  factory MonthlySummaryDto.fromJson(Map<String, dynamic> json) => MonthlySummaryDto(
        mes: json['mes'],
        anio: json['año'] ?? json['anio'],
        totalIngresos: (json['total_ingresos'] as num).toDouble(),
        totalGastos: (json['total_gastos'] as num).toDouble(),
        balance: (json['balance'] as num).toDouble(),
      );
}