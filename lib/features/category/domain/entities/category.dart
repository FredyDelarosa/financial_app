class Category {
  final String id;
  final String? usuarioId;
  final String nombre;
  final String icono;
  final String color;
  final String tipo;
  final bool esSistema;

  const Category({
    required this.id,
    this.usuarioId,
    required this.nombre,
    required this.icono,
    required this.color,
    required this.tipo,
    required this.esSistema,
  });
}