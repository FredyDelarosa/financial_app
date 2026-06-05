class CreateGoalRequest {
  final String nombre;
  final double montoObjetivo;
  final double montoActual;
  final String fechaLimite; // YYYY-MM-DD
  final int prioridad;

  CreateGoalRequest({
    required this.nombre,
    required this.montoObjetivo,
    required this.montoActual,
    required this.fechaLimite,
    required this.prioridad,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'monto_objetivo': montoObjetivo,
        'monto_actual': montoActual,
        'fecha_limite': fechaLimite,
        'prioridad': prioridad,
      };
}