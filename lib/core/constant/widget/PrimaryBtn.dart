import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:flutter/material.dart';

class PrimaryBtn extends StatelessWidget {
   PrimaryBtn({super.key, required this.label, this.color, this.textColor, this.width, required this.isImage, this.function });
  final String label;
  final Color? color;
  final Color? textColor;
  final double? width;
  final bool isImage;
  void Function()? function;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width??271,
        child: MaterialButton(
          onPressed:function??(){
          },
          height: 58,
          padding: const EdgeInsets.symmetric(vertical: 20),
          elevation: 2,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,),
          color:AppColours.primaryColour,
          child:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: AppTextStyles.fontStyle16.copyWith(color: textColor ?? Colors.white),
                    ),
                  ),
                ),
                if (isImage)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColours.secondeColour,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ),
              ],
            ),
          ),

        )) ;
  }
}
