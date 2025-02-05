import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/expandable_text.dart';

/* This widget is called from within the PreCourseList widget to handle the case when all prerequisites for a course have not been completed.

Input Parameters:
- `preRequisitesList`: A List of Strings containing the names of courses not yet completed.
 */
class ListAllPreRequisites extends StatelessWidget {
  final List<String> preRequisitesList;

  const ListAllPreRequisites({
    super.key,
    required this.preRequisitesList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Yet to complete:",
          style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8), // Add some space between title and list of prerequisites
        Wrap(
          spacing: 8.0, // Space between items
          runSpacing: 4.0, // Space between lines
          direction: Axis.vertical,
          children: preRequisitesList.map((preReq) {
            return Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60), // Ensure text is not wider than screen width
              child: Text(
                "- $preReq",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                overflow: TextOverflow.clip, // Avoid overflow if text is too long
                softWrap: true,  // Allow text to wrap to the next line
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}