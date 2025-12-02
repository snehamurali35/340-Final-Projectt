import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:neurolog/models/log_event.dart';

// The event painter class extends custom painter and controls the color of the custom lightning drawing based
// on the severity of the user's headache.
class EventPainter extends CustomPainter {
  // The field events keeps the list of LogEvents.
  late final List<LogEvent> events;

  // The Event Painter constructor takes in a list of events and initializes the class variable to this list, where
  // each item is of type LogEvent.
  EventPainter({required List<CalendarEventData> events}) {
    this.events = events.map((event) => event as LogEvent).toList();
  }

  // This method dictates based on the event, what paint method is called.
  // Takes parameters of canvas and size.
  @override
  void paint(Canvas canvas, Size size) {
    Size iconSize = Size(
      size.width / (events.length),
      (size.height) / (events.length),
    );
    for (LogEvent event in events) {
      switch (event.title) {
        case 'Migraine':
          _paintMigraine(canvas, iconSize, event);
        case _:
          _paintDefault(canvas, size);
      }
    }
  }

  // Based on the severity level, chooses the color of the drawing.
  // Takes in the canvas, size, and the log event.
  void _paintMigraine(Canvas canvas, Size size, LogEvent event) {
    late final List<Color> colors;
    switch (event.entry.severity) {
      case 0: // Not severe - Very calm, healthy
        colors = [
          const Color.fromARGB(255, 76, 175, 80),
          const Color.fromARGB(255, 67, 155, 70),
        ];
        break;
      case 1: // Minimal severity - Still good, slightly less than perfect
        colors = [
          const Color.fromARGB(255, 82, 213, 38),
          const Color.fromARGB(255, 70, 183, 32),
        ];
        break;
      case 2: // Low severity - Moving towards a bit of caution
        colors = [
          const Color.fromARGB(255, 128, 214, 24),
          const Color.fromARGB(255, 117, 194, 22),
        ];
        break;
      case 3: // Mild severity - Noticeable but not alarming
        colors = [
          const Color.fromARGB(255, 254, 254, 16),
          const Color.fromARGB(255, 218, 218, 9),
        ];
        break;
      case 4: // Moderate severity - Approaching caution
        colors = [
          const Color.fromARGB(255, 253, 187, 21),
          const Color.fromARGB(255, 224, 165, 16),
        ];
        break;
      case 5: // Mid-range severity - Cautionary, halfway point
        colors = [
          const Color.fromARGB(255, 255, 133, 2),
          const Color.fromARGB(255, 206, 125, 3),
        ];
        break;
      case 6: // Elevated severity - Increasing concern
        colors = [
          const Color.fromARGB(255, 255, 119, 0),
          const Color.fromARGB(255, 209, 87, 11),
        ];
        break;
      case 7: // Significant severity - Clearly concerning
        colors = [Colors.deepOrange, const Color.fromARGB(255, 189, 52, 14)];
        break;
      case 8: // High severity - Warning, approaching critical
        colors = [
          const Color.fromARGB(255, 236, 31, 31),
          const Color.fromARGB(255, 212, 36, 23),
        ];
        break;
      case 9: // Very high severity - Critical, urgent
        colors = [
          const Color.fromARGB(255, 176, 18, 7),
          const Color.fromARGB(255, 97, 5, 5),
        ]; // Deepening intensity
        break;
      case 10: // Severe - Extreme, immediate action
        colors = [
          const Color.fromARGB(255, 83, 8, 8),
          const Color.fromARGB(255, 59, 7, 7),
        ]; // Reaching the most severe visual
        break;
      default: // Fallback for out-of-range values
        colors = [Colors.white, Colors.black];
        break;
    }
    // Creating a paint object, uses a gradient fill.
    final Paint paint =
        Paint()
          //..color = Colors.orange
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: colors,
          ).createShader(Offset.zero & size);

    // List of points, of type Offset to define the shape of the drawing.
    final List<Offset> points = [
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.35, size.height * 1),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.7, 0),
    ];
    // Creates the path
    final Path path = Path();

    for (Offset point in points) {
      path.lineTo(point.dx, point.dy);
    }
    // Draws the path
    canvas.drawPath(path, paint);
  }

  void _paintDefault(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

    // Calculate the center of the available space
    final Offset center = Offset(size.width / 2, size.height / 2);
    // Determine the radius (e.g., half of the smallest dimension or a fixed value)
    final double radius = size.shortestSide / 10;

    canvas.drawCircle(center, radius, paint);
  }

  // Only repaint when instructed.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // In this simple case, the painter doesn't change
  }
}
