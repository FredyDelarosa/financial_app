class Goal {
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

  // Datos calculados (opcionales, para UI)
  final double? progreso;
  final double? montoRestante;
  final int? diasRestantes;

  const Goal({
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
}