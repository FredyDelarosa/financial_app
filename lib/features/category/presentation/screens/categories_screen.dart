import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/category.dart';
import '../providers/category_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/category_form_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuarioId = context.read<AuthProvider>().user?.id;
      if (usuarioId != null) {
        context.read<CategoryProvider>().loadCategories(usuarioId);
      }
    });
  }

  Future<void> _showCreateDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const CategoryFormDialog(),
    );
    if (result != null && mounted) {
      final usuarioId = context.read<AuthProvider>().user!.id;
      await context.read<CategoryProvider>().createCategory(
            usuarioId,
            result['nombre']!,
            result['icono']!,
            result['color']!,
            result['tipo']!,
          );
    }
  }

  Future<void> _showEditDialog(Category category) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => CategoryFormDialog(
        initialNombre: category.nombre,
        initialIcono: category.icono,
        initialColor: category.color,
        initialTipo: category.tipo,
      ),
    );
    if (result != null && mounted) {
      final usuarioId = context.read<AuthProvider>().user!.id;
      await context.read<CategoryProvider>().updateCategory(
            usuarioId,
            category.id,
            nombre: result['nombre'],
            icono: result['icono'],
            color: result['color'],
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: switch (provider.state) {
        CategoryState.loading => const Center(child: CircularProgressIndicator()),
        CategoryState.error => Center(child: Text('Error: ${provider.errorMessage}')),
        _ => ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final cat = provider.categories[index];
              return CategoryCard(
                category: cat,
                onEdit: () => _showEditDialog(cat),
                onDelete: () async {
                  final usuarioId = context.read<AuthProvider>().user!.id;
                  await provider.deleteCategory(usuarioId, cat.id);
                },
              );
            },
          ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}