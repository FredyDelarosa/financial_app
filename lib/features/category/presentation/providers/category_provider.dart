import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';

enum CategoryState { initial, loading, loaded, error }

class CategoryProvider with ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final CreateCategoryUseCase _createCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  CategoryProvider({
    required GetCategoriesUseCase getCategoriesUseCase,
    required CreateCategoryUseCase createCategoryUseCase,
    required UpdateCategoryUseCase updateCategoryUseCase,
    required DeleteCategoryUseCase deleteCategoryUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _createCategoryUseCase = createCategoryUseCase,
        _updateCategoryUseCase = updateCategoryUseCase,
        _deleteCategoryUseCase = deleteCategoryUseCase;

  CategoryState _state = CategoryState.initial;
  List<Category> _categories = [];
  String? _errorMessage;

  CategoryState get state => _state;
  List<Category> get categories => List.unmodifiable(_categories);
  String? get errorMessage => _errorMessage;

  Future<void> loadCategories(String usuarioId, {String? tipo}) async {
    _state = CategoryState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _getCategoriesUseCase.execute(usuarioId, tipo: tipo);
      _state = CategoryState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = CategoryState.error;
      notifyListeners();
    }
  }

  Future<bool> createCategory(String usuarioId, String nombre, String icono, String color, String tipo) async {
    try {
      final newCat = await _createCategoryUseCase.execute(usuarioId, nombre, icono, color, tipo);
      _categories = [..._categories, newCat];
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory(String usuarioId, String categoryId, {String? nombre, String? icono, String? color}) async {
    try {
      final updated = await _updateCategoryUseCase.execute(usuarioId, categoryId, nombre: nombre, icono: icono, color: color);
      final index = _categories.indexWhere((c) => c.id == categoryId);
      if (index != -1) {
        _categories[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategory(String usuarioId, String categoryId) async {
    try {
      await _deleteCategoryUseCase.execute(usuarioId, categoryId);
      _categories = _categories.where((c) => c.id != categoryId).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_state == CategoryState.error) {
      _state = CategoryState.loaded;
      _errorMessage = null;
      notifyListeners();
    }
  }
}