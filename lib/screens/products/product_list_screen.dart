import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/loading_indicator.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  Future<void> _loadProducts() async {
    setState(() {
      _productsFuture = _productService.getProducts();
    });
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await CustomAlertDialog.show(
      context: context,
      title: AppStrings.confirmDelete,
      message: '¿Está seguro que desea eliminar el producto ${product.name}?',
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
      isDestructive: true,
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _productService.deleteProduct(product.id!);
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado con éxito'),
              backgroundColor: AppColors.success,
            ),
          );
          _loadProducts();
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
  
  Future<void> _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductFormScreen(),
      ),
    );
    
    if (result == true) {
      _loadProducts();
    }
  }
  
  Future<void> _navigateToEditProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );
    
    if (result == true) {
      _loadProducts();
    }
  }
  
  Future<void> _navigateToProductDetail(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
    
    // Reload in case any changes were made
    _loadProducts();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            onRefresh: _loadProducts,
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator(message: 'Cargando productos...');
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay productos disponibles'),
                  );
                } else {
                  final products = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(AppPadding.medium),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductItem(product);
                    },
                  );
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _navigateToAddProduct,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add),
          ),
        ),
        
        // Loading overlay
        if (_isLoading) LoadingIndicator.fullScreen(),
      ],
    );
  }
  
  Widget _buildProductItem(Product product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.medium),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _navigateToEditProduct(product),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: AppStrings.edit,
            ),
            SlidableAction(
              onPressed: (_) => _deleteProduct(product),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: AppStrings.delete,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => _navigateToProductDetail(product),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      size: 40,
                      color: AppColors.error,
                    ),
                  ),
                ),
                
                // Product info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.medium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: AppFonts.headline3,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: AppFonts.body1,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppPadding.small),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.small,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: product.state == "Activo" 
                                ? AppColors.success.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.state ?? "Activo",
                            style: TextStyle(
                              fontSize: AppFonts.caption,
                              color: product.state == "Activo" 
                                  ? AppColors.success
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Arrow indicator
                const Padding(
                  padding: EdgeInsets.all(AppPadding.medium),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
