import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/chart_point.dart';

/// A themed bar chart for day-bucketed trend data (e.g. hydration ml/day
/// or alcohol g/day), labeled with a [unit] suffix in tooltips.
class HistoryChart extends StatelessWidget {
  const HistoryChart({super.key, required this.points, required this.unit});

  final List<ChartPoint> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (points.every((point) => point.value == 0)) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.noTrendDataYet,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final maxValue = points.map((point) => point.value).reduce((a, b) => a > b ? a : b);
    final labelEvery = (points.length / 6).ceil().clamp(1, points.length);
    final barWidth = (280 / points.length).clamp(4.0, 18.0);

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxValue * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => colorScheme.inverseSurface,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final point = points[group.x];
                return BarTooltipItem(
                  '${point.value.toStringAsFixed(0)} $unit',
                  TextStyle(color: colorScheme.onInverseSurface),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length || index % labelEvery != 0) {
                    return const SizedBox.shrink();
                  }
                  final date = points[index].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (var i = 0; i < points.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: points[i].value,
                    color: colorScheme.primary,
                    width: barWidth,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
