import 'package:flutter/material.dart';
import 'package:habit_app/components/my_heat_map.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/util/habit_util.dart';

class IndividualHabitStreakCard extends StatelessWidget {
  final Habit habit;
  final DateTime startDate;
  final Color cardColor; // NEW: Accept the pastel color

  const IndividualHabitStreakCard({
    super.key,
    required this.habit,
    required this.startDate,
    required this.cardColor, // Initializing the new parameter
  });

  // Helper: Creates the binary dataset for a single habit
  // Note: The heatmap requires datasets to dictate the color intensity.
  // We'll pass the `cardColor` as the highlight color later.
  Map<DateTime, int> _createDatasetForHabit() {
    Map<DateTime, int> dataset = {};
    for (var date in habit.completedDays) {
      // Set value to 5 so it shows as the strongest color
      dataset[DateTime(date.year, date.month, date.day)] = 5;
    }
    return dataset;
  }

  // Helper: Maps habit name to an appropriate icon (optional, based on your implementation)
  IconData _getIconForHabit(String name) {
    if (name.toLowerCase().contains('gym') ||
        name.toLowerCase().contains('workout')) {
      return Icons.fitness_center;
    } else if (name.toLowerCase().contains('meditate')) {
      return Icons.self_improvement;
    } else if (name.toLowerCase().contains('code')) {
      return Icons.code;
    }
    return Icons.star;
  }

  @override
  Widget build(BuildContext context) {
    // We now use the passed cardColor for the card's theme
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    final dotFillColor = cardColor; // Use the pastel color for the heatmap fill

    int streakCount = calculateStreak(habit.completedDays);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dotFillColor.withOpacity(
          0.2,
        ), // Use a slight tint of the pastel color for the background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Text/Header Row (Habit Name and Streak, better styled)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon and Habit Name
              Row(
                children: [
                  // Icon
                  Icon(
                    _getIconForHabit(habit.name),
                    color: dotFillColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  // Habit Name
                  Text(
                    habit.name.toUpperCase(), // Uppercase for a cleaner look
                    style: TextStyle(
                      color: inversePrimary,
                      fontWeight: FontWeight.w800, // Bolder
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              // Streak Count
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 18,
                    color: dotFillColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$streakCount Days',
                    style: TextStyle(
                      color: inversePrimary.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 2. HeatMap (Spread Out Horizontally)
          MyHeatMap(
            size: 10,
            days: 160, // Pass a set number of days to ensure consistent spread
            startDate: startDate,
            datasets: _createDatasetForHabit(),
            // NEW: Pass the habit's color to the heatmap for the dots
            color: dotFillColor,
          ),
        ],
      ),
    );
  }
}
