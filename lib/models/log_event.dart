import 'package:calendar_view/calendar_view.dart';
import 'package:neurolog/models/log_entry.dart';

// Class to associate LogEntrys with CalendarEvents.
// This is so that when a cell is clicked in CalendarView, the event passed
// also contains a reference to the associated LogEntry.
class LogEvent extends CalendarEventData {
  final LogEntry entry; // The entry associated with the calendar event

  // The constructor takes in a title, date and entry.
  LogEvent({required super.title, required super.date, required this.entry});
}
