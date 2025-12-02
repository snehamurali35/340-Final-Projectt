import 'package:neurolog/models/log_entry.dart';
import 'package:isar/isar.dart';
import 'package:calendar_view/calendar_view.dart';

// This class handles all of the Logs that the user saves.
class Log {
  // Isar reference to persist the LogEntry data
  final Isar _isar;
  // Controller to handle calendar events in CalendarView
  final EventController _calendar;
  // List of LogEntrys that the user saved
  late final List<LogEntry> _entries;
  // Map of hour of day to number of migraines
  late final Map<int, int> timeFreq;
  //late final List<BarChartGroupData> _timeFreqGraph;

  Log({required Isar isar, required EventController calendar})
    : _isar = isar,
      _calendar = calendar {
    // On init, load persisted entries synchornously with Isar. This doesn't
    // have to be synchronous but it looks better in the view on load.
    _entries = isar.logEntrys.where().findAllSync();
    // When the entries are loaded, create calendar events to update the
    // CalendarView
    _calendar.addAll(_entries.map((entry) => entry.event).toList());

    //List<BarChartGroupData> graphData = [];
    timeFreq = {};
    // If we got data from Isar, fill in map data
    if (_entries.isNotEmpty) {
      for (LogEntry entry in entries) {
        final hour = entry.start.hour;
        timeFreq[hour] = (timeFreq[hour] ?? 0) + 1;
      }
    }
  }

  // Getter to get the list of entries. Creates a new list to prevent access
  // to _entries by reference (so that manipulations only occur inside Log).
  List<LogEntry> get entries {
    return List.from(_entries);
  }

  // Create or update a LogEntry. Updates _entries, Isar database, and Calendar.
  void upsertEntry(LogEntry entry) async {
    // Add or update the entry in Isar
    // We need to update Isar first so that we can get a unique Id if needed
    await _isar.writeTxn(() async {
      // Copy the entry but use the Id provided by Isar
      entry = LogEntry.withId(entry, id: await _isar.logEntrys.put(entry));
    });

    // Check if entry is already in _entries. If so, update it
    int i = 0;
    while (i < _entries.length) {
      LogEntry target = _entries[i];
      // Check by date rather than ID. This is because there should only be a
      // single LogEntry associated with each day.
      if (target.date.getDayDifference(entry.date) == 0) {
        // entry was found in entries, update it
        final oldHour = _entries[i].start.hour;
        final hour = entry.start.hour;
        timeFreq[oldHour] = (timeFreq[oldHour] ?? 1) - 1;
        timeFreq[hour] = (timeFreq[hour] ?? 0) + 1;
        _entries[i] = entry;
        _calendar.update(target.event, entry.event);
        break;
      }
      i++;
    }

    // Entry was not found in _entries, add it
    if (i == _entries.length) {
      _entries.add(entry);
      _calendar.add(entry.event);
    }
  }
}
