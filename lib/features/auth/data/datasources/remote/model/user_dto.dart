class UserDto {
  final String id;
  final String nombre;
  final String email;
  final String monedaPreferida;
  final String createdAt;
  const UserDto({required this.id, required this.nombre, required this.email, required this.monedaPreferida, required this.createdAt});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'],
    nombre: json['nombre'],
    email: json['email'],
    monedaPreferida: json['moneda_preferida'] ?? 'MXN',
    createdAt: json['created_at'],
  );
}