import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        String profilePictureUrl = userProvider.getProfilePictureUrl();

        if (profilePictureUrl == 'No Profile Picture Found') {
          return CircleAvatar(
            radius: 50,
            backgroundColor: AppColours.avatarBackgroundColor,
            child: Icon(
              Icons.person,
              size: 80,
              color: AppColours.avatarForegroundColor,
            ),
          );
        } else {
          return CircleAvatar(
            radius: 50,
            backgroundColor: AppColours.avatarBackgroundColor,
            backgroundImage: NetworkImage(profilePictureUrl),
            onBackgroundImageError: (error, stackTrace) {
              print('Error loading profile picture: $error');
            },
          );
        }
      },
    );
  }
}