
import 'package:eventhub/lib/core/appColours/AppColours.dart';
import 'package:eventhub/lib/features/home/presentation/Ui/components/navItems.dart';
import 'package:eventhub/lib/features/home/presentation/Ui/components/navScreens/eventBody.dart';
import 'package:eventhub/lib/features/home/presentation/Ui/components/navScreens/homeBody.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  static const List<Widget> _screens = [
    HomeBody(),
    EventsScreenBody(),
    Center(child: Text('Map Screen')),
    Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _screens[_selectedNavIndex],
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.explore, label: 'Explore',
              selected: _selectedNavIndex == 0,
              onTap: () => setState(() => _selectedNavIndex = 0),
            ),
            NavItem(
              icon: Icons.event, label: 'Events',
              selected: _selectedNavIndex == 1,
              onTap: () => setState(() => _selectedNavIndex = 1),
            ),
            const SizedBox(width: 40),
            NavItem(
              icon: Icons.map_outlined, label: 'Map',
              selected: _selectedNavIndex == 2,
              onTap: () => setState(() => _selectedNavIndex = 2),
            ),
            NavItem(
              icon: Icons.person_outline, label: 'Profile',
              selected: _selectedNavIndex == 3,
              onTap: () => setState(() => _selectedNavIndex = 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColours.primaryColour,
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
