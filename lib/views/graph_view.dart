import 'package:neurolog/views/graphs/migraine_graph.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:neurolog/providers/log_provider.dart';
import 'package:neurolog/views/graphs/step_graph.dart';

// The migraine bar chart class extends stateless widget
class MigraineBarChart extends StatelessWidget {
  // Constructor that takes in the key
  const MigraineBarChart({super.key});

  // Returns the Migraine graph and the steps graph on the same view
  // Takes a parameter of build context, context object.
  @override
  Widget build(BuildContext context) {
    return Consumer<LogProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            // Migraine Frequency Bar Chart
            Flexible(
              flex: 3,
              child: MigraineGraph(
                weeklyMigraineFrequency: provider.weeklyMigraineFrequency,
              ),
            ),

            const SizedBox(height: 100),

            Flexible(
              flex: 3,
              child: StepGraph(weeklySteps: provider.weeklySteps),
            ),
          ],
        );
      },
    );
  }
}
