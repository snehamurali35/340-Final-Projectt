import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neurolog/l10n/app_localizations.dart';
import 'dart:math';

// The migraine graph class extends stateless widget and constructs a new migraine graph with data
// about the frequency of migraines at different times of the day.
class MigraineGraph extends StatelessWidget {
  // Map field stores int to int, the time to the frequency of migraine at that time.
  final Map<int, int> weeklyMigraineFrequency;
  // This field stores the max frequency of the migraine at any given time for the graph
  late final double greatestFrequency;

  // The migraine graph constructor initializes the value of greatest frequency based on the greatest
  // # of
  // migraine the user has had at any given time. If none, then 0.
  // Takes in the map of times to frequency.
  MigraineGraph({super.key, required this.weeklyMigraineFrequency}) {
    greatestFrequency =
        weeklyMigraineFrequency.isEmpty
            ? 0
            : weeklyMigraineFrequency.values.reduce(max).toDouble();
  }

  //Constructs a bar chart with the migraine data, which maps the time of day to the frequency of migraines at that respective time.
  // Returns a Bar Chart widget, and takes a BuildContext context object.
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: greatestFrequency + 2,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (greatestFrequency / 5 + 2).floorToDouble(),
            ),
            axisNameWidget: Text(loc.frequency),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(loc.timeOfDay, semanticsLabel: 'Time of day'),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = [
                  '1am',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10',
                  '11',
                  '12 pm',
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10',
                  '11',
                  '12 am',
                ];
                final index = value.toInt();
                return Text(
                  index >= 0 && index < days.length ? days[index] : '',
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        barGroups: _convertMapToBarGroups(weeklyMigraineFrequency),
      ),
    );
  }

  // This method is used to convert the map of migraine data to the form necessary to graph it, which is of type bar chart group data.
  // the x axis is the times from 1 am to 12 am, returned as a list of type bar chart group data.
  List<BarChartGroupData> _convertMapToBarGroups(Map<int, int> migData) {
    return migData.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [BarChartRodData(toY: entry.value.toDouble(), width: 20)],
      );
    }).toList();
  }
}
