class CategoryDto {
  final String id;
  final String? usuarioId;
  final String nombre;
  final String icono;
  final String color;
  final String tipo;
  final bool esSistema;

  const CategoryDto({
    required this.id,
    this.usuarioId,
    required this.nombre,
    required this.icono,
    required this.color,
    required this.tipo,
    required this.esSistema,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) => CategoryDto(
        id: json['id'],
        usuarioId: json['usuario_id'],
        nombre: json['nombre'],
        icono: json['icono'],
        color: json['color'],
        tipo: json['tipo'],
        esSistema: json['es_sistema'] ?? false,
      );
}