import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ModelClass/food_model.dart';
import '../Widgets/big_text.dart';
import '../Widgets/dimensions.dart';
import '../Widgets/icon_text_widget.dart';
import '../Widgets/small_text.dart';

class AppColumn extends StatelessWidget {
  final String text;
  final FoodItem? foodItem; // Optional parameter for popular page

  const AppColumn({super.key, required this.text, this.foodItem});

  @override
  Widget build(BuildContext context) {
    // 🎨 Theme colors
    final Color primary = const Color(0xFF6A4C93);
    final Color secondary = const Color(0xFFC06C84);
    final Color background = const Color(0xFFF8F4E6);
    final Color accent = const Color(0xFFF67280);
    final Color textColor = const Color(0xFF1A1A2E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(color: textColor, text: text, size: Dimensions.fontSize26(context)),
        const SizedBox(height: 10),

        Row(
          children: [
            Wrap(
              children: List.generate(
                5,
                    (index) => Icon(
                  Icons.star,
                  color: accent,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SmallText(color: secondary, text: "4.5"),
            const SizedBox(width: 10),
            SmallText(color: secondary, text: "3285"),
            const SizedBox(width: 10),
            SmallText(color: secondary, text: "Comments"),
          ],
        ),
        const SizedBox(height: 10),

        // If foodItem is provided
        if (foodItem != null) ...[
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: IconTextWidget(
                    iconcolor: secondary,
                    text: foodItem!.quality,
                    iconData: Icons.circle_sharp,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconTextWidget(
                    iconcolor: primary,
                    text: foodItem!.distance,
                    iconData: Icons.location_on,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconTextWidget(
                    iconcolor: accent,
                    text: foodItem!.time,
                    iconData: Icons.access_time_rounded,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          // Default row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconTextWidget(
                iconcolor: secondary,
                text: "Normal",
                iconData: Icons.circle_sharp,
              ),
              IconTextWidget(
                iconcolor: primary,
                text: "1.7 km",
                iconData: Icons.location_on,
              ),
              IconTextWidget(
                iconcolor: accent,
                text: "32 min",
                iconData: Icons.access_time_rounded,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
