import '../../../../domain/entities/goal.dart';

class GoalDto {
  final String id;
  final String usuarioId;
  final String nombre;
  final double montoObjetivo;
  final double montoActual;
  final DateTime fechaLimite;
  final int prioridad;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? progreso;
  final double? montoRestante;
  final int? diasRestantes;

  GoalDto({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.montoObjetivo,
    required this.montoActual,
    required this.fechaLimite,
    required this.prioridad,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    this.progreso,
    this.montoRestante,
    this.diasRestantes,
  });

  factory GoalDto.fromJson(Map<String, dynamic> json) => GoalDto(
        id: json['id'],
        usuarioId: json['usuario_id'],
        nombre: json['nombre'],
        montoObjetivo: (json['monto_objetivo'] as num).toDouble(),
        montoActual: (json['monto_actual'] as num).toDouble(),
        fechaLimite: DateTime.parse(json['fecha_limite']),
        prioridad: json['prioridad'],
        estado: json['estado'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        progreso: (json['progreso'] as num?)?.toDouble(),
        montoRestante: (json['monto_restante'] as num?)?.toDouble(),
        diasRestantes: json['dias_restantes'],
      );

  Goal toEntity() => Goal(
        id: id,
        usuarioId: usuarioId,
        nombre: nombre,
        montoObjetivo: montoObjetivo,
        montoActual: montoActual,
        fechaLimite: fechaLimite,
        prioridad: prioridad,
        estado: estado,
        createdAt: createdAt,
        updatedAt: updatedAt,
        progreso: progreso,
        montoRestante: montoRestante,
        diasRestantes: diasRestantes,
      );
}