import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/mapper/category_mapper.dart';
import '../datasources/remote/model/category_dto.dart';
import '../datasources/remote/model/create_category_request.dart';
import '../datasources/remote/model/update_category_request.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final http.Client client;
  final String Function() getToken;

  CategoryRepositoryImpl({required this.client, required this.getToken});

  Future<Map<String, String>> _authHeaders() async {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<Category>> getCategories(String usuarioId, {String? tipo}) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/categories/').replace(
      queryParameters: {
        if (tipo != null) 'tipo': tipo,
        'usuario_id': usuarioId,
      },
    );
    final response = await client.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final List<dynamic>? data = jsonDecode(response.body)['data'];
      final List<dynamic> list = data ?? [];
      return list.map((e) => CategoryMapper.toEntity(CategoryDto.fromJson(e))).toList();
    }
    throw Exception('Error al obtener categorías: ${response.statusCode}');
  }

  @override
  Future<Category> createCategory(String usuarioId, String nombre, String icono, String color, String tipo) async {
    final request = CreateCategoryRequest(nombre: nombre, icono: icono, color: color, tipo: tipo);
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/api/categories/'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return CategoryMapper.toEntity(CategoryDto.fromJson(data));
    }
    throw Exception('Error al crear categoría');
  }

  @override
  Future<Category> updateCategory(String usuarioId, String categoryId, {String? nombre, String? icono, String? color}) async {
    final request = UpdateCategoryRequest(nombre: nombre, icono: icono, color: color);
    final response = await client.put(
      Uri.parse('${AppConstants.baseUrl}/api/categories/$categoryId'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return CategoryMapper.toEntity(CategoryDto.fromJson(data));
    }
    throw Exception('Error al actualizar categoría');
  }

  @override
  Future<void> deleteCategory(String usuarioId, String categoryId) async {
    final response = await client.delete(
      Uri.parse('${AppConstants.baseUrl}/api/categories/$categoryId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar categoría');
    }
  }

  @override
  Future<Category> getCategoryById(String categoryId) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/categories/$categoryId');
    final response = await client.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return CategoryMapper.toEntity(CategoryDto.fromJson(data));
    }
    throw Exception('Categoría no encontrada');
  }
}