import 'package:flutter/material.dart';
import 'package:neurolog/models/log.dart';
import 'package:isar/isar.dart';
import 'package:neurolog/models/log_entry.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:health/health.dart';

class LogProvider extends ChangeNotifier {
  // Map of hour to number of migraines. Used by the migraine_graph to show
  // at what time of day does the user start their migraines.
  final Map<int, int> timeFreq = {};

  // Map of the number of steps the user had for the past week.
  final Map<String, int> _weeklySteps = {};

  // Log object to store and handle the user's entries
  final Log _log;

  // Event Controller to handle the events in CalendarView
  final EventController calendar;
  int _todaySteps = 0;
  int get todaySteps => _todaySteps;
  LogProvider({required Isar isar, required this.calendar})
    : _log = Log(isar: isar, calendar: calendar) {
    fetchWeeklySteps();
  }

  // Function that counts all of the log entries to instantiate timeFreq.
  // This should be called when the Log is initialized but after the entries
  // have been loaded by Isar.
  Map getMappings() {
    final entries = _log.entries;
    for (var entry in entries) {
      int hour = entry.start.hour;
      if (timeFreq.containsKey(hour)) {
        timeFreq.addAll({hour: timeFreq[hour]! + 1});
      } else {
        timeFreq.addAll({hour: 1});
      }
    }

    return timeFreq;
  }

  // Call to the Health API to get the user's steps
  Future<void> fetchWeeklySteps() async {
    final health = Health();
    await health.configure();

    final requested = await health.requestAuthorization([HealthDataType.STEPS]);
    if (!requested) return;

    // Check each week day a week since the current date
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final start = DateTime(day.year, day.month, day.day);
      final end = start.add(Duration(days: 1));
      final steps = await health.getTotalStepsInInterval(start, end);
      // Get the label to represent the day of the week
      final label =
          ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][day.weekday % 7];
      _weeklySteps[label] = steps ?? 0;
    }

    // Notify listeners to update their views based on new information collected
    notifyListeners();
  }

  // Call to the Health API to get the user's steps for today
  Future<void> fetchTodaySteps() async {
    // Connect to the Health API
    final health = Health();
    await health.configure();

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    // Request authorization from user to get data from their device
    final requested = await health.requestAuthorization([HealthDataType.STEPS]);
    if (requested) {
      // If access if granted, update steps and update listeners to update views
      // where applicable.
      _todaySteps = (await health.getTotalStepsInInterval(midnight, now))!;
      notifyListeners();
    }
  }

  // Allows the view to create or update an entry. This request is forwarded to
  // to the log, which handles the work. The change is notified to the
  // provider's listeners to update the views to reflect the new entry.
  void upsertLogEntry(LogEntry entry) {
    // Update the Log to create or update the entry
    _log.upsertEntry(entry);
    // Notify listeners to update the views with the removed entry
    notifyListeners();
  }

  // Get to get _timeFreq
  Map<int, int> get weeklyMigraineFrequency {
    return Map<int, int>.from(_log.timeFreq);
  }

  // Getter to get _weeklySteps
  Map<String, int> get weeklySteps => _weeklySteps;
}
