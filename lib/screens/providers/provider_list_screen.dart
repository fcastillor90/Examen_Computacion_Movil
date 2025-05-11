
import 'package:flutter/material.dart';

class ProviderListScreen extends StatelessWidget {
  const ProviderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Proveedores')),
      body: const Center(child: Text('Pantalla de proveedores')),
    );
  }
}
