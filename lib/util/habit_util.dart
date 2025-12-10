import 'package:flutter/material.dart';
import 'package:habit_app/models/habit.dart';

/// Extension methods on DateTime to simplify date operations.
extension DateUtils on DateTime {
  /// Returns a new DateTime object representing midnight (00:00:00)
  /// of the current date, effectively removing the time component.
  /// This is essential for accurate date comparisons for habits.
  DateTime normalizeDate() {
    return DateTime(year, month, day);
  }
}

/// Checks if a habit was completed today based on its completedDays list.
bool isHabitCompletedToday(List<DateTime> completedDays) {
  // Use the extension to normalize today's date
  final today = DateTime.now().normalizeDate();

  // Use the extension to check if any completed date matches today
  return completedDays.any((date) => date.normalizeDate() == today);
}

/// Helper function to aggregate all habit completion days into a single dataset
/// suitable for the HeatMap widget.
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // Use the extension to normalize the date for the map key
      final normalizedDate = date.normalizeDate();

      // If the date is already in the map, increment the count (up to 5)
      if (dataset.containsKey(normalizedDate)) {
        // Clamp the value to 5, the max intensity for the heatmap
        dataset[normalizedDate] = (dataset[normalizedDate]! + 1).clamp(1, 5);
      } else {
        // Otherwise, initialize the count to 1
        dataset[normalizedDate] = 1;
      }
    }
  }
  return dataset;
}

/// Calculates the current consecutive streak for a single habit.
int calculateStreak(List<DateTime> completedDays) {
  if (completedDays.isEmpty) return 0;

  // 1. Normalize and get a unique, sorted list of completed dates
  final normalizedCompletedDays = completedDays
      .map((date) => date.normalizeDate())
      .toSet() // Use a set to ensure only unique dates
      .toList();

  normalizedCompletedDays.sort(
    (a, b) => b.compareTo(a),
  ); // Sort descending (most recent first)

  int streak = 0;
  DateTime checkDate = DateTime.now().normalizeDate();

  // 2. Check if the habit was completed today.
  bool completedToday = normalizedCompletedDays.contains(checkDate);

  if (!completedToday) {
    // If not completed today, start checking from yesterday.
    checkDate = checkDate.subtract(const Duration(days: 1));
  } else {
    // If completed today, the streak starts at 1
    streak = 1;
    // Move back to yesterday for the loop
    checkDate = checkDate.subtract(const Duration(days: 1));
  }

  // 3. Loop backwards until a missing day is found
  for (int i = 0; i < normalizedCompletedDays.length; i++) {
    // Look through the list only for the checkDate
    if (normalizedCompletedDays.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  // Edge case: if the list was empty or the last completed day was yesterday and today is missed,
  // the initial check in StreaksPage will handle the starting point.
  return streak;
}
