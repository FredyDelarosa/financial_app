import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionFilterBar extends StatefulWidget {
  final Function(DateTime? start, DateTime? end, String? tipo, String? categoriaId) onFilterChanged;
  final List<String>? categoriasIds; // opcional

  const TransactionFilterBar({super.key, required this.onFilterChanged, this.categoriasIds});

  @override
  State<TransactionFilterBar> createState() => _TransactionFilterBarState();
}

class _TransactionFilterBarState extends State<TransactionFilterBar> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _tipo;
  String? _categoriaId;

  void _applyFilter() {
    widget.onFilterChanged(_startDate, _endDate, _tipo, _categoriaId);
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _tipo = null;
      _categoriaId = null;
    });
    _applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _startDate = picked);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startDate == null ? 'Desde' : DateFormat('dd/MM/yyyy').format(_startDate!)),
                  ),
                ),
                const Icon(Icons.arrow_forward),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _endDate = picked);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_endDate == null ? 'Hasta' : DateFormat('dd/MM/yyyy').format(_endDate!)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                DropdownButton<String>(
                  hint: const Text('Tipo'),
                  value: _tipo,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Todos')),
                    DropdownMenuItem(value: 'gasto', child: Text('Gastos')),
                    DropdownMenuItem(value: 'ingreso', child: Text('Ingresos')),
                  ],
                  onChanged: (v) => setState(() => _tipo = v),
                ),
                const SizedBox(width: 16),
                // Aquí se podría agregar filtro por categoría si se tienen las categorías
                const Spacer(),
                TextButton(onPressed: _clearFilters, child: const Text('Limpiar')),
                ElevatedButton(onPressed: _applyFilter, child: const Text('Filtrar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}