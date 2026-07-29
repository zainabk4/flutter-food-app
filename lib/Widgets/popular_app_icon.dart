import 'package:flutter/cupertino.dart';

class PopularAppIcon extends StatelessWidget {

  final IconData iconData;
  final Color bgColor;
  final Color iconColor;
  final double size;

  const PopularAppIcon({super.key,
    required this.iconData,
    this.bgColor = const Color(0xFFfcf4e4),
    this.iconColor = const Color(0xFF756d54),
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: bgColor,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 16,
      ),
    );
  }
}
