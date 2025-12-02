// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get calendar => 'Calendario';

  @override
  String get createEntry => 'Crear Entrada';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get language => 'Idioma';

  @override
  String get editEntry => 'Editar entrada de migraña';

  @override
  String dateLabel(Object date) {
    return 'Fecha: $date';
  }

  @override
  String startTimeLabel(Object time) {
    return 'Hora de inicio: $time';
  }

  @override
  String get endTimeNotSet => 'Hora de finalización: No establecida';

  @override
  String endTimeLabel(Object time) {
    return 'Hora de finalización: $time';
  }

  @override
  String get severityLabel => 'Severidad (número)';

  @override
  String get notesLabel => 'Notas adicionales';

  @override
  String get saveEntry => 'Guardar entrada';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get timeOfDay => 'Hora del día';

  @override
  String get today => 'hoy';

  @override
  String get stepCount => 'Recuento de Pasos';

  @override
  String get day => 'dia';
}
