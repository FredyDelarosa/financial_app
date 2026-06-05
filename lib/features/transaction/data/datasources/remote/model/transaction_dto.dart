import '../../../../domain/entities/transaction.dart';

class TransactionDto {
  final String id;
  final String usuarioId;
  final String categoriaId;
  final double monto;
  final String descripcion;
  final DateTime fecha;
  final String tipo;
  final bool esRecurrente;
  final String? frecuencia;
  final String metodoPago;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoriaNombre;
  final String? categoriaIcono;
  final String? categoriaColor;

  TransactionDto({
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

  factory TransactionDto.fromJson(Map<String, dynamic> json) => TransactionDto(
        id: json['id'],
        usuarioId: json['usuario_id'],
        categoriaId: json['categoria_id'],
        monto: (json['monto'] as num).toDouble(),
        descripcion: json['descripcion'],
        fecha: DateTime.parse(json['fecha']),
        tipo: json['tipo'],
        esRecurrente: json['es_recurrente'] ?? false,
        frecuencia: json['frecuencia'],
        metodoPago: json['metodo_pago'] ?? 'efectivo',
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        categoriaNombre: json['categoria_nombre'],
        categoriaIcono: json['categoria_icono'],
        categoriaColor: json['categoria_color'],
      );

  Transaction toEntity() => Transaction(
        id: id,
        usuarioId: usuarioId,
        categoriaId: categoriaId,
        monto: monto,
        descripcion: descripcion,
        fecha: fecha,
        tipo: tipo,
        esRecurrente: esRecurrente,
        frecuencia: frecuencia,
        metodoPago: metodoPago,
        createdAt: createdAt,
        updatedAt: updatedAt,
        categoriaNombre: categoriaNombre,
        categoriaIcono: categoriaIcono,
        categoriaColor: categoriaColor,
      );
}