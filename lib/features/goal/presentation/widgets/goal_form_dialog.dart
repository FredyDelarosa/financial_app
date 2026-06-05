import 'package:flutter/material.dart';
import '../../domain/entities/goal.dart';

class GoalFormDialog extends StatefulWidget {
  final Goal? initialGoal;

  const GoalFormDialog({super.key, this.initialGoal});

  @override
  State<GoalFormDialog> createState() => _GoalFormDialogState();
}

class _GoalFormDialogState extends State<GoalFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _montoObjetivoCtrl;
  late final TextEditingController _montoActualCtrl;
  late DateTime _fechaLimite;
  late int _prioridad;

  @override
  void initState() {
    super.initState();
    final goal = widget.initialGoal;
    _nombreCtrl = TextEditingController(text: goal?.nombre ?? '');
    _montoObjetivoCtrl = TextEditingController(text: goal?.montoObjetivo.toString() ?? '');
    _montoActualCtrl = TextEditingController(text: goal?.montoActual.toString() ?? '0');
    _fechaLimite = goal?.fechaLimite ?? DateTime.now().add(const Duration(days: 30));
    _prioridad = goal?.prioridad ?? 3;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _montoObjetivoCtrl.dispose();
    _montoActualCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialGoal == null ? 'Nueva meta' : 'Editar meta'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre de la meta'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _montoObjetivoCtrl,
                decoration: const InputDecoration(labelText: 'Monto objetivo'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || double.tryParse(v) == null ? 'Monto válido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _montoActualCtrl,
                decoration: const InputDecoration(labelText: 'Monto actual (opcional)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || double.tryParse(v) == null ? 'Monto válido' : null,
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Fecha límite'),
                subtitle: Text('${_fechaLimite.day}/${_fechaLimite.month}/${_fechaLimite.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fechaLimite,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (picked != null) setState(() => _fechaLimite = picked);
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _prioridad,
                decoration: const InputDecoration(labelText: 'Prioridad'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 - Muy baja')),
                  DropdownMenuItem(value: 2, child: Text('2 - Baja')),
                  DropdownMenuItem(value: 3, child: Text('3 - Media')),
                  DropdownMenuItem(value: 4, child: Text('4 - Alta')),
                  DropdownMenuItem(value: 5, child: Text('5 - Muy alta')),
                ],
                onChanged: (v) => setState(() => _prioridad = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'nombre': _nombreCtrl.text,
                'montoObjetivo': double.parse(_montoObjetivoCtrl.text),
                'montoActual': double.parse(_montoActualCtrl.text),
                'fechaLimite': _fechaLimite,
                'prioridad': _prioridad,
              });
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}