import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int> datasets;

  const MyHeatMap({super.key, required this.startDate, required this.datasets});

  @override
  Widget build(BuildContext context) {
    return HeatMapCalendar(
      initDate: startDate,
      // endDate: startDate.add(Duration(days: 31)),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.inverseSurface,
      showColorTip: false,
      monthFontSize: 17,
      weekFontSize: 0,
      margin: EdgeInsets.all(2),
      borderRadius: 10,

      // showText: true,
      // scrollable: true,
      size: 42,
      fontSize: 10,
      colorsets: {
        1: Colors.red.shade200,
        2: Colors.red.shade300,
        3: Colors.red.shade400,
        4: Colors.red.shade500,
        5: Colors.red.shade600,
      },
    );
  }
}
