import 'package:flutter/material.dart';
import 'package:habit_app/components/my_heat_map.dart';
import 'package:habit_app/database/habit_database.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/util/habit_util.dart'; // Contains normalizeDate
import 'package:provider/provider.dart';
import 'package:habit_app/components/individual_habit_streak_card.dart';

// RE-DEFINING THE PASTELL COLORS LIST FROM home_page.dart
const List<Color> pastelColors = [
  Color(0xFF81D4FA), // Light Blue
  Color(0xFFA5D6A7), // Light Green
  Color(0xFFFFCC80), // Light Orange
  Color(0xFFF48FB1), // Light Pink
  Color(0xFFB39DDB), // Light Purple
  Color(0xFFE6EE9C), // Light Lime
];

class StreaksPage extends StatelessWidget {
  const StreaksPage({super.key});

  // Helper method to calculate the current overall streak length.
  // The overall streak is the maximum consecutive days ending today or yesterday
  // where the aggregated activity (dataset value) was greater than zero.
  static int _calculateOverallStreak(Map<DateTime, int> datasets) {
    if (datasets.isEmpty) return 0;

    int streak = 0;
    DateTime today = DateTime.now().normalizeDate();
    DateTime checkDate = today;

    // Check if today is completed.
    if (datasets.containsKey(checkDate) && datasets[checkDate]! > 0) {
      streak = 1;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      // If today is NOT completed, check yesterday to determine the current streak.
      checkDate = checkDate.subtract(const Duration(days: 1));
      if (datasets.containsKey(checkDate) && datasets[checkDate]! > 0) {
        streak = 1;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
      // If today and yesterday are both incomplete, the streak is 0.
    }

    // Continue checking backwards for consecutive completion
    while (datasets.containsKey(checkDate) && datasets[checkDate]! > 0) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    // Theme colors
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final habitDatabase = context.watch<HabitDatabase>();
    final currentHabits = habitDatabase.currentHabits;

    // --- START: NEW HABIT CHECK ---
    if (currentHabits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 64,
                color: inversePrimary.withOpacity(0.5),
              ),
              const SizedBox(height: 20),
              Text(
                "No Habits to Track",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: inversePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Go to the Habits tab and create your first habit to start tracking your streaks!",
                style: TextStyle(
                  fontSize: 16,
                  color: inversePrimary.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    // --- END: NEW HABIT CHECK ---

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DateTime?>(
        future: habitDatabase.getFirstLaunchDate(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator
          }

          final startDate = snapshot.data!;
          final overallDatasets = prepHeatMapDataset(currentHabits);
          // Calculate the overall streak using the helper method
          final int overallStreak = _calculateOverallStreak(overallDatasets);

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. PAGE HEADER (Updated for better alignment and visual impact)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Use CrossAxisAlignment.start to align the title and streak at the top
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Title
                      Text(
                        "Streaks",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: inversePrimary,
                        ),
                      ),

                      // Overall Streak Counter on the right side - now standing out
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            // Row for the icon and the number
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_fire_department, // Fire icon
                                color: primaryColor,
                                size: 36, // Match number size
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$overallStreak",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),

                          // Subtitle is smaller and aligned below the number/icon row
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 2. OVERALL HEATMAP CARD (Simplified since streak is in header)
                Container(
                  decoration: BoxDecoration(
                    // Use tertiary color for the card background
                    color: tertiaryColor,
                    borderRadius: BorderRadius.circular(16),
                    // Add a slight shadow for elevation/better look
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  // Increased padding for content inside the card
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (New placement and better text)
                      Text(
                        " OVERALL ACTIVITY", // Improved main title
                        style: TextStyle(
                          color:
                              primaryColor, // Use primary color for a highlight
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // The HeatMap component
                      MyHeatMap(
                        size: 15,
                        // Set a base color for the overall heatmap, like the primary color
                        color: primaryColor,
                        days: 110, // Display 120 days (approx 4 months)
                        startDate: startDate,
                        datasets: overallDatasets,
                      ),
                    ],
                  ),
                ),

                // 3. INDIVIDUAL HABIT HEATMAPS
                // Title for the individual cards (moved slightly down for better separation)

                // Use the new custom card for each habit
                ...currentHabits.asMap().entries.map((entry) {
                  int index = entry.key;
                  Habit habit = entry.value;

                  // Calculate the habit color
                  final Color habitColor =
                      pastelColors[index % pastelColors.length];

                  return IndividualHabitStreakCard(
                    habit: habit,
                    startDate: startDate,
                    cardColor: habitColor, // PASS THE COLOR
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
