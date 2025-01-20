import 'package:flutter/material.dart';

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
        Text("Yet to complete:", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w600)),
        for (var preReq in preRequisitesList)
          Row(children: [
            Text(preReq, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ])
      ],
    );
  }
}
