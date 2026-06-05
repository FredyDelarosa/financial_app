class CreateCategoryRequest {
  final String nombre;
  final String icono;
  final String color;
  final String tipo;

  const CreateCategoryRequest({
    required this.nombre,
    required this.icono,
    required this.color,
    required this.tipo,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'icono': icono,
        'color': color,
        'tipo': tipo,
      };
}