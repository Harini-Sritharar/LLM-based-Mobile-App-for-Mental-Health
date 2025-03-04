import 'package:cloud_firestore/cloud_firestore.dart';

/// Interface for storing timestamp data, representing the start and end times
/// of an event or activity. This is typically used to track the duration or
/// time period of specific actions in the app.
class TimeStampEntry {
  /// The start time of the event or activity, represented as a [Timestamp].
  final Timestamp startTime;

  /// The end time of the event or activity, represented as a [Timestamp].
  final Timestamp endTime;

  /// Constructor to initialize the [TimeStampEntry] with the provided start
  /// and end timestamps.
  ///
  /// [startTime] - The start time of the event, stored as a [Timestamp].
  /// [endTime] - The end time of the event, stored as a [Timestamp].
  TimeStampEntry({required this.startTime, required this.endTime});

  /// A factory method to create a [TimeStampEntry] from a map of data.
  ///
  /// [data] - A map of key-value pairs containing the timestamp data. The keys
  /// must be 'StartTime' and 'EndTime', corresponding to the event's start and
  /// end times, respectively.
  ///
  /// Returns a new [TimeStampEntry] instance with the start and end times
  /// populated from the provided [data] map.
  factory TimeStampEntry.fromMap(Map<String, dynamic> data) {
    return TimeStampEntry(
      startTime: data['StartTime'], // Extracting the start time from the map.
      endTime: data['EndTime'], // Extracting the end time from the map.
    );
  }
}
