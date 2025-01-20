import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

/* A widget that displays a text with a "READ MORE" / "READ LESS" toggle functionality. It truncates the text to a maximum of 4 lines by default and expands to show the full text when toggled. 

Input Parameters:
- `text`: A String containing the content to display.
*/

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({
    super.key,
    required this.text,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : 4,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: AppColours.neutralGreyMinusFour),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "READ LESS" : "READ MORE",
            style: const TextStyle(
              color: AppColours.brandBlueMain,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
