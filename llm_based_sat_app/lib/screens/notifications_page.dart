import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/main_layout.dart'; // Import MainLayout

/// A StatefulWidget for managing and displaying notification settings.
/// Allows users to enable or disable various types of notifications.
class NotificationsPage extends StatefulWidget {
  final Function(int)
      onItemTapped; // Callback function to update the navbar index.
  final int selectedIndex; // Current selected index in the navigation bar.

  NotificationsPage({
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // State variables for managing the toggle switches.
  bool upcomingTasks = true;
  bool missedTasks = true;
  bool reminders = false;
  bool dailyMotivation = true;
  bool newCourses = false;
  bool tips = false;
  bool appUpdates = false;
  bool specialOffers = true;

  /// Builds the main UI of the notifications page.
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: widget.selectedIndex,
      body: Container(
        color: Colors.white, // Background color for the page.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom app bar at the top of the page.
              CustomAppBar(
                title: "Notifications",
                onItemTapped: widget.onItemTapped,
                selectedIndex: widget.selectedIndex,
              ),
              const SizedBox(height: 10),
              // Instructional text for the user.
              const Text(
                "Enable the notifications you want to receive.",
                style: TextStyle(color: AppColours.neutralGreyMinusOne),
              ),
              const SizedBox(height: 20),
              // List of notification toggles.
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationToggle(
                      title: "Upcoming tasks",
                      value: upcomingTasks,
                      onChanged: (val) {
                        setState(() {
                          upcomingTasks = val;
                        });
                      },
                    ),
                    _buildNotificationToggle(
                      title: "Missed tasks",
                      value: missedTasks,
                      onChanged: (val) {
                        setState(() {
                          missedTasks = val;
                        });
                      },
                    ),
                    _buildNotificationToggle(
                      title: "Reminders",
                      value: reminders,
                      onChanged: (val) {
                        setState(() {
                          reminders = val;
                        });
                      },
                    ),
                    _buildNotificationToggle(
                      title: "Daily motivation",
                      value: dailyMotivation,
                      onChanged: (val) {
                        setState(() {
                          dailyMotivation = val;
                        });
                      },
                    ),
                    _buildNotificationToggle(
                      title: "New courses",
                      value: newCourses,
                      onChanged: (val) {
                        setState(() {
                          newCourses = val;
                        });
                      },
                    ),
                    _buildNotificationToggle(
                      title: "Tips",
                      value: tips,
                      onChanged: (val) {
                        setState(() {
                          tips = val;
                        });
                      },
                    ),
                    _buildNotificationToggle(
                      title: "App updates",
                      value: appUpdates,
                      onChanged: (val) {
                        setState(() {
                          appUpdates = val;
                        });
                      },
                    ),
                    _buildNotificationToggle(
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

  /// Helper method to build a single notification toggle widget.
  ///
  /// [title]: The title of the toggle.
  /// [value]: The current state of the toggle (on/off).
  /// [onChanged]: Callback for when the toggle state changes.
  Widget _buildNotificationToggle({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: AppColours.neutralGreyMinusOne),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColours.brandBlueMinusThree, // Thumb color when active.
      activeTrackColor: AppColours.brandBlueMain, // Track color when active.
      inactiveThumbColor: const Color(0xFFB0BEC5), // Thumb color when inactive.
      inactiveTrackColor: const Color(0xFFE0E0E0), // Track color when inactive.
    );
  }
}
