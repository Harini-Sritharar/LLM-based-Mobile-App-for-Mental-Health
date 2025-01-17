import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/* This widget is called from within the PreCourseList widget to handle the case when all prerequisites for a course have been completed. */
class EmptyPreRequisites extends StatelessWidget {
  const EmptyPreRequisites({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SvgPicture.asset(
        'assets/icons/tick.svg',
        width: 36.0,
      ),
      SvgPicture.asset(
        'assets/icons/profile/book.svg',
        width: 26.0,
      ),
      SizedBox(width: 8),
      Text("No other course needed", style: TextStyle(fontSize: 16)),
    ]));
  }
}
