import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:flutter/material.dart';

class LoginWithBtn extends StatelessWidget {
  const LoginWithBtn({super.key, required this.label,required this.assetPath});
  final String label;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 271,
        child: MaterialButton(
          onPressed: () {},
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColours.whiteColour, width:2)
          ),
          color: Colors.white,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assetPath, width: 24, height: 24),
              SizedBox(width: 10),
              Text(
                label,
                style: AppTextStyles.fontStyle16.copyWith(
                  color: AppColours.blackColour,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
