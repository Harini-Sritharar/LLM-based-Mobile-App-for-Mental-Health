import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.notification_add),
            onPressed: () {
              print("Works");
            },
          ),
        ],
      )
    );
  }
}