import 'package:flutter/material.dart';

class OverlappingAvatars extends StatelessWidget {
  const OverlappingAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    final avatars = [
      'https://i.pravatar.cc/150?img=1',
      'https://i.pravatar.cc/150?img=2',
      'https://i.pravatar.cc/150?img=3',
    ];

    const double radius = 18;
    const double overlap = 12;
    const double offset = (radius * 2) - overlap;

    final totalWidth = (radius * 2) + (avatars.length - 1) * offset;

    return SizedBox(
      height: radius * 2,
      width: totalWidth,
      child: Stack(
        children: List.generate(avatars.length, (index) {
          return Positioned(
            left: index * offset,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: CircleAvatar(
                radius: radius,
                backgroundImage: NetworkImage(avatars[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}