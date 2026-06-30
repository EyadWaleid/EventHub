import 'package:flutter/material.dart';

class CustomeOnboarding extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final int currentPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const CustomeOnboarding({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF5865F2),
            borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: onSkip,
                    child: const Text('Skip',
                        style: TextStyle(color: Colors.white)),
                  ),
                  _buildDots(),
                  TextButton(
                    onPressed: onNext,
                    child: const Text('Next',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      children: List.generate(
        3,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}