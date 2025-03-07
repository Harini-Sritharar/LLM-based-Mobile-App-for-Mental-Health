import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:llm_based_sat_app/screens/score/questionnaire_assessments_page.dart';
import 'package:llm_based_sat_app/screens/score/questionnaire_page.dart';

void main() {
  testWidgets('QuestionnaireAssessmentsPage displays all questionnaires',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: QuestionnaireAssessmentsPage(),
    ));

    // Verify the title and instruction text that should be visible initially
    expect(find.text("Assessments"), findsOneWidget);
    expect(find.text("Complete all questionnaires to calculate your score"),
        findsOneWidget);

    // Find the scrollable widget
    final listViewFinder = find.byType(ListView);

    // Verify questionnaires one by one, scrolling to each
    final questionnaires = [
      'GAD-7',
      'PHQ-9',
      'PWB',
      'SOCS-S',
      'CPC-12R',
      'ERQ'
    ];
    for (final questionnaire in questionnaires) {
      // Scroll until we find the questionnaire
      await tester.dragUntilVisible(
        find.text(questionnaire),
        listViewFinder,
        const Offset(0, -100), // Scroll down
      );
      expect(find.text(questionnaire), findsOneWidget);
    }

    // Scroll back to the top
    await tester.dragUntilVisible(
      find.text('GAD-7'),
      listViewFinder,
      const Offset(0, 100), // Scroll up
    );

    // Verify descriptions by scrolling to each
    final descriptions = [
      'Anxiety',
      'Depression',
      'Wellbeing',
      'Self-Compassion',
      'Psychological Capital',
      'Reappraisal and Suppression'
    ];
    for (final description in descriptions) {
      await tester.dragUntilVisible(
        find.text(description),
        listViewFinder,
        const Offset(0, -100),
      );
      expect(find.text(description), findsOneWidget);
    }

    // Count all the assignment icons by scrolling through the list
    int assignmentIconCount = 0;
    for (final questionnaire in questionnaires) {
      await tester.dragUntilVisible(
        find.text(questionnaire),
        listViewFinder,
        const Offset(0, -100),
      );

      // Find assignment icon near this questionnaire
      if (find
          .descendant(
            of: find.ancestor(
              of: find.text(questionnaire),
              matching: find.byType(ListTile),
            ),
            matching: find.byIcon(Icons.assignment),
          )
          .evaluate()
          .isNotEmpty) {
        assignmentIconCount++;
      }
    }
    expect(assignmentIconCount, 6); // All should be uncompleted initially

    // Verify no check circle icons initially
    await tester.dragUntilVisible(
        find.text('GAD-7'), listViewFinder, const Offset(0, 100));
    expect(find.byIcon(Icons.check_circle), findsNothing);

    // Verify forward arrows by scrolling through the list
    int arrowIconCount = 0;
    for (final questionnaire in questionnaires) {
      await tester.dragUntilVisible(
        find.text(questionnaire),
        listViewFinder,
        const Offset(0, -100),
      );

      // Find arrow icon near this questionnaire
      if (find
          .descendant(
            of: find.ancestor(
              of: find.text(questionnaire),
              matching: find.byType(ListTile),
            ),
            matching: find.byIcon(Icons.arrow_forward_ios),
          )
          .evaluate()
          .isNotEmpty) {
        arrowIconCount++;
      }
    }
    expect(arrowIconCount, 6);

    // Verify progress indicator
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
