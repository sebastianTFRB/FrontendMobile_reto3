import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> data = [
      FlSpot(1, 3),
      FlSpot(2, 5),
      FlSpot(3, 4),
      FlSpot(4, 7),
      FlSpot(5, 6),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Estadísticas")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LineChart(
          LineChartData(
            titlesData: const FlTitlesData(show: true),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                spots: data,
                barWidth: 3,
                color: Colors.blueAccent,
                dotData: FlDotData(show: false),
              )
            ],
          ),
        ),
      ),
    );
  }
}
