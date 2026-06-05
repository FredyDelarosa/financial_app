class UpdateGoalRequest {
  final String? nombre;
  final double? montoObjetivo;
  final String? fechaLimite;
  final int? prioridad;
  final String? estado;

  UpdateGoalRequest({
    this.nombre,
    this.montoObjetivo,
    this.fechaLimite,
    this.prioridad,
    this.estado,
  });

  Map<String, dynamic> toJson() => {
        if (nombre != null) 'nombre': nombre,
        if (montoObjetivo != null) 'monto_objetivo': montoObjetivo,
        if (fechaLimite != null) 'fecha_limite': fechaLimite,
        if (prioridad != null) 'prioridad': prioridad,
        if (estado != null) 'estado': estado,
      };
}