import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/breeds_page.dart';
import '../pages/voting_page.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/voting');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinar el índice basado en la ruta actual
    final currentLocation = GoRouterState.of(context).fullPath;
    if (currentLocation != null) {
      if (currentLocation.contains('/voting')) {
        _selectedIndex = 1;
      } else if (currentLocation.contains('/home')) {
        _selectedIndex = 0;
      }
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Razas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: 'Votación',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}