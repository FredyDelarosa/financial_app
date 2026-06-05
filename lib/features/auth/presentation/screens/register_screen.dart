import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _moneda = 'MXN';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<Map<String, String>> _monedas = const [
    {'codigo': 'MXN', 'nombre': 'Peso Mexicano (MXN)'},
    {'codigo': 'USD', 'nombre': 'Dólar Americano (USD)'},
    {'codigo': 'EUR', 'nombre': 'Euro (EUR)'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthProvider>().register(
            _nombreController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
            moneda: _moneda,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return switch (auth.state) {
      AuthState.authenticated => _redirectToDashboard(),
      _ => Scaffold(
          appBar: AppBar(title: const Text('Registro')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(labelText: 'Nombre completo', prefixIcon: Icon(Icons.person)),
                        validator: (v) => v == null || v.isEmpty ? 'Ingrese nombre' : (v.length < 3 ? 'Mínimo 3 caracteres' : null),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Correo', prefixIcon: Icon(Icons.email)),
                        validator: (v) => v == null || v.isEmpty ? 'Ingrese correo' : (!v.contains('@') ? 'Correo inválido' : null),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Ingrese contraseña' : (v.length < 6 ? 'Mínimo 6 caracteres' : null),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirmar contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (v) => v == _passwordController.text ? null : 'Las contraseñas no coinciden',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _moneda,
                        decoration: const InputDecoration(labelText: 'Moneda', prefixIcon: Icon(Icons.attach_money)),
                        items: _monedas.map((e) => DropdownMenuItem(value: e['codigo'], child: Text(e['nombre']!))).toList(),
                        onChanged: (v) => setState(() => _moneda = v!),
                      ),
                      const SizedBox(height: 24),
                      if (auth.isLoading)
                        const CircularProgressIndicator()
                      else ...[
                        ElevatedButton(
                          onPressed: _handleRegister,
                          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                          child: const Text('Registrarse'),
                        ),
                        if (auth.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(auth.errorMessage!, style: const TextStyle(color: Colors.red)),
                        ],
                      ],
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    };
  }

  Widget _redirectToDashboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
    return const SizedBox.shrink();
  }
}