import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../contacts/contacts_screen.dart';
import '../favorites/favorites_screen.dart';
import '../../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _fabAnimationController;

  final List<Widget> _screens = [
    const ContactsScreen(),
    const FavoritesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fabColor = colorScheme.primaryContainer;
    final fabIconColor = colorScheme.onPrimaryContainer;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens.map((screen) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: screen,
          );
        }).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.contacts_outlined),
            selectedIcon: const Icon(Icons.contacts),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ).animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, end: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _fabAnimationController.reverse();
          await Navigator.pushNamed(context, AppRoutes.addContact);
          if (mounted) {
            _fabAnimationController.forward();
          }
        },
        backgroundColor: fabColor,
        foregroundColor: fabIconColor,
        elevation: 0,
        child: const Icon(Icons.add),
      ).animate(controller: _fabAnimationController)
        .scale(
          duration: 200.ms,
          curve: Curves.easeOutBack,
        )
        .then()
        .shimmer(
          duration: 1800.ms,
          color: fabIconColor.withOpacity(0.3),
        ),
    );
  }
} 