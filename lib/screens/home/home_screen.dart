
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../auth/login_screen.dart';
import '../categories/category_list_screen.dart';
import '../products/product_list_screen.dart';
import '../providers/provider_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const _HomeContent(),
    const ProductListScreen(),
    const CategoryListScreen(),
    const ProviderListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final confirmed = await CustomAlertDialog.show(
      context: context,
      title: 'Cerrar sesión',
      message: '¿Está seguro que desea cerrar sesión?',
      confirmText: 'Cerrar sesión',
      cancelText: 'Cancelar',
      isDestructive: true,
    );

    if (confirmed == true) {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: AppStrings.products,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: AppStrings.categories,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: AppStrings.providers,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return AppStrings.home;
      case 1:
        return AppStrings.productsList;
      case 2:
        return AppStrings.categoriesList;
      case 3:
        return AppStrings.providersList;
      default:
        return AppStrings.appName;
    }
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  void _navigateToScreen(BuildContext context, int index) {
    final homeState = context.findAncestorStateOfType<_HomeScreenState>();
    homeState?._onItemTapped(index);
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Bienvenido al Sistema de Gestión',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppPadding.large),
          const Text(
            'Seleccione una de las opciones del menú inferior para gestionar:',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppPadding.extraLarge),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  context,
                  'Productos',
                  Icons.shopping_bag,
                  AppColors.primary,
                  () => _navigateToScreen(context, 1),
                ),
                _buildMenuCard(
                  context,
                  'Categorías',
                  Icons.category,
                  Colors.teal,
                  () => _navigateToScreen(context, 2),
                ),
                _buildMenuCard(
                  context,
                  'Proveedores',
                  Icons.people,
                  Colors.purple,
                  () => _navigateToScreen(context, 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
