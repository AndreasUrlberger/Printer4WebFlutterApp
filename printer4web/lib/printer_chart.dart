import 'dart:core';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class PrinterChart extends StatefulWidget {
  const PrinterChart({super.key, required this.history});

  final Color sinColor = Colors.amberAccent;
  final Color cosColor = Colors.amber;

  final List<FlSpot> history;

  @override
  State<PrinterChart> createState() => _PrinterChartState();
}

class _PrinterChartState extends State<PrinterChart> {
  @override
  void initState() {
    super.initState();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double upperBound, double lowerBound, double interval) {
    // Do not draw the border as there is an interval very close to it.
    if (value == upperBound || value == lowerBound) {
      return const Text("");
    }

    const Color a = Colors.transparent;
    const Color b = Colors.black;

    final double distanceToBounds = min((upperBound - value).abs(), (value - lowerBound).abs());
    final double boundsPercentage = distanceToBounds / ((upperBound - lowerBound) / 2);
    final double opacity = (boundsPercentage + 1) / 2;

    return Text("${value.round()}", textAlign: TextAlign.left, style: TextStyle(color: Color.lerp(a, b, opacity)));
  }

  double roundProperly(double value) {
    var rounded = (value * 50).round() / 50;
    return rounded;
  }

  Tuple3<int, int, int> getBounds(double lowest, double highest, int minInterval, int wantedIntervals) {
    int lower = lowest.floor();
    int upper = highest.ceil();

    final int lowerBound;
    final int upperBound;
    final int interval;

    if ((upper - lower) < (minInterval * wantedIntervals)) {
      final int diff = upper - lower;
      final int missing = (minInterval * wantedIntervals) - diff;

      lower -= missing ~/ 2;
      upper += missing ~/ 2;

      if (missing % 2 != 0) {
        final double distanceToUpper = (upper - highest).abs();
        final double distanceToLower = (lowest - lower).abs();
        if (distanceToUpper < distanceToLower) {
          upper += 1;
        } else {
          lower -= 1;
        }
      }

      lowerBound = lower;
      upperBound = upper;
      interval = minInterval;
    } else {
      lowerBound = lowest.ceil() - 1;
      upperBound = highest.floor() + 1;

      interval = (upperBound - lowerBound) ~/ wantedIntervals;
    }

    return Tuple3(lowerBound, upperBound, interval);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.history.isEmpty) {
      return Container();
    }

    const int minInterval = 1;
    const int wantedIntervals = 4;

    final double lowest = widget.history.map((e) => e.y).reduce(min);
    final double highest = widget.history.map((e) => e.y).reduce(max);

    final bounds = getBounds(lowest, highest, minInterval, wantedIntervals);
    // Extend by a little to make sure the last interval is drawn.
    final double lowerBound = bounds.item1.toDouble() - 0.001;
    final double upperBound = bounds.item2.toDouble() + 0.001;
    final double interval = bounds.item3.toDouble();

    return LineChart(
      LineChartData(
        minY: lowerBound,
        maxY: upperBound,
        minX: widget.history.first.x,
        maxX: widget.history.last.x,
        lineTouchData: LineTouchData(enabled: false),
        clipData: FlClipData.all(),
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: interval),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          sinLine(widget.history),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              getTitlesWidget: (value, meta) {
                return leftTitleWidgets(value, meta, upperBound, lowerBound, interval);
              },
              reservedSize: 35,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          show: true,
        ),
      ),
    );
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [widget.sinColor.withOpacity(0), widget.sinColor],
        stops: const [0.0, 0.2],
      ),
      barWidth: 4,
      isCurved: true,
    );
  }
}
