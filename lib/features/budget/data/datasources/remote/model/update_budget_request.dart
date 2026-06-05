class UpdateBudgetRequest {
  final double montoLimite;

  UpdateBudgetRequest({required this.montoLimite});

  Map<String, dynamic> toJson() => {'monto_limite': montoLimite};
}