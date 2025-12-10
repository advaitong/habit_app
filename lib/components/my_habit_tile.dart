import 'package:flutter/material.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/util/habit_util.dart';

class MyHabitTile extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final void Function()? onTap;
  final void Function()? onEdit;
  final Color cardColor;
  final Color contentColor; // This will be the inversePrimary (white/dark text)

  const MyHabitTile({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onTap,
    required this.onEdit,
    required this.cardColor,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate streak using the util function
    int streakCount = calculateStreak(habit.completedDays);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onEdit,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // 1. Use the dynamically passed cardColor (Purple)
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Streak and Weekly History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Streak Counter
                Row(
                  children: [
                    // 2. Use the dynamically passed contentColor
                    Icon(Icons.bolt, color: contentColor, size: 28),
                    Text(
                      "$streakCount",
                      style: TextStyle(
                        // Removed 'const' since TextStyle is now dynamic
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        // 3. Use the dynamically passed contentColor
                        color: contentColor,
                      ),
                    ),
                  ],
                ),
                // Weekly History Dots
                _buildWeeklyProgress(),
              ],
            ),
            const SizedBox(height: 20),
            // Habit Name
            Text(
              habit.name,
              style: TextStyle(
                // Removed 'const' since TextStyle is now dynamic
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // 4. Use the dynamically passed contentColor
                color: contentColor,
              ),
            ),

            // Added Subtitle back, styling it with a dimmed contentColor
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    List<Widget> icons = [];
    DateTime today = DateTime.now();

    for (int i = 4; i >= 0; i--) {
      DateTime dateToCheck = today.subtract(Duration(days: i));

      // Check if habit is done on this specific past date
      bool isDone = habit.completedDays.any(
        (d) =>
            d.year == dateToCheck.year &&
            d.month == dateToCheck.month &&
            d.day == dateToCheck.day,
      );

      icons.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            isDone ? Icons.check : Icons.circle_outlined,
            // 5. Use the dynamically passed contentColor for checks/circles
            color: contentColor,
            size: 20,
          ),
        ),
      );
    }
    return Row(children: icons);
  }
}
