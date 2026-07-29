import 'package:flutter/cupertino.dart';
import 'package:food_app/Widgets/small_text.dart';

class IconTextWidget extends StatelessWidget {

  final Color iconcolor;
  final String text;
  final IconData iconData;

  const IconTextWidget({super.key,
    required this.iconcolor,
    required this.text,
    required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, color: iconcolor,),
        SizedBox(width: 5,),
        SmallText(text: text),
      ],
    );
  }
}
