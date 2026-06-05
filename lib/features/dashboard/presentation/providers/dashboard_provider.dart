import 'package:flutter/material.dart';

enum DashboardState { initial, loading, loaded }

class DashboardProvider with ChangeNotifier {
  DashboardState _state = DashboardState.initial;
  DashboardState get state => _state;

  Future<void> loadData() async {
    _state = DashboardState.loading;
    notifyListeners();
    // Aquí cargaríamos datos del backend (balance, últimas transacciones, etc.)
    await Future.delayed(const Duration(milliseconds: 500)); // simulación
    _state = DashboardState.loaded;
    notifyListeners();
  }
}