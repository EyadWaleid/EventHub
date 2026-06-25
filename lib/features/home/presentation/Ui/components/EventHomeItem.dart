import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:flutter/material.dart';

class EventHomeItem extends StatelessWidget {
  const EventHomeItem({
    super.key,
    required this.image,
    required this.eventName,
    required this.data,
    required this.location,
  });

  final String image;
  final String eventName;
  final String data;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      width: 240,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 131,
                  width: 218,
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.split(" ")[0],
                          style: AppTextStyles.fontStyle14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColours.pinkColour,
                          ),
                        ),
                        Text(
                          data.split(" ")[1],
                          style: AppTextStyles.fontStyle12.copyWith(
                            color: AppColours.pinkColour,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: Icon(Icons.bookmark,color: AppColours.pinkColour,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Text(
              eventName,
              style: AppTextStyles.fontStyle18.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Text(
              "+20",
              style: AppTextStyles.fontStyle12.copyWith(
                color: AppColours.trinaryColour,
              ),
            ),
            Row(
              children: [
                Icon(Icons.pin_drop),
                SizedBox(width: 5),
                Text(
                  location,
                  style: AppTextStyles.fontStyle14.copyWith(
                    color: AppColours.greyColour,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
