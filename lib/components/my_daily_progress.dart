import 'package:flutter/material.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/util/habit_util.dart';

class MyDailyProgress extends StatelessWidget {
  final List<Habit> habits;

  const MyDailyProgress({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    // Colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;

    // Custom Accent Color (Matching the flame color you used)
    const flameColor = Color.fromARGB(255, 255, 97, 89);

    // Calculate Progress
    int totalHabits = habits.length;
    int completedHabits = 0;

    for (var habit in habits) {
      if (isHabitCompletedToday(habit.completedDays)) {
        completedHabits++;
      }
    }

    // Avoid division by zero. Ensure it's between 0.0 and 1.0
    double percent = (totalHabits == 0 ? 0 : completedHabits / totalHabits);
    if (percent > 1) percent = 1;

    // Determine completion status for dynamic text
    final bool isComplete = percent == 1.0 && totalHabits > 0;

    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: tertiaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // Highlight the status if complete
                isComplete ? "GOAL ACHIEVED!" : "Daily Progress",
                style: TextStyle(
                  color: inversePrimary,
                  fontSize: 16, // Slightly reduced for better hierarchy
                  fontWeight: FontWeight.w500, // Slightly lighter weight
                ),
              ),
              const SizedBox(height: 5),
              // Main Progress Count (Larger and bolder)
              Text(
                "$completedHabits of $totalHabits",
                style: TextStyle(
                  color: isComplete ? primaryColor : inversePrimary,
                  fontSize: 28, // Significantly larger
                  fontWeight: FontWeight.w900, // Very bold
                ),
              ),
              // Subtext (Completed habits label)
              Text(
                "HABITS COMPLETED",
                style: TextStyle(
                  color: inversePrimary.withOpacity(
                    0.5,
                  ), // Lower opacity for background text
                  fontSize: 12,
                  letterSpacing: 0.5, // Added letter spacing for styling
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Circular Indicator Stack
          SizedBox(
            height: 65,
            width: 65,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Layer 1: Faint background Circle
                SizedBox(
                  height: 65,
                  width: 65,
                  child: CircularProgressIndicator(
                    value: 1, // Full circle
                    color: primaryColor.withOpacity(0.2),
                    strokeWidth: 8,
                  ),
                ),

                // Layer 2: Animated Progress Circle
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: percent),
                  duration: const Duration(
                    milliseconds: 1200,
                  ), // 1.2 second animation
                  curve: Curves.easeOutCubic, // Starts fast, slows down at end
                  builder: (context, animatedValue, child) {
                    return SizedBox(
                      height: 65,
                      width: 65,
                      child: CircularProgressIndicator(
                        value: animatedValue,
                        color: primaryColor, // Using flameColor constant
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                      ),
                    );
                  },
                ),

                // Layer 3: The "Cool" Icon (Fire) placed in the center
                Icon(
                  Icons.whatshot_rounded, // Fire icon
                  color: primaryColor, // Using flameColor constant
                  size: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
