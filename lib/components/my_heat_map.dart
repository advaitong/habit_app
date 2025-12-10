import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int> datasets;
  final int days;
  final double size;
  final Color? color; // This is the dynamic color passed from the habit tile

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
    required this.days,
    required this.size,
    this.color, // Made color optional, but required in the constructor
  });

  // Helper function to convert opacity (0.0 to 1.0) to Alpha (0 to 255)
  int _opacityToAlpha(double opacity) {
    return (255 * opacity).round();
  }

  @override
  Widget build(BuildContext context) {
    final themePrimaryColor = Theme.of(context).colorScheme.primary;
    final inversePrimaryColor = Theme.of(context).colorScheme.inversePrimary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    // --- MODIFIED CODE START ---
    // 1. Determine the effective color to use for the dots.
    // Use the passed 'color' (pastel) if it's available, otherwise use the theme's primary color (purple).
    final effectiveDotColor = color ?? themePrimaryColor;

    // 2. Define the colorsets using the effectiveDotColor.
    final Map<int, Color> dynamicColorsets = {
      1: effectiveDotColor.withAlpha(_opacityToAlpha(0.3)),
      2: effectiveDotColor.withAlpha(_opacityToAlpha(0.5)),
      3: effectiveDotColor.withAlpha(_opacityToAlpha(0.8)),
      4: effectiveDotColor.withAlpha(_opacityToAlpha(1)),
      // For the highest intensity, just use the effectiveDotColor directly
      5: effectiveDotColor,
    };
    // --- MODIFIED CODE END ---

    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now().add(Duration(days: days)),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: secondaryColor,
      textColor: inversePrimaryColor,
      showColorTip: false,
      showText: false,
      borderRadius: 4,
      size: size,
      fontSize: 0,
      colorsets: dynamicColorsets,
    );
  }
}
