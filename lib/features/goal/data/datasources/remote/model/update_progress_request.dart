class UpdateProgressRequest {
  final double montoAdicional;

  UpdateProgressRequest({required this.montoAdicional});

  Map<String, dynamic> toJson() => {'monto_adicional': montoAdicional};
}