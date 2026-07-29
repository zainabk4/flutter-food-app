import 'package:flutter/cupertino.dart';

class BigText extends StatelessWidget {

  Color? color;
  final String text;
  TextOverflow textOverflow;
  double size;

  BigText({
    super.key,
    this.textOverflow = TextOverflow.ellipsis,
    required this.color,
    this.size = 20,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: textOverflow,
      style: TextStyle(color: color, fontWeight: FontWeight.w400, fontSize: size ),
    );
  }
}
