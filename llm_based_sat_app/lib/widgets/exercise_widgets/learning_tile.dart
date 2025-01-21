import 'package:flutter/material.dart';

class LearningTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subject;
  final String content;

  const LearningTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.subject,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17, 
          fontWeight: FontWeight.w400,
          color: Color(0xFF123659),
          fontFamily: 'Roboto',
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF123659)),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(subject),
              content: Text(content),
              actions: <Widget>[
              ],
            );
          },
        );
      },
    );
  }
}