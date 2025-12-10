import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_app/database/habit_database.dart';

class OnboardingPage extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingPage({super.key, required this.onFinish});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Custom tutorial screen content
  List<Widget> get _onboardingPages => [
    _TutorialScreen(
      title: "Welcome to Habit Tracker!",
      description: "Build powerful habits and track your progress daily.",
      icon: Icons.offline_bolt_outlined,
      color: Theme.of(context).colorScheme.primary,
    ),
    _TutorialScreen(
      title: "Create Your First Habit",
      description:
          "Tap the '+' icon in the top right corner of the Habits tab to set your goal.",
      icon: Icons.add_circle_outline,
      color: Theme.of(context).colorScheme.tertiary,
    ),
    _TutorialScreen(
      title: "Track Your Streaks",
      description:
          "Use the 'Streaks' tab (second icon below) to view your consistency on a calendar heatmap.",
      icon: Icons.calendar_month,
      color: Theme.of(context).colorScheme.primary,
    ),
  ];

  // Logic to complete the tutorial and update database
  void _completeTutorial() async {
    await context.read<HabitDatabase>().saveTutorialShown();
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    Color surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: Column(
          children: [
            // PageView for screens
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _onboardingPages,
              ),
            ),

            // Indicator and Buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(
                      _onboardingPages.length,
                      (index) =>
                          _DotIndicator(isSelected: index == _currentPage),
                    ),
                  ),

                  // Next / Finish Button
                  GestureDetector(
                    onTap: () {
                      if (_currentPage < _onboardingPages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        _completeTutorial();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _currentPage < _onboardingPages.length - 1
                            ? 'Next'
                            : 'Start your Journey',
                        style: TextStyle(
                          color: inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widget for each tutorial screen
class _TutorialScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _TutorialScreen({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: color),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: inversePrimary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: inversePrimary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for the PageView dots
class _DotIndicator extends StatelessWidget {
  final bool isSelected;

  const _DotIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isSelected ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
