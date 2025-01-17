import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/courses_empty_prerequisite.dart';

class PreCourseList extends StatelessWidget {
  // Accepts three functions for each of the list items
  final void Function(BuildContext) onItem1Pressed;
  final void Function(BuildContext) onItem2Pressed;
  final void Function(BuildContext) onItem3Pressed;
  final List<String> prerequisites;

  const PreCourseList({
    Key? key,
    required this.onItem1Pressed,
    required this.onItem2Pressed,
    required this.onItem3Pressed,
    required this.prerequisites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading for the list
        const Text(
          "Pre-course tasks",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: Color(0xFF062240),
          ),
        ),
        const SizedBox(height: 10),

        GestureDetector(
          onTap: () => onItem1Pressed(context),
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/profile/book.svg',
                    width: 26.0,
                  ),
                  SizedBox(width: 8),
                  if (prerequisites.isEmpty) 
                    EmptyPreRequisites(),
                  if (prerequisites.isNotEmpty)
                    Text("works")
                ],
              )),
        ),
        const SizedBox(height: 8),

        // List item 2
        GestureDetector(
          onTap: () =>
              onItem2Pressed(context), // Trigger the function for Item 2
          child: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Item 2",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // List item 3
        GestureDetector(
          onTap: () =>
              onItem3Pressed(context), // Trigger the function for Item 3
          child: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Item 3",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
