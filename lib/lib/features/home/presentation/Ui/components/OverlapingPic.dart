import 'package:flutter/material.dart';

class OverlappingAvatars extends StatelessWidget {
  const OverlappingAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    final avatars = [
      'https://i.pravatar.cc/150?img=47',
      'https://i.pravatar.cc/150?img=12',
      'https://i.pravatar.cc/150?img=33',
    ];
    return SizedBox(
      width: 72,
      height: 36,
      child: Stack(
        children: List.generate(avatars.length, (i) {
          return Positioned(
            left: i * 20.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(avatars[i]),
              ),
            ),
          );
        }),
      ),
    );
  }
}