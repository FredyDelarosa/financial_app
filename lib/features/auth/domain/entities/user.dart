class User {
  final String id;
  final String nombre;
  final String email;
  final String monedaPreferida;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.nombre,
    required this.email,
    required this.monedaPreferida,
    required this.createdAt,
  });

  bool get isValidEmail => email.contains('@');
}