import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/main_layout.dart'; // Import MainLayout

class NotificationsPage extends StatefulWidget {
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFFCEDFF2);
  static const Color arrowColor = Color(0xFF1C548C);

  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index

  NotificationsPage({required this.onItemTapped, required this.selectedIndex});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // State variables for toggle switches
  bool upcomingTasks = true;
  bool missedTasks = true;
  bool reminders = false;
  bool dailyMotivation = true;
  bool newCourses = false;
  bool tips = false;
  bool appUpdates = false;
  bool specialOffers = true;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: widget.selectedIndex,
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                  title: "Notifications",
                  onItemTapped: widget.onItemTapped,
                  selectedIndex: widget.selectedIndex),
              SizedBox(height: 10),
              Text(
                "Enable the notifications you want to receive.",
                style: TextStyle(color: NotificationsPage.primaryTextColor),
              ),
              SizedBox(height: 20),
              // Notification toggles
              Expanded(
                child: ListView(
                  children: [
                    buildNotificationToggle(
                      title: "Upcoming tasks",
                      value: upcomingTasks,
                      onChanged: (val) {
                        setState(() {
                          upcomingTasks = val;
                        });
                      },
                    ),
                    buildNotificationToggle(
                      title: "Missed tasks",
                      value: missedTasks,
                      onChanged: (val) {
                        setState(() {
                          missedTasks = val;
                        });
                      },
                    ),
                    buildNotificationToggle(
                      title: "Reminders",
                      value: reminders,
                      onChanged: (val) {
                        setState(() {
                          reminders = val;
                        });
                      },
                    ),
                    buildNotificationToggle(
                      title: "Daily motivation",
                      value: dailyMotivation,
                      onChanged: (val) {
                        setState(() {
                          dailyMotivation = val;
                        });
                      },
                    ),
                    buildNotificationToggle(
                      title: "New courses",
                      value: newCourses,
                      onChanged: (val) {
                        setState(() {
                          newCourses = val;
                        });
                      },
                    ),
                    buildNotificationToggle(
                      title: "Tips",
                      value: tips,
                      onChanged: (val) {
                        setState(() {
                          tips = val;
                        });
                      },
                    ),
                    buildNotificationToggle(
                      title: "App updates",
                      value: appUpdates,
                      onChanged: (val) {
                        setState(() {
                          appUpdates = val;
                        });
                      },
                    ),
                    buildNotificationToggle(
                      title: "Special offers",
                      value: specialOffers,
                      onChanged: (val) {
                        setState(() {
                          specialOffers = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a notification toggle
  Widget buildNotificationToggle({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: Color(0xFF687078))),
      value: value,
      onChanged: onChanged,
      activeColor: Color(0xFF1C548C), // Thumb color when active
      activeTrackColor: Color(0xFFCEDFF2), // Trail color when active
      inactiveThumbColor: Color(0xFFB0BEC5), // Subtle gray thumb for inactive
      inactiveTrackColor: Color(0xFFE0E0E0), // Light gray trail for inactive
    );
  }
}
