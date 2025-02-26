import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/main_layout.dart'; // Import MainLayout

/// A StatefulWidget for managing and displaying notification settings.
/// Allows users to enable or disable various types of notifications.
class NotificationSettingsPage extends StatefulWidget {
  final Function(int)
      onItemTapped; // Callback function to update the navbar index.
  final int selectedIndex; // Current selected index in the navigation bar.

  NotificationSettingsPage({
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  List<bool> notificationSettings = List.filled(8, false);
  late UserProvider userProvider;

  late String uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    userProvider = Provider.of<UserProvider>(context);
    uid = userProvider.getUid();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final notificationPreferences = await getNotificationPreferences(uid);
    if (!mounted) return;
    setState(() {
      notificationSettings = notificationPreferences ?? List.filled(8, false);
    });
  }

  Future<void> _saveNotificationSettings() async {
    await saveNotificationPreferences(uid, notificationSettings);
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
                style: TextStyle(color: AppColours.neutralGreyMinusOne),
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

  final List<String> _notificationTitles = [
    "Daily tasks",
    "Daily practice",
    "Score Updates",
    "Daily motivation",
    "New courses",
    "Tips",
    "App updates",
    "Special offers",
  ];
}
