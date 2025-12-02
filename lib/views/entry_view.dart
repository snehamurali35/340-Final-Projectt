import 'package:flutter/material.dart';
import 'package:neurolog/l10n/app_localizations.dart';
import 'package:neurolog/models/log_entry.dart';
import 'package:neurolog/providers/log_provider.dart';
import 'package:neurolog/views/navigation_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// The SingleEntryPage extends StatefulWidget and creates the view for a creating/editing an entry
class SingleEntryPage extends StatefulWidget {
  final LogEntry entry; // the entry that we are creating/editing
  final Function _setViewCallback;  // Callback to change the main view in the NavigationView

  // Purpose: constructor for a SingleEntryPage that is created from the '+' page
  // Parameters: an optional key, a required entry, a required callback that is passed to an initializer
  // Returns: none
  const SingleEntryPage({
    super.key,
    required this.entry,
    required setViewCallback,
  }) : _setViewCallback = setViewCallback;

  // Purpose: constructor for a SingleEntryPage that is created when a date is pressed on the calendar
  // Parameters: an optional key, a required date (the date pressed), a required callback that is passed to an initializer
  // Returns: none
  SingleEntryPage.fromDate({
    super.key,
    required DateTime date,
    required Function setViewCallback,
  }) : entry = LogEntry.fromDate(date: date),
       _setViewCallback = setViewCallback;

  // creates and returns mutable state for StatefulWidget
  @override
  SingleEntryPageState createState() => SingleEntryPageState();
}

// SingleEntryPageState class creates the current state of the single entry page
class SingleEntryPageState extends State<SingleEntryPage> {
  late DateTime date;  // the date of the entry
  late TimeOfDay start;  // the start time of the entry
  late TimeOfDay? end;  // the end time of the entry
  late double severity;  // the severity rating of the entry
  late String notes;  // the notes for the entry

  final TextEditingController notesController = TextEditingController();  // controller to manage the text input for the notes field

  // This is the edit history/future for the undo/redo buttons
  // editCurrent represents the snapshot of the current page
  // editHistory is a list of previous changes that were made
  // editFuture is a list of changes that are undo-ed
  late EntryEditSnapshot editCurrent;
  final List<EntryEditSnapshot> editHistory = List.empty(growable: true);
  final List<EntryEditSnapshot> editFuture = List.empty(growable: true);

  // Purpose: initializes state for the current entry
  // Parameters: none
  // Returns: none
  @override
  void initState() {
    super.initState();
    date = widget.entry.date;
    start = TimeOfDay.fromDateTime(widget.entry.start);
    end =
        widget.entry.end != null
            ? TimeOfDay.fromDateTime(widget.entry.end!)
            : null;
    severity = widget.entry.severity.toDouble();
    notes = widget.entry.notes;

    // Set the current view to the current values
    editCurrent = EntryEditSnapshot(
      date: date,
      start: start,
      endChanged: true,
      end: end,
      severity: severity,
      notes: notes,
    );
  }

