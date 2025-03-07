import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:llm_based_sat_app/firebase/firebase_calendar.dart';
import 'package:llm_based_sat_app/models/calendar/calendar_exercise_entry.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_app_bar.dart';

/// Class to represent Calendar Page
class CalendarPage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;
  @visibleForTesting
  final getExercisesByDateOverride;

  const CalendarPage(
      {super.key,
      required this.onItemTapped,
      required this.selectedIndex,
      this.getExercisesByDateOverride});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<List<CalendarExerciseEntry>> Function(String, DateTime)
      _getExercisesByDate;
  // The currently selected date for the calendar page
  DateTime _selectedDate = DateTime.now();

  // List to hold all completed exercises for the user
  List<CalendarExerciseEntry> allCompletedExercises = [];

  // Instance of UserProvider to fetch user-specific data like UID
  late UserProvider userProvider;

  // Variable to store the UID of the current user
  late String uid;

  @override
  void initState() {
    super.initState();
    _getExercisesByDate =
        widget.getExercisesByDateOverride ?? getExercisesByDate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access UserProvider here to get user data (UID)
    userProvider = Provider.of<UserProvider>(context);
    uid = userProvider.getUid(); // Get the user's UID

    // Fetch exercises when the page loads
    _fetchExercises();
  }

  // Function to fetch exercises from Firebase based on the selected date
  Future<void> _fetchExercises() async {
    // Fetch exercises for the given UID and date
    List<CalendarExerciseEntry> result =
        await _getExercisesByDate(uid, _selectedDate);

    // Check if the widget is still mounted before updating the state
    if (!mounted) return;

    // Update the list of completed exercises
    setState(() {
      allCompletedExercises = result;
    });
  }

  // Function to open the date picker to select a date
  Future<void> _pickDate(BuildContext context) async {
    // Show the date picker to select a date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023), // Start date for the picker
      lastDate: DateTime.now(), // End date for the picker
    );

    // Check if the widget is still mounted before updating state
    if (!mounted) return;

    // If a valid date is picked and it is different from the current date
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate; // Update selected date
      });
      // Fetch exercises for the new selected date
      _fetchExercises();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the selected date to 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // Filter the exercises by the selected date
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
            // GestureDetector that triggers date picker when tapped
            GestureDetector(
              onTap: () => _pickDate(context), // Open date picker when tapped
              child: Container(
                width: double.infinity, // Take up full width
                padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12), // Padding inside the container
                decoration: BoxDecoration(
                  color: AppColours.brandBlueMinusFour, // Background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Row(
                  children: [
                    // Calendar icon using SVG
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
                    // Display the selected date in the format 'dd MMM yyyy'
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

            // Display exercises for the selected date
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
                              // Exercise name
                              Text(
                                exercise.exerciseName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColours.brandBlueMain),
                              ),
                              Spacer(),
                              // Course name in brackets
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
                                // Duration of the exercise
                                Text("Duration: ${exercise.duration}",
                                    style: const TextStyle(fontSize: 14)),
                                const Text(
                                  "Notes:",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                // Notes for the exercise, if any
                                Text(
                                  exercise.notes.isEmpty
                                      ? "No notes added"
                                      : exercise.notes,
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
