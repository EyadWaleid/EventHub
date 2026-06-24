import 'package:eventhub/features/onBoard/Ui/CustomeOnboarding.dart';
import 'package:eventhub/generated/assets.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'imagePath': Assets.assets.images.png.onboardOne.path ,
      'title': 'Explore Upcoming and Nearby Events',
      'description': 'In publishing and graphic design, Lorem is a placeholder text commonly',
    },
    {
      'imagePath': Assets.assets.images.png.onboardTwo.path,
      'title': 'We Have Modern Events Calendar Feature',
      'description': 'In publishing and graphic design, Lorem is a placeholder text commonly',
    },
    {
      'imagePath': Assets.assets.images.png.onboardThree.path,
      'title': 'To Look Up More Events or Activities Nearby By Map',
      'description': 'In publishing and graphic design, Lorem is a placeholder text commonly',
    },
  ];

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToSignIn();
    }
  }

  void _goToSignIn() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) => CustomeOnboarding(
                imagePath: _pages[index]['imagePath']!,
                title: _pages[index]['title']!,
                description: _pages[index]['description']!,
                currentPage: _currentPage,
                onNext: _goToNextPage,
                onSkip: _goToSignIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}