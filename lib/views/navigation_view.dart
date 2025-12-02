// https://api.flutter.dev/flutter/material/NavigationBar-class.html
import 'package:flutter/material.dart';
import 'package:neurolog/models/log_entry.dart';
import 'package:neurolog/views/calendar_view.dart';
import 'package:neurolog/views/entry_view.dart';
import 'package:neurolog/views/graph_view.dart';

import 'package:neurolog/l10n/app_localizations.dart';

// The class navigation view extends stateful widget, and controls the navigation view creation.
class NavigationView extends StatefulWidget {
  // The location for internationalization part of code.
  final Function(Locale) setLocale;

  // The constructor takes in the locale, and the key.
  const NavigationView({super.key, required this.setLocale});

  // Creates the navigation view state.
  @override
  State<NavigationView> createState() => _NavigationViewState();
}

// Dynamic view of the widget
class _NavigationViewState extends State<NavigationView> {
  int _tabIndex = 0; // defines the index of the current view
  LogEntry? _selectedEntry; // entry selected from calendar view (if any)

  // Returns a safe area widget to create the bottom bar of the app and handles the internationalization
  // part as well
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // Figure out the title for the current page based on the tab index
    final String title = switch (_tabIndex) {
      0 => loc.calendar,
      1 => _selectedEntry == null ? loc.createEntry : loc.editEntry,
      2 => loc.statistics,
      _ => '',
    };

    return SafeArea(
      child: Scaffold(
        // Create app bar
        appBar: AppBar(
          title: Text(title),
          actions: [
            // On the right size, add a menu option to change the language
            PopupMenuButton<Locale>(
              onSelected: widget.setLocale,
              icon: const Icon(Icons.language_outlined),
              itemBuilder:
                  (_) => const [
                    PopupMenuItem(value: Locale('en'), child: Text('English')),
                    PopupMenuItem(value: Locale('es'), child: Text('Español')),
                  ],
            ),
          ],
        ),

        // Create the bottom navigation bar to switch tabs
        bottomNavigationBar: NavigationBar(
          // Update the tab index when a navigation button is clicked
          onDestinationSelected: (int index) {
            setState(() {
              _tabIndex = index;
            });
          },
          selectedIndex: _tabIndex,

          // List of button options of the navigation bar
          destinations: <Widget>[
            // Option 1: Calendar
            NavigationDestination(
              icon: Icon(Icons.calendar_month_rounded),
              label: loc.calendar,
            ),
            // Option 2: Create Entry
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline_rounded),
              label: loc.createEntry,
            ),
            // Option 3: Graph View
            NavigationDestination(
              icon: Icon(Icons.data_usage),
              label: loc.statistics,
            ),
          ],
        ),

        // Set the view of the main body based on the current tab index
        body: switch (_tabIndex) {
          0 => CalendarView(setViewCallback: _setViewCallback),
          1 => SingleEntryPage(
            entry: _selectedEntry ?? LogEntry.fromDate(date: DateTime.now()),
            setViewCallback: _setViewCallback,
          ),
          2 => MigraineBarChart(),
          _ => Placeholder(),
        },
      ),
    );
  }

  // This is a callback function.
  // The purpose of the function is to give the capability to the views to
  // switch to a specific view without having the user use the navigation bar.
  // This function should be passed to the widget's constructors where
  // applicable.
  void _setViewCallback(NavigationLabel label, [LogEntry? entry]) {
    setState(() {
      switch (label) {
        // Set to calendar view
        case NavigationLabel.calendar:
          _tabIndex = 0;
          _selectedEntry = null;
          break;
        // Set to create entry view
        case NavigationLabel.entry:
          _tabIndex = 1;
          // If entry is not null, this means that a specific calendar cell
          // was pressed in the calendar view
          _selectedEntry = entry;
          break;
        // Set to graph view
        case NavigationLabel.data:
          _tabIndex = 2;
          _selectedEntry = null;
          break;
      }
    });
  }
}

// Enum so that the widgets can be specific about which view should be set
// when they call _setViewCallback.
// This is safer than the alternative of using integers to set _tabIndex.
enum NavigationLabel { calendar, entry, data }
