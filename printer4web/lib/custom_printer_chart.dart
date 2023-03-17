import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget PrinterChart(List<double> history) {
  final List<Color> gradientColors = [Colors.amberAccent, Colors.amber];

  // TODO Move the frame, not the data
  return AspectRatio(
    aspectRatio: 1.70,
    child: LineChart(
      mainData(history, gradientColors),
    ),
  );
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

LineChartData mainData(List<double> history, List<Color> gradientColors) {
  const double defaultValue = 20;
  double lowerBound = history.isEmpty ? defaultValue : history.reduce(min);
  double upperBound = history.isEmpty ? defaultValue : history.reduce(max);

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
  print("diff: ${upperBound - lowerBound} interval: $interval");
  if (interval < 0.01) {
    interval = 0.1;
  }

  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: interval,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey,
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
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
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey),
    ),
    minY: lowerBound,
    maxY: upperBound,
    lineBarsData: [
      LineChartBarData(
        spots: List<FlSpot>.generate(history.length, (i) => FlSpot(i.toDouble(), history[i])),
        isCurved: true,
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ),
    ],
  );
}

class LineChartExample extends StatefulWidget {
  const LineChartExample({super.key, required this.history});

  final Color sinColor = Colors.amberAccent;
  final Color cosColor = Colors.amber;

  final List<FlSpot> history;

  @override
  State<LineChartExample> createState() => _LineChartExampleState();
}

class _LineChartExampleState extends State<LineChartExample> {
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval
                ),
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
