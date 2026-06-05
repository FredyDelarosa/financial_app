class UpdateCategoryRequest {
  final String? nombre;
  final String? icono;
  final String? color;

  const UpdateCategoryRequest({this.nombre, this.icono, this.color});

  Map<String, dynamic> toJson() => {
        if (nombre != null) 'nombre': nombre,
        if (icono != null) 'icono': icono,
        if (color != null) 'color': color,
      };
}