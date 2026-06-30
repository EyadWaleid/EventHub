import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/features/home/presentation/Ui/components/navItems.dart';
import 'package:eventhub/features/home/presentation/Ui/components/navScreens/eventBody.dart';
import 'package:eventhub/features/home/presentation/Ui/components/navScreens/homeBody.dart';
import 'package:eventhub/features/home/presentation/Ui/components/navScreens/profileBody.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;

  final List<Widget> _screens = const [
    HomeBody(),
    EventsScreenBody(),
    Center(child: Text('Map Screen')),
    ProfileBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _screens[_idx],
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColours.primaryColour,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
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
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          NavItem(icon: Icons.explore,      label: 'Explore', selected: _idx == 0, onTap: () => setState(() => _idx = 0)),
          NavItem(icon: Icons.event,        label: 'Events',  selected: _idx == 1, onTap: () => setState(() => _idx = 1)),
          const SizedBox(width: 40),
          NavItem(icon: Icons.map_outlined, label: 'Map',     selected: _idx == 2, onTap: () => setState(() => _idx = 2)),
          NavItem(icon: Icons.person_outline, label: 'Profile', selected: _idx == 3, onTap: () => setState(() => _idx = 3)),
        ]),
      ),
    );
  }
}
