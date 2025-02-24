import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:llm_based_sat_app/models/calendar/calendar_exercise_entry.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import '../../widgets/custom_app_bar.dart';

// TODO: Cache the entries for given date and update after a new one is done in courses if today's
// TODO: Have a call to firebase each time a new date is requested
class CalendarPage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const CalendarPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();

  // Dummy data: Map of dates to list of completed exercises
  final List<CalendarExerciseEntry> allCompletedExercises = [
    CalendarExerciseEntry(
        courseName: "Self-Attachment",
        exerciseName: "Exercise A",
        duration: "8 minutes",
        notes:
            "At first, I struggled to connect with my childhood self, but after more focused practice, I managed to create a deep bond with my inner child, which was very satisfying.",
        date: DateTime(2025, 2, 24)),
        CalendarExerciseEntry(
        courseName: "Self-Attachment",
        exerciseName: "Exercise A",
        duration: "8 minutes",
        notes:
            "At first, I struggled to connect with my childhood self, but after more focused practice, I managed to create a deep bond with my inner child, which was very satisfying.",
        date: DateTime(2025, 2, 24))
  ];

  // Function to pick a date
  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023), // Determine the firstDate
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // Filter exercises by selected date
    List<CalendarExerciseEntry> exercises = allCompletedExercises
        .where((entry) =>
            DateFormat('yyyy-MM-dd').format(entry.date) == formattedDate)
        .toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: "InvinciMind",
        onItemTapped: widget.onItemTapped,
        selectedIndex: widget.selectedIndex,
        backButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () =>
                  _pickDate(context), // Triggers date picker when tapped
              child: Container(
                width: double.infinity, // Stretch full width
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12), // Padding for spacing
                decoration: BoxDecoration(
                  color: AppColours.brandBlueMinusFour, // Background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Row(
                  children: [
                    // Calendar Icon
                    SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      height: 24,
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColours.neutralGreyMinusOne,
                        BlendMode.srcIn,
                      ),
                    ),
                    Spacer(),
                    // Date Picker Text
                    Text(
                      DateFormat('dd MMM yyyy').format(_selectedDate),
                      style: const TextStyle(
                          fontSize: 16, color: AppColours.neutralGreyMinusOne),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Display Exercises
            exercises.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return Card(
                          color: AppColours.brandBlueMinusThree,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Row(children: [
                              Text(
                                exercise.exerciseName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColours.brandBlueMain),
                              ),
                              Spacer(),
                              Text(
                                "[${exercise.courseName}]",
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColours.supportingYellowMain,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Duration: ${exercise.duration}",
                                    style: const TextStyle(fontSize: 14)),
                                const Text(
                                  "Notes:",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  exercise.notes,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text(
                      "No exercises completed on this date.",
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
