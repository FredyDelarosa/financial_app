import 'package:flutter/material.dart';

class AddProgressDialog extends StatefulWidget {
  final String goalName;
  final double montoRestante;

  const AddProgressDialog({super.key, required this.goalName, required this.montoRestante});

  @override
  State<AddProgressDialog> createState() => _AddProgressDialogState();
}

class _AddProgressDialogState extends State<AddProgressDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar progreso a "${widget.goalName}"'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Restante: \$${widget.montoRestante.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ctrl,
            decoration: const InputDecoration(labelText: 'Monto adicional'),
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            final monto = double.tryParse(_ctrl.text);
            if (monto != null && monto > 0 && monto <= widget.montoRestante) {
              Navigator.pop(context, monto);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Monto inválido o excede el restante')),
              );
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}