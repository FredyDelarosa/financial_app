class RegisterRequest {
  final String nombre;
  final String email;
  final String password;
  final String? moneda;
  const RegisterRequest({required this.nombre, required this.email, required this.password, this.moneda});

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'email': email,
    'password': password,
    if (moneda != null) 'moneda_preferida': moneda,
  };
}