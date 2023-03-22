import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    // Filter out the top most and bottom most tile to prevent overlapping.
    if ((upperBound - value) < 0.001 || (value - lowerBound) < 0.001) {
      return const Text("");
    } else {
      return Text(value.toStringAsPrecision(3), textAlign: TextAlign.left);
    }
  }

  double roundProperly(double value) {
    var rounded = (value * 50).round() / 50;
    return rounded;
  }

  @override
  Widget build(BuildContext context) {
    const double defaultValue = 20;
    double lowerBound = widget.history.isEmpty ? defaultValue : widget.history.map((e) => e.y).reduce(min);
    double upperBound = widget.history.isEmpty ? defaultValue : widget.history.map((e) => e.y).reduce(max);

    {
      double boundDiff = (upperBound - lowerBound);
      if (boundDiff < 0.01) {
        boundDiff = 1;
      }
      double boundBuffer = boundDiff * 0.15;
      lowerBound -= boundBuffer;
      upperBound += boundBuffer;
    }

    double interval = roundProperly((upperBound - lowerBound) / 4);
    if (interval < 0.01) {
      interval = 0.1;
    }

    return widget.history.isNotEmpty
        ? LineChart(
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
          )
        : Container();
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
