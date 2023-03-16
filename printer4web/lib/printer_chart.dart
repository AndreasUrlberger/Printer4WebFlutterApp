import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample10 extends StatefulWidget {
  const LineChartSample10({super.key});

  final Color sinColor = Colors.amberAccent;
  final Color cosColor = Colors.amber;

  @override
  State<LineChartSample10> createState() => _LineChartSample10State();
}

class _LineChartSample10State extends State<LineChartSample10> {
  final limitCount = 100;
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.05;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(xValue, math.sin(xValue)));
        cosPoints.add(FlSpot(xValue, math.cos(xValue)));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return cosPoints.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: LineChart(
              LineChartData(
                minY: -1,
                maxY: 1,
                minX: sinPoints.first.x,
                maxX: sinPoints.last.x,
                lineTouchData: LineTouchData(enabled: false),
                clipData: FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  sinLine(sinPoints),
                  cosLine(cosPoints),
                ],
                titlesData: FlTitlesData(
                  show: false,
                ),
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
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [widget.cosColor.withOpacity(0), widget.cosColor],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
