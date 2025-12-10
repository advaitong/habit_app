import 'package:flutter/material.dart';
import 'package:habit_app/components/my_heat_map.dart'; // Import for the new component
import 'package:habit_app/database/habit_database.dart';
import 'package:habit_app/util/focus_provider.dart';
import 'package:provider/provider.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FocusPageContent();
  }
}

class _FocusPageContent extends StatelessWidget {
  const _FocusPageContent();

  @override
  Widget build(BuildContext context) {
    final focusProvider = Provider.of<FocusProvider>(context);
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;

    // Button text logic
    String actionText = '';
    if (focusProvider.state == TimerState.running) {
      actionText = 'PAUSE';
    } else if (focusProvider.state == TimerState.paused) {
      actionText = 'RESUME';
    } else {
      actionText = 'START FOCUS';
    }

    // Header Styles
    final focusTextStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: focusProvider.mode == TimerMode.focus
          ? inversePrimary
          : inversePrimary.withOpacity(0.4),
    );
    final breakTextStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: focusProvider.mode == TimerMode.breakTime
          ? inversePrimary
          : inversePrimary.withOpacity(0.4),
    );

    return Scaffold(
      backgroundColor: surfaceColor,
      body: FutureBuilder<DateTime?>(
        // Fetch the global start date for consistent heatmap display
        future: Provider.of<HabitDatabase>(
          context,
          listen: false,
        ).getFirstLaunchDate(),
        builder: (context, snapshot) {
          // Use the fetched start date, or fall back to 90 days ago if loading/null
          final DateTime startDate =
              snapshot.data ??
              DateTime.now().subtract(const Duration(days: 90));

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  // --- HEADER (Focus / Break / Reset) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Focus", style: focusTextStyle),
                          const SizedBox(width: 18),
                          Text("Break", style: breakTextStyle),
                        ],
                      ),
                      GestureDetector(
                        onTap: focusProvider.resetTimer,
                        child: Icon(
                          Icons.refresh_rounded,
                          color: inversePrimary,
                          size: 30,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- HEATMAP (Top Section) ---
                  Container(
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " FOCUS STREAK",
                          style: TextStyle(
                            color: inversePrimary.withOpacity(0.7),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        MyHeatMap(
                          startDate: startDate,
                          datasets: focusProvider.focusHistory,
                          days: 80, // Display 120 days for consistency
                          size: 20,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- TIMER DISPLAY ---
                  Text(
                    focusProvider.formattedTime,
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.w600,
                      color: inversePrimary,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // --- DURATION BUTTONS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDurationButton(context, 5),
                      _buildDurationButton(context, 15),
                      _buildDurationButton(context, 25),
                      _buildDurationButton(context, 60),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- MAIN ACTION BUTTON ---
                  GestureDetector(
                    onTap: () {
                      if (focusProvider.state == TimerState.running) {
                        focusProvider.pauseTimer();
                      } else {
                        focusProvider.startTimer();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        actionText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: surfaceColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDurationButton(BuildContext context, int minutes) {
    final focusProvider = Provider.of<FocusProvider>(context);
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;

    final bool isSelected =
        focusProvider.mode == TimerMode.focus &&
        focusProvider.initialFocusDuration == minutes * 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () => focusProvider.setDuration(minutes),
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? tertiaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected
                  ? tertiaryColor
                  : inversePrimary.withOpacity(0.3),
              width: isSelected ? 0 : 1.5,
            ),
          ),
          child: Text(
            minutes.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
