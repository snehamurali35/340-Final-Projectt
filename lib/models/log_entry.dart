import 'package:isar/isar.dart';
import 'package:neurolog/models/log_event.dart';
part 'log_entry.g.dart';

// Isar collection to persist information on device.
@Collection(inheritance: false)
class LogEntry {
  final Id? id; // Isar automatically sets a unique ID
  final DateTime date; // the date associated with the entry
  final DateTime start; // The start time of the migraine
  final DateTime? end; // The end time of the migraine
  final int severity; // The severity of the migraine
  final String notes; // Notes about the migraine

  // Do not include the association with the calendar event because it cannot be
  // compiled by Isar. This will be regenerated when the app loads anyway.
  @ignore
  LogEvent? _event; // Associated calendar event

  LogEntry({
    this.id,
    required this.date,
    required this.start,
    this.end,
    required this.severity,
    required this.notes,
  });

  // Copy an entry but change its ID.
  LogEntry.withId(LogEntry entry, {required this.id})
    : date = entry.date,
      start = entry.start,
      end = entry.end,
      severity = entry.severity,
      notes = entry.notes;

  // Create an entry for a provided date.
  LogEntry.fromDate({required this.date})
    : id = null,
      start = DateTime(
        date.year,
        date.month,
        date.day,
        DateTime.now().hour,
        DateTime.now().minute,
      ),
      end = null,
      severity = 0,
      notes = '';

  // Getter method to get the calendar event associated with this entry.
  // Creates a new LogEvent for this object if it doesn't exist yet.
  @ignore
  LogEvent get event {
    _event ??= LogEvent(title: 'Migraine', date: date, entry: this);
    return _event!;
  }
}
