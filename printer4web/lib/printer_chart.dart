import 'dart:core';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class PrinterChart extends StatefulWidget {
  const PrinterChart({super.key, required this.history});

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

    return Text("${value.round()}", textAlign: TextAlign.left);
  }

  Tuple3<int, int, int> getBounds(double lowest, double highest, int minInterval, int wantedIntervals) {
    final int bufferedLower = (lowest - (highest - lowest) * 0.20).floor();
    final int bufferedUpper = (highest + (highest - lowest) * 0.20).ceil();
    final minSpan = minInterval * wantedIntervals;


    if(bufferedUpper - bufferedLower < minSpan) {
      // The span is too small. Add buffer to both sides.
      final int span = bufferedUpper - bufferedLower;
      final int missingSpan = minSpan - span;

      // Add half of the missing span to the lower bound and the other half to the upper bound.
      // If the missing span is odd, add the extra 1 to the bound that is closer to an original bound.
      int lowerBound = bufferedLower - missingSpan ~/ 2;
      int upperBound = bufferedUpper + missingSpan ~/ 2;

      if(missingSpan % 2 != 0) {
        final double distanceToUpper = bufferedUpper - highest;
        final double distanceToLower = lowest - bufferedLower;
        if(distanceToUpper < distanceToLower) {
          upperBound += 1;
        } else {
          lowerBound -= 1;
        }
      }

      // The span is now guaranteed to be divisible by the interval exactly wantedInterval times.
      final interval = (upperBound - lowerBound) ~/ wantedIntervals;
      return Tuple3(lowerBound, upperBound, interval);
    }else{
      // Extend the bounds equally such that the span is divisible by the interval exactly wantedInterval times.
      final int span = bufferedUpper - bufferedLower;
      // Get the next higher multiple of wantedIntervals and minInterval. The calculation is using only integers to avoid rounding errors.
      final int nextHigherMultiple = ((span + minSpan - 1) ~/ minSpan) * minSpan;

      // Now add the difference equally to both sides.
      final int missingSpan = nextHigherMultiple - span;
      int lowerBound = bufferedLower - missingSpan ~/ 2;
      int upperBound = bufferedUpper + missingSpan ~/ 2;

      // Add the extra 1 to the bound that is closer to an original bound.
      if(missingSpan % 2 != 0) {
        final double distanceToUpper = bufferedUpper - highest;
        final double distanceToLower = lowest - bufferedLower;
        if(distanceToUpper < distanceToLower) {
          upperBound += 1;
        } else {
          lowerBound -= 1;
        }
      }

      final int interval = nextHigherMultiple ~/ wantedIntervals;
      return Tuple3(lowerBound, upperBound, interval);
    }

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
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
        colors: [Theme.of(context).primaryColor.withOpacity(0), Theme.of(context).primaryColor],
        stops: const [0.0, 0.2],
      ),
      barWidth: 4,
      isCurved: true,
    );
  }
}
