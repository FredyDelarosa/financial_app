class CreateTransactionRequest {
  final String categoriaId;
  final double monto;
  final String descripcion;
  final String fecha; // ISO string YYYY-MM-DD
  final String tipo;
  final bool esRecurrente;
  final String? frecuencia;
  final String metodoPago;

  CreateTransactionRequest({
    required this.categoriaId,
    required this.monto,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
    this.esRecurrente = false,
    this.frecuencia,
    required this.metodoPago,
  });

  Map<String, dynamic> toJson() => {
        'categoria_id': categoriaId,
        'monto': monto,
        'descripcion': descripcion,
        'fecha': fecha,
        'tipo': tipo,
        'es_recurrente': esRecurrente,
        if (frecuencia != null) 'frecuencia': frecuencia,
        'metodo_pago': metodoPago,
      };
}