import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int _opacityToAlpha(double opacity) {
  return (255 * opacity).round();
}

class MyHorizontalCalendar extends StatelessWidget {
  const MyHorizontalCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    // Read theme colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;

    // 1. Initialize the Scroll Controller
    // The current day is at index 2 (days: index - 2),
    // and each item is 50 wide plus 4 margin on each side (total 58).
    // We set the initial scroll offset to center index 2.
    final scrollController = ScrollController(
      initialScrollOffset:
          (2 * 58.0) - (MediaQuery.of(context).size.width / 2) + (58.0 / 2),
    );

    return SizedBox(
      height: 63,
      child: ListView.builder(
        controller: scrollController, // Apply the controller
        scrollDirection: Axis.horizontal,
        itemCount: 7, // Showing next 30 days logic (or past)
        itemBuilder: (context, index) {
          // Logic: Start from 2 days ago to show context
          DateTime date = DateTime.now().add(Duration(days: index - 3));
          bool isToday = index == 3;

          // 2. Apply Dynamic Sizing
          final double itemWidth = isToday
              ? 60
              : 50; // Current day is 10 pixels wider
          final double fontSize = isToday
              ? 22
              : 20; // Current day has slightly larger font

          return Container(
            width: itemWidth,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              // Use theme colors for the highlight
              color: isToday ? tertiaryColor : const Color.fromARGB(0, 0, 0, 0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(date),
                  style: TextStyle(
                    // Text color is inversePrimary (white/dark text)
                    color: isToday
                        ? primaryColor
                        : inversePrimary.withAlpha(_opacityToAlpha(0.3)),
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize, // Apply larger font size
                  ),
                ),
                Text(
                  DateFormat('EE').format(date),
                  style: TextStyle(
                    color: isToday
                        ? primaryColor
                        : inversePrimary.withAlpha(_opacityToAlpha(0.3)),
                    fontSize: fontSize - 8,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
