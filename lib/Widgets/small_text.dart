import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {

  Color? color;
  final String text;
  double size;
  double height;

  SmallText({
    super.key,
    this.color = const Color(0xFFccc7c5),
    this.size = 12,
    this.height = 1.5,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(color: color, fontWeight: FontWeight.w400, fontSize: size ),
    );
  }
}
