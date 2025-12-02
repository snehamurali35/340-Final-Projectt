import 'package:flutter/material.dart';
import 'package:neurolog/l10n/app_localizations.dart';
import 'package:neurolog/models/log_entry.dart';
import 'package:neurolog/providers/log_provider.dart';
import 'package:neurolog/views/navigation_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:calendar_view/calendar_view.dart';

// Ties everything together, ensures it is initialized and also implements data persistence.
void main() async {
  // Ensure the whole flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([LogEntrySchema], directory: dir.path);

  runApp(MainApp(isar: isar));
}

// Class main app extends stateful widget
class MainApp extends StatefulWidget {
  // Isar field for persistence
  final Isar isar;
  // Constructor that takes in isar object
  const MainApp({super.key, required this.isar});

  @override
  State<MainApp> createState() => _MainAppState();
}

// Class Main app state that extends state of type main app.
class _MainAppState extends State<MainApp> {
  Locale _locale = const Locale('en');

  // Sets the locale to what is passed in, takes in a locale of type Locale.
  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // Returns a material app widget, and sets the localization parameters to the necessary values to
  // allow for internationalization. takes in Build context context object.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChangeNotifierProvider(
        create:
            (context) =>
                LogProvider(isar: widget.isar, calendar: EventController()),
        child: NavigationView(setLocale: _setLocale),
      ),
    );
  }
}
