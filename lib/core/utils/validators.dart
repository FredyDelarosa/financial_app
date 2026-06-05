class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'El correo es requerido';
    if (!value.contains('@') || !value.contains('.')) return 'Correo inválido';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es requerida';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'El nombre es requerido';
    if (value.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }
}