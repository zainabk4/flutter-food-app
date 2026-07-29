import 'package:flutter/material.dart';
import 'package:food_app/Widgets/small_text.dart';

import 'dimensions.dart';


class ExpandableTextWidget extends StatefulWidget {
  final String text;

  const ExpandableTextWidget({super.key, required this.text});

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool hiddenText = true;
  bool showToggle = false;

  final int maxLinesWhenCollapsed = 4;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(fontSize: Dimensions.fontSize16(context), height: 1.5);
    final span = TextSpan(text: widget.text, style: defaultStyle);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tp = TextPainter(
          text: span,
          maxLines: maxLinesWhenCollapsed,
          textDirection: TextDirection.ltr,
        );

        tp.layout(maxWidth: constraints.maxWidth);
        showToggle = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              duration: Duration(milliseconds: 200),
              crossFadeState: hiddenText
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Text(
                widget.text,
                style: defaultStyle,
                maxLines: maxLinesWhenCollapsed,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                widget.text,
                style: defaultStyle,
              ),
            ),
            if (showToggle)
              InkWell(
                onTap: () {
                  setState(() {
                    hiddenText = !hiddenText;
                  });
                },
                child: Row(
                  children: [
                    SmallText(
                      text: hiddenText ? "Show more" : "Show less",
                      color: Color(0xFF9294cc),
                    ),
                    Icon(
                      hiddenText
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up,
                      color: Color(0xFF9294cc),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
