import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/features/home/presentation/Ui/components/EventHomeItem.dart';
import 'package:eventhub/generated/assets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _selectedNavIndex = 0;

  static const _categories = [
    _Category('Sports', Icons.sports_basketball, Color(0xFFED5B4F)),
    _Category('Music', Icons.music_note, Color(0xFFF0954A)),
    _Category('Food', Icons.restaurant, Color(0xFF3CB99A)),
    _Category('Art', Icons.palette, Color(0xFF5669FF)),
  ];

  static const _events = [
    _EventData('Jo Malone', '10 JUNE', 'Radius Gallery'),
    _EventData('Book Fair', '14 JUN', 'Expo Center'),
    _EventData('Jazz Night', '20 JUN', 'Blue Note'),
    _EventData('Art Show', '25 JUN', 'City Gallery'),
  ];

  static const double _headerHeight = 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 56),
                      _buildUpcomingEvents(),
                      const SizedBox(height: 24),
                      _buildInviteBanner(),
                      const SizedBox(height: 24),
                      _buildNearbyYou(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: _headerHeight - 24,
            left: 0,
            right: 0,
            child: _buildCategories(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Container(
      height: _headerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColours.purpleColour,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _menuLine(20),
                      const SizedBox(height: 4),
                      _menuLine(14),
                      const SizedBox(height: 4),
                      _menuLine(20),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('Current Location',
                              style: AppTextStyles.fontStyle12.copyWith(
                                  color: Colors.white.withOpacity(0.8))),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down,
                              color: Colors.white.withOpacity(0.8), size: 16),
                        ],
                      ),
                      Text('New York, USA',
                          style: AppTextStyles.fontStyle16.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: Colors.white, size: 20),
                      ),
                      Positioned(
                        top: 6,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFF00D4FF), shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          Icon(Icons.search,
                              color: Colors.white.withOpacity(0.7), size: 20),
                          const SizedBox(width: 8),
                          Container(width: 1, height: 20,
                              color: Colors.white.withOpacity(0.4)),
                          const SizedBox(width: 10),
                          Text('Search...',
                              style: AppTextStyles.fontStyle14.copyWith(
                                  color: Colors.white.withOpacity(0.6))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.tune,
                            color: Colors.white.withOpacity(0.9), size: 18),
                        const SizedBox(width: 6),
                        Text('Filters',
                            style: AppTextStyles.fontStyle14.copyWith(
                                color: Colors.white.withOpacity(0.9))),
                      ],
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

  Widget _menuLine(double width) => Container(
    width: width,
    height: 2,
    decoration:
    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)),
  );

  Widget _buildCategories() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isSelected = _selectedCategoryIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? cat.color : cat.color.withOpacity(0.35),
                borderRadius: BorderRadius.circular(24),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(cat.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: AppTextStyles.fontStyle14.copyWith(
                      color: Colors.white,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('Upcoming Events',
                  style: AppTextStyles.fontStyle18.copyWith(
                      color: AppColours.blackColour, fontWeight: FontWeight.w800)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text('See All',
                        style: AppTextStyles.fontStyle14
                            .copyWith(color: AppColours.greyColour)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios,
                        size: 10, color: AppColours.greyColour),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final e = _events[index];
              return GestureDetector(
                onTap: () {
                  // TODO: navigate to EventDetailsScreen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped: ${e.name}'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EventHomeItem(
                    image: Assets.assets.images.png.eventImage.path,
                    eventName: e.name,
                    data: e.date,
                    location: e.location,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildInviteBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFCFF4F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Invite your friends',
                      style: AppTextStyles.fontStyle18.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColours.blackColour)),
                  const SizedBox(height: 4),
                  Text('Get \$20 for ticket',
                      style: AppTextStyles.fontStyle14
                          .copyWith(color: AppColours.greyColour)),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D4C8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      elevation: 0,
                    ),
                    child: Text('INVITE',
                        style: AppTextStyles.fontStyle14.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1)),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 0,
              child: Icon(Icons.card_giftcard,
                  size: 90,
                  color: const Color(0xFF00D4C8).withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('Nearby You',
                  style: AppTextStyles.fontStyle18.copyWith(
                      color: AppColours.blackColour, fontWeight: FontWeight.w800)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text('See All',
                        style: AppTextStyles.fontStyle14
                            .copyWith(color: AppColours.greyColour)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios,
                        size: 10, color: AppColours.greyColour),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _buildNearbyCard(i),
        ),
      ],
    );
  }

  Widget _buildNearbyCard(int index) {
    const items = [
      _NearbyData('Jo Malone London', '10 Jun · 4:00PM', 'Radius Gallery, London'),
      _NearbyData('Book Fair 2024', '14 Jun · 9:00AM', 'Expo Center, NYC'),
      _NearbyData('Jazz Night', '20 Jun · 7:00PM', 'Blue Note, NYC'),
    ];
    final item = items[index];

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tapped: ${item.name}'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 70,
                height: 70,
                child: Icon(Icons.event, color: AppColours.primaryColour, size: 32),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: AppTextStyles.fontStyle16.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColours.blackColour)),
                  const SizedBox(height: 4),
                  Text(item.date,
                      style: AppTextStyles.fontStyle12
                          .copyWith(color: AppColours.primaryColour)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: AppColours.greyColour),
                      const SizedBox(width: 4),
                      Text(item.location,
                          style: AppTextStyles.fontStyle12
                              .copyWith(color: AppColours.greyColour)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            _NavItem(
              icon: Icons.explore,
              label: 'Explore',
              selected: _selectedNavIndex == 0,
              onTap: () => setState(() => _selectedNavIndex = 0),
            ),
            _NavItem(
              icon: Icons.event,
              label: 'Events',
              selected: _selectedNavIndex == 1,
              onTap: () => setState(() => _selectedNavIndex = 1),
            ),
            const SizedBox(width: 40),
            _NavItem(
              icon: Icons.map_outlined,
              label: 'Map',
              selected: _selectedNavIndex == 2,
              onTap: () => setState(() => _selectedNavIndex = 2),
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
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

// ─── Nav item ─────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColours.primaryColour : AppColours.greyColour;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                fontFamily: 'Manrope',
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: selected ? 20 : 0,
              decoration: BoxDecoration(
                color: AppColours.primaryColour,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data classes ──────────────────────────────────────────────────────────

class _Category {
  final String label;
  final IconData icon;
  final Color color;
  const _Category(this.label, this.icon, this.color);
}

class _EventData {
  final String name, date, location;
  const _EventData(this.name, this.date, this.location);
}

class _NearbyData {
  final String name, date, location;
  const _NearbyData(this.name, this.date, this.location);
}