import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/custom_button.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();
  late Product _product;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  Future<void> _deleteProduct() async {
    final confirmed = await CustomAlertDialog.show(
      context: context,
      title: AppStrings.confirmDelete,
      message: '¿Está seguro que desea eliminar el producto ${_product.name}?',
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
      isDestructive: true,
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _productService.deleteProduct(_product.id!);
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado con éxito'),
              backgroundColor: AppColors.success,
            ),
          );
          // Close screen and return to previous
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al eliminar el producto'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToEditProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: _product),
      ),
    );
    
    if (result == true) {
      // If product was updated, pop back to list
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productDetail),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditProduct,
            tooltip: AppStrings.edit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteProduct,
            tooltip: AppStrings.delete,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    Center(
                      child: Hero(
                        tag: 'product_image_${_product.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: _product.imageUrl,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.error,
                                size: 50,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppPadding.large),
                    
                    // Product name
                    const Text(
                      'Nombre del producto',
                      style: TextStyle(
                        fontSize: AppFonts.body2,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppPadding.small / 2),
                    Text(
                      _product.name,
                      style: const TextStyle(
                        fontSize: AppFonts.headline2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppPadding.medium),
                    
                    // Price and State in a row
                    Row(
                      children: [
                        // Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Precio',
                                style: TextStyle(
                                  fontSize: AppFonts.body2,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppPadding.small / 2),
                              Text(
                                '\$${_product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: AppFonts.headline3,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // State
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Estado',
                                style: TextStyle(
                                  fontSize: AppFonts.body2,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppPadding.small / 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.small,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _product.state == "Activo" 
                                      ? AppColors.success.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _product.state ?? "Activo",
                                  style: TextStyle(
                                    fontSize: AppFonts.body2,
                                    color: _product.state == "Activo" 
                                        ? AppColors.success
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.large),
                    
                    // Image URL
                    const Text(
                      'URL de la imagen',
                      style: TextStyle(
                        fontSize: AppFonts.body2,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppPadding.small / 2),
                    Text(
                      _product.imageUrl,
                      style: const TextStyle(
                        fontSize: AppFonts.body2,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppPadding.large),
                    
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppStrings.edit,
                            onPressed: _navigateToEditProduct,
                            icon: Icons.edit,
                          ),
                        ),
                        const SizedBox(width: AppPadding.medium),
                        Expanded(
                          child: CustomButton(
                            text: AppStrings.delete,
                            onPressed: _deleteProduct,
                            color: AppColors.error,
                            icon: Icons.delete,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
