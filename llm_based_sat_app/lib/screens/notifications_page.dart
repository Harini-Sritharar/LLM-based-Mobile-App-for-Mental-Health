import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/main_layout.dart'; // Import MainLayout

/// A StatefulWidget for managing and displaying notification settings.
/// Allows users to enable or disable various types of notifications.
class NotificationsPage extends StatefulWidget {
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFFCEDFF2);
  static const Color arrowColor = Color(0xFF1C548C);

  final Function(int) onItemTapped;
  final int selectedIndex;

  NotificationsPage({
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<bool> notificationSettings = List.filled(8, false);

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationSettings = List.generate(
          8, (index) => prefs.getBool('notification_$index') ?? false);
    });
  }

  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < notificationSettings.length; i++) {
      await prefs.setBool('notification_$i', notificationSettings[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: widget.selectedIndex,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: "Notifications",
                onItemTapped: widget.onItemTapped,
                selectedIndex: widget.selectedIndex,
              ),
              const SizedBox(height: 10),
              const Text(
                "Enable the notifications you want to receive.",
                style: TextStyle(color: NotificationsPage.primaryTextColor),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: notificationSettings.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationToggle(
                      title: _notificationTitles[index],
                      value: notificationSettings[index],
                      onChanged: (val) {
                        setState(() {
                          notificationSettings[index] = val;
                        });
                        _saveNotificationSettings();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: NotificationsPage.primaryTextColor),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: NotificationsPage.arrowColor,
      activeTrackColor: NotificationsPage.primaryButtonColor,
      inactiveThumbColor: const Color(0xFFB0BEC5),
      inactiveTrackColor: const Color(0xFFE0E0E0),
    );
  }

  final List<String> _notificationTitles = [
    "Upcoming tasks",
    "Missed tasks",
    "Reminders",
    "Daily motivation",
    "New courses",
    "Tips",
    "App updates",
    "Special offers",
  ];
}
