import 'package:cloud_firestore/cloud_firestore.dart';

/* Interface for storing timestamp data. */
class TimeStampEntry {
  final Timestamp startTime;
  final Timestamp endTime;

  TimeStampEntry({required this.startTime, required this.endTime});

  factory TimeStampEntry.fromMap(Map<String, dynamic> data) {
    return TimeStampEntry(
      startTime: data['StartTime'],
      endTime: data['EndTime'],
    );
  }
}
