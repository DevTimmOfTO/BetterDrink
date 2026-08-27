/// One point in a day-bucketed trend chart.
class ChartPoint {
  const ChartPoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}
