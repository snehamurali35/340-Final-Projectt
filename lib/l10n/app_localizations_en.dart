// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get calendar => 'Calendar';

  @override
  String get createEntry => 'Create Entry';

  @override
  String get statistics => 'Statistics';

  @override
  String get language => 'Language';

  @override
  String get editEntry => 'Edit Migraine Entry';

  @override
  String dateLabel(Object date) {
    return 'Date: $date';
  }

  @override
  String startTimeLabel(Object time) {
    return 'Start Time: $time';
  }

  @override
  String get endTimeNotSet => 'End Time: Not Set';

  @override
  String endTimeLabel(Object time) {
    return 'End Time: $time';
  }

  @override
  String get severityLabel => 'Severity (number)';

  @override
  String get notesLabel => 'Additional Notes';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get frequency => 'Frequency';

  @override
  String get timeOfDay => 'Time of Day';

  @override
  String get today => 'Today';

  @override
  String get stepCount => 'Step Count';

  @override
  String get day => 'Day';
}
