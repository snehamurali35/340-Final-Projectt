import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:neurolog/models/log_entry.dart';
import 'package:neurolog/models/log_event.dart';
import 'package:neurolog/models/painter/event_painter.dart';
import 'package:neurolog/providers/log_provider.dart';
import 'package:neurolog/views/navigation_view.dart';
import 'package:provider/provider.dart';

// This calendar view class extends stateless widget and creates the calendar view of the app.
class CalendarView extends StatelessWidget {
  // Callback to change the main view in the NavigationView
  final Function _setViewCallback;

  // The constructor initializes the setViewCallback to an initial value.
  const CalendarView({super.key, required setViewCallback})
    : _setViewCallback = setViewCallback;

  // Returns a consumer widget of type LogProvider, and constructs the calendar view.
  @override
  Widget build(BuildContext context) {
    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        // Init the provider that defines the calendar view
        // the controller is saved to the LogProvider class
        return CalendarControllerProvider(
          controller: logProvider.calendar,
          child: Scaffold(
            // Show the view of the current month
            body: MonthView(
              controller: logProvider.calendar,
              headerStringBuilder:
                  (date, {secondaryDate}) =>
                      '${DateFormat.MMMM(Localizations.localeOf(context).toLanguageTag()).format(date)} - ${date.year}',
              weekDayBuilder: (int dayIndex) {
                // dayIndex: 0 (Sunday) to 6 (Saturday)
                final date = DateTime(2025, 6, dayIndex + 2);
                final locale = Localizations.localeOf(context).toLanguageTag();
                final weekday = DateFormat.E(locale).format(date);

                return Center(
                  child: Text(
                    weekday.characters.first
                        .toUpperCase(), // One-letter abbreviation
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
              cellBuilder: (
                date,
                events,
                isToday,
                isInMonth,
                hideDaysNotInMonth,
              ) {
                // Accessbility: font size: Get the scaled size of the font.
                // Build the cell based on the font size to prevent a broken
                // view because of a bigger user-set font size.
                final textScaler = MediaQuery.textScalerOf(context);
                final fontSize = textScaler.scale(12.0);
                return _buildCalendarCell(
                  date,
                  events,
                  isToday,
                  isInMonth,
                  hideDaysNotInMonth,
                  fontSize,
                );
              },

              startDay: WeekDays.sunday,
              minMonth: DateTime(2025),
              maxMonth: DateTime.now(),
              initialMonth: DateTime.now(),
              hideDaysNotInMonth: true,
              cellAspectRatio: 0.55,

              onCellTap: (events, date) {
                // Ensures that only dates that are after the current date
                // are not opened for editing. This way the user can only
                // edit the current or past dates.
                if (date.isBefore(DateTime.now())) {
                  // Set the NavigationView show the EntryView widget.
                  // Set _selectedEntry to the date of the selected cell.
                  _setViewCallback(
                    NavigationLabel.entry,
                    events.isNotEmpty && events.first is LogEvent
                        ? (events.first as LogEvent).entry
                        : LogEntry.fromDate(date: date),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  // Helper method that builds the view for a calendar cell that represents a
  // single day.
  Widget _buildCalendarCell(
    DateTime date, // the date this cell represents
    List<CalendarEventData> events, // calendar events associated with date
    bool isToday, // is date the same as today
    bool isInMonth, // is date in this month
    bool hideDaysNotInMonth, // month view config option
    double fontSize, // font size with user-defined scale applied
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = constraints.maxWidth;
        final cellHeight = constraints.maxHeight;
        return Semantics(
          label:
              '${DateFormat.yMMMMd().format(date)}'
              '${events.isNotEmpty ? ', ${events.length} event(s)' : ', no events'}',
          child: Container(
            width: cellWidth,
            height: cellHeight,
            color:
                // Gray out cells that are in the future and cannot be accessed
                // by the user.
                date.isBefore(DateTime.now())
                    ? Colors.transparent
                    : Color(0x0A000000),
            padding: EdgeInsets.all(2.0),
            // Create column to align header, spacing, log indicators
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Cell header
                _buildCellHeader(
                  date: date,
                  cellWidth: cellWidth,
                  cellHeight: cellHeight,
                  fontSize: fontSize,
                  isToday: isToday,
                ),
                SizedBox(height: 2.0), // Separate header and body
                // Cell body
                _buildCellBody(events: events),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper function to build the cell header, takes in the date, cell width, cell height, font size, isToday.
  // Returns a container widget to build the header of each calendar cell
  Widget _buildCellHeader({
    required DateTime date,
    required double cellWidth,
    required double cellHeight,
    required double fontSize,
    required bool isToday,
  }) {
    return Container(
      padding: EdgeInsets.all(0.025 * cellHeight),
      width: 0.35 * cellHeight,
      height: 0.35 * cellHeight,
      // Add a blue circle indicator if this cell represents the current date.
      decoration:
          isToday
              ? BoxDecoration(color: Colors.blue, shape: BoxShape.circle)
              : null,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text('${date.day}', style: TextStyle(fontSize: fontSize)),
      ),
    );
  }

  // Helper function to build the cell body
  // Takes in a parameter of events, which is a list of calendar event data.
  Widget _buildCellBody({required List<CalendarEventData> events}) {
    // Wrap with Expanded widget because body should take up the rest of the
    // available space in the cell.
    return Expanded(
      // Create a paint view.
      // An icon will be painted if there is an event associated
      // with the current date.
      child: CustomPaint(
        painter: EventPainter(events: events),
        child: SizedBox.expand(),
      ),
    );
  }
}