  // Purpose: allows the user to select the date (can't be a date in the future)
  // Parameters: none
  // Returns: none
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Prevent the user from setting the date to the future
        if (picked.isBefore(DateTime.now())) {
          date = picked;
        }
      });
    }
  }

  // Purpose: allows the user to select the time
  // Parameters: a required bool that is used to determine the initial time
  // Returns: none
  Future<void> _selectTime({required bool isStart}) async {
    final TimeOfDay initialTime = isStart ? start : end ?? TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          start = picked;
        } else {
          end = picked;
        }
      });
    }
  }

  // Purpose: converts a TimeOfDay object to a DateTime object
  // Parameters: the TimeOfDay object to convert
  // Returns: a DateTime object
  DateTime _toDateTime(TimeOfDay time) {
    return DateTime(0, 0, 0, time.hour, time.minute);
  }

  // Purpose: format the time to have a 0 in front if the hour is <10 and be in hour:minute format
  // Parameters: the time we want to format
  // Returns: a String with the properly formatted time
  String _formatTime(TimeOfDay time) {
    String hour = time.hour.toString();
    String minute = '';
    if (time.minute < 10) {
      minute = '0${time.minute}';
    } else {
      minute = time.minute.toString();
    }
    return '$hour:$minute';
  }

  // Purpose: format the date based on the location
  // Parameters: the date to format, the context
  // Returns: a String with the properly formatted date
  String _formatDateBasedLoc(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMMd(locale).format(date);
  }

  // Purpose: builds the view for the single entry
  // Parameters: the context of the location in the widget tree
  // Returns: a Consumer<LogProvider> widget that listens to state changes in the app's log data
           // with a Scaffold that has an AppBar showing the date and a ListView of different UI
           // elements (date and time pickers, sliders, text fields, buttons) in it.
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    notesController.text = notes;

    return Consumer<LogProvider>(
      builder:
          (context, provider, child) => Scaffold(
            appBar: AppBar(
              title: Text(DateFormat.MMMMEEEEd().format(date)),
              actions: [
                Tooltip(
                  message: 'Undo last change',
                  child: IconButton(onPressed: _undo, icon: Icon(Icons.undo)),
                ),
                Tooltip(
                  message: 'Redo last undone change',
                  child: IconButton(onPressed: _redo, icon: Icon(Icons.redo)),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Date Picker
                  ListTile(
                    title: Text(
                      loc.dateLabel(_formatDateBasedLoc(date, context)),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      await _selectDate(); // ← add ()
                      _editEntry(EntryEditSnapshot(date: date));
                    },
                  ),
                  // Start Time Picker
                  ListTile(
                    title: Text(loc.startTimeLabel(_formatTime(start))),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      await _selectTime(isStart: true);
                      _editEntry(EntryEditSnapshot(start: start));
                    },
                  ),
                  // End Time Picker
                  ListTile(
                    title: Text(
                      end == null
                          ? 'End Time: Not Set'
                          : 'End Time: ${_formatTime(end!)}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      await _selectTime(isStart: false);
                      _editEntry(EntryEditSnapshot(end: end, endChanged: true));
                    },
                  ),
                  // Slider
                  ListTile(
                    title: Text('Severity: ${severity.round()}'),
                    trailing: const Icon(Icons.bolt),
                    subtitle: Slider(
                      value: severity,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      max: 10,
                      divisions: 10,
                      label: severity.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          severity = value;
                        });
                        _editEntry(EntryEditSnapshot(severity: severity));
                      },
                    ),
                  ),
                  // Additional Notes
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: loc.notesLabel,
                      hintText: 'Write any notes about your migraine here',
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged:
                        (text) => {
                          notes = text,
                          if (text.characters.last == ' ')
                            _editEntry(EntryEditSnapshot(notes: text)),
                        },
                  ),
                  const SizedBox(height: 20),
                  // Save Entry Button
                  ElevatedButton(
                    onPressed: () => _saveEntry(provider: provider),
                    //child: Text(loc.saveEntry),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.all(20.0),
                      minimumSize: Size(50.0, 30.0),
                    ),
                    child: const Text('Save'),
                  ),
                  // Cancel Entry Button
                  ElevatedButton(
                    onPressed: () => _cancelEntry(provider: provider),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.all(20.0),
                      minimumSize: Size(50.0, 30.0),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // Purpose: allows the user to undo their actions
  // Parameters: none
  // Returns: none
  void _undo() {
    if (editHistory.isNotEmpty) {
      editFuture.add(editCurrent);
      editCurrent = editHistory.removeLast();
      _setEditState(editCurrent);
    }
  }

  // Purpose: allows the user to redo their actions
  // Parameters: none
  // Returns: none
  void _redo() {
    if (editFuture.isNotEmpty) {
      editHistory.add(editCurrent);
      editCurrent = editFuture.removeLast();
      _setEditState(editCurrent);
    }
  }

  // Purpose: sets the state to match the edited version
  // Parameters: the edit that has the information we want to update to
  // Returns: none
  void _setEditState(EntryEditSnapshot edit) {
    setState(() {
      date = edit.date ?? date;
      start = edit.start ?? start;
      end = edit.endChanged == true ? edit.end : end;
      severity = edit.severity ?? severity;
      notes = edit.notes ?? notes;
    });
  }

  // Purpose: adds the edit into the edit history (for undo/redo)
  // Parameters: the edit to handle
  // Returns: none
  void _editEntry(EntryEditSnapshot edit) {
    editHistory.add(editCurrent);
    editCurrent = edit;
  }

  // Purpose: allows user to save the entry
  // Parameter: a required LogProvider to keep track of the entry
  // Returns: none
  void _saveEntry({required LogProvider provider}) {
    final LogEntry entry = LogEntry(
      id: widget.entry.id,
      date: date,
      start: DateTime(
        date.year,
        date.month,
        date.day,
        start.hour,
        start.minute,
      ),
      end: end != null ? _toDateTime(end!) : null,
      severity: severity.round(),
      notes: notes,
    );

    provider.upsertLogEntry(entry);
    widget._setViewCallback(NavigationLabel.calendar);
  }

  // Purpose: allows the user to cancel the entry which takes them back to the calendar page
  // Parameters: a required LogProvider to keep track of the entry
  // Returns: none
  void _cancelEntry({required LogProvider provider}) {
    widget._setViewCallback(NavigationLabel.calendar);
  }
}

// the EntryEditSnapshot class creates a snapshot of the edits page in an entry
class EntryEditSnapshot {
  final DateTime? date;  // the date of the entry
  final TimeOfDay? start;  // the start time of the entry
  final bool? endChanged;  // whether or not the end time was changed
  final TimeOfDay? end;  // the end time of the entry
  final double? severity;  // the severity rating of the entry
  final String? notes;  // the additional notes for the entry

  // Purpose: constructor for the EntryEditSnapshot
  // Parameters: the date, the start time, whether the end time changed, the end time, the severity rating, and the notes
  // Returns: none
  EntryEditSnapshot({
    this.date,
    this.start,
    this.endChanged,
    this.end,
    this.severity,
    this.notes,
  });
}
