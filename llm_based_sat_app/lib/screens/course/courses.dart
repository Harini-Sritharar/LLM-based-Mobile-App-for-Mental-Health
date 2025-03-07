import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'courses_helper.dart';

/* This file defines the Courses Screen, which displays a list of available courses. It fetches course data asynchronously and displays them as selectable cards.
Parameters:
- [onItemTapped]: Callback function triggered when a bottom navigation item is tapped.
- [selectedIndex]: The index of the currently selected navigation item. */
class Courses extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const Courses({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  late UserProvider userProvider;
  late String uid;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access Provider here
    userProvider = Provider.of<UserProvider>(context);
    uid = userProvider.getUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Courses",
        onItemTapped: widget.onItemTapped,
        selectedIndex: widget.selectedIndex,
        backButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a course to start.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Widget>>(
                future: generateCourseCards(
                    widget.onItemTapped, widget.selectedIndex, uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for data
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData ||
                      snapshot.data!.isEmpty ||
                      snapshot.hasError) {
                    // Handle the case where there is no data
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 60,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'We’re having issues fetching courses.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please try again in a bit. If the issue persists, contact our team for assistance.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  // Return the ListView with the generated widgets
                  return ListView(children: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
