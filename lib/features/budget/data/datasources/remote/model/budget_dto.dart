import '../../../../domain/entities/budget.dart';

class BudgetDto {
  final String id;
  final String usuarioId;
  final String categoriaId;
  final int mes;
  final int anio;
  final double montoLimite;
  final String? categoriaNombre;
  final String? categoriaIcono;
  final String? categoriaColor;

  BudgetDto({
    required this.id,
    required this.usuarioId,
    required this.categoriaId,
    required this.mes,
    required this.anio,
    required this.montoLimite,
    this.categoriaNombre,
    this.categoriaIcono,
    this.categoriaColor,
  });

  factory BudgetDto.fromJson(Map<String, dynamic> json) => BudgetDto(
        id: json['id'],
        usuarioId: json['usuario_id'],
        categoriaId: json['categoria_id'],
        mes: json['mes'],
        anio: json['anio'],
        montoLimite: (json['monto_limite'] as num).toDouble(),
        categoriaNombre: json['categoria_nombre'],
        categoriaIcono: json['categoria_icono'],
        categoriaColor: json['categoria_color'],
      );

  Budget toEntity() => Budget(
        id: id,
        usuarioId: usuarioId,
        categoriaId: categoriaId,
        mes: mes,
        anio: anio,
        montoLimite: montoLimite,
        categoriaNombre: categoriaNombre,
        categoriaIcono: categoriaIcono,
        categoriaColor: categoriaColor,
      );
}