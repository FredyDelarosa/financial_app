class UpdateTransactionRequest {
  final String? categoriaId;
  final double? monto;
  final String? descripcion;
  final String? fecha;
  final String? metodoPago;

  UpdateTransactionRequest({
    this.categoriaId,
    this.monto,
    this.descripcion,
    this.fecha,
    this.metodoPago,
  });

  Map<String, dynamic> toJson() => {
        if (categoriaId != null) 'categoria_id': categoriaId,
        if (monto != null) 'monto': monto,
        if (descripcion != null) 'descripcion': descripcion,
        if (fecha != null) 'fecha': fecha,
        if (metodoPago != null) 'metodo_pago': metodoPago,
      };
}