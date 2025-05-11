
import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../utils/constants.dart';

class ProductFormScreen extends StatelessWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product == null ? 'Nuevo producto' : 'Editar producto')),
      body: Center(
        child: Text('Aquí va el formulario de producto.'),
      ),
    );
  }
}
