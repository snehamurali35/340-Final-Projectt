import 'package:flutter/material.dart';
import 'package:neurolog/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';

// The StepGraph class extends stateless widget and creates the graph of the steps someone has walked in the past week using the health api
class StepGraph extends StatelessWidget {
  // The Map maps Strings to int, and keeps track of the steps the user walked every day for the last week.
  final Map<String, int> weeklySteps;

  // The StepGraph constructor takes in a weeklySteps map of day, to the steps walked.
  const StepGraph({super.key, required this.weeklySteps});

  // Returns a bar chart widget that gets the data from the Apple Health app and graphs it.
  // Takes in a build context context object.
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dayLabels = weeklySteps.keys.toList();
    final stepCounts = weeklySteps.values.toList();

    return BarChart(
      BarChartData(
        maxY: 30000,
        barGroups: List.generate(stepCounts.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(toY: stepCounts[i].toDouble(), width: 20),
            ],
          );
        }),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 10000),
            axisNameWidget: Text(loc.stepCount),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                return Text(
                  index >= 0 && index < dayLabels.length
                      ? dayLabels[index]
                      : '',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
            axisNameWidget: Text(loc.day),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }
}
