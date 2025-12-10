import 'package:flutter/material.dart';
import 'package:habit_app/ad/banner_ad.dart';
import 'package:habit_app/pages/focus_page.dart';
import 'package:provider/provider.dart';
import 'package:habit_app/components/my_horizontal_calender.dart';
import 'package:habit_app/components/my_habit_tile.dart';
import 'package:habit_app/components/my_daily_progress.dart';
import 'package:habit_app/database/habit_database.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/util/habit_util.dart';
import 'package:habit_app/pages/settings_page.dart';
import 'package:habit_app/pages/streaks_page.dart';
import 'package:habit_app/pages/onboarding_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  bool? _showOnboarding;

  static const List<Widget> _pages = <Widget>[
    _HomeContent(),
    StreaksPage(), // New Tab
    FocusPage(), // Placeholder
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Start reading habits and checking tutorial status immediately
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    _checkTutorialStatus();
  }

  // ⭐ 3. METHOD TO CHECK TUTORIAL STATUS
  Future<void> _checkTutorialStatus() async {
    final bool shown = await Provider.of<HabitDatabase>(
      context,
      listen: false,
    ).getTutorialShown();
    setState(() {
      // If shown is true, we set _showOnboarding to false (hide onboarding)
      // If shown is false, we set _showOnboarding to true (show onboarding)
      _showOnboarding = !shown;
    });
  }

  // ⭐ 4. CALLBACK PASSED TO ONBOARDINGPAGE
  void _completeOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
  }

  final TextEditingController textController = TextEditingController();

  void createNewHabit() {
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        content: TextField(
          controller: textController,
          style: TextStyle(color: inversePrimary),
          decoration: InputDecoration(
            hintText: "Create a new habit",
            hintStyle: TextStyle(color: inversePrimary.withOpacity(0.6)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().addHabit(textController.text);
              Navigator.pop(context);
              textController.clear();
            },
            child: Text('Save', style: TextStyle(color: primaryColor)),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: Text('Cancel', style: TextStyle(color: inversePrimary)),
          ),
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        content: TextField(
          controller: textController,
          style: TextStyle(color: inversePrimary),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().updateHabitName(
                habit.id,
                textController.text,
              );
              Navigator.pop(context);
              textController.clear();
            },
            child: Text('Save', style: TextStyle(color: primaryColor)),
          ),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: inversePrimary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    // Show loading spinner if tutorial status is not yet determined
    if (_showOnboarding == null) {
      return Scaffold(
        backgroundColor: surfaceColor,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    // Show Onboarding Page if it hasn't been shown before
    if (_showOnboarding == true) {
      return OnboardingPage(onFinish: _completeOnboarding);
    }

    // Otherwise, show the main app content (Scaffold + BottomNavBar)
    return Scaffold(
      backgroundColor: surfaceColor,
      body: _pages.elementAt(_selectedIndex),

      // ⭐ MODIFIED: Use a Column in bottomNavigationBar to stack the Ad and the NavBar
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // Important: Shrink to fit content
        children: [
          // 1. Banner Ad Widget (The Banner Ad will only show if it successfully loads)
          BannerAdWidget(),

          // 2. Original Bottom Navigation Bar
          BottomNavigationBar(
            backgroundColor: secondaryColor,
            selectedItemColor: primaryColor,
            unselectedItemColor: inversePrimary.withOpacity(0.6),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.offline_bolt_outlined),
                label: 'Habits',
              ),
              // Added Streaks Tab Icon
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Streaks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.center_focus_weak),
                label: 'Focus',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const List<Color> pastelColors = [
  Color.fromARGB(255, 85, 68, 211),
  Color.fromARGB(255, 61, 85, 164),
  Color.fromARGB(255, 86, 126, 194),
  Color.fromARGB(255, 66, 131, 161),
  Color.fromARGB(255, 102, 81, 186),
];

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  // Helper widget for the empty state message and doodle
  Widget _buildEmptyState(BuildContext context, Color inversePrimary) {
    return Center(
      // Center the content vertically and horizontally within the expanded area
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doodle/Icon pointing to the Add button
            Align(
              alignment: Alignment.topCenter, // Center the icon horizontally
              child: Column(
                children: [
                  Icon(
                    Icons
                        .add_circle_outline, // Use an icon suggesting 'add' or 'start'
                    size: 80,
                    color: inversePrimary.withOpacity(0.7),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            Text(
              "Start Your Journey!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Tap the '+' icon in the top right corner to create your first habit and kickstart your tracking.",
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

  @override
  Widget build(BuildContext context) {
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    final _HomePageState homeState = context
        .findAncestorStateOfType<_HomePageState>()!;

    // Watch database to get habits
    final habitDatabase = context.watch<HabitDatabase>();
    final currentHabits = habitDatabase.currentHabits; // Get habits list

    return SafeArea(
      child: Column(
        children: [
          // Header (where the add button is)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Habits",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: inversePrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: inversePrimary, size: 30),
                  onPressed: homeState.createNewHabit,
                ),
              ],
            ),
          ),

          const MyHorizontalCalendar(),
          const SizedBox(height: 20),

          // Main List / Empty State
          Expanded(
            child: currentHabits.isEmpty
                ? _buildEmptyState(context, inversePrimary) // Show Empty State
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Progress Bar only shown if habits exist
                      MyDailyProgress(habits: habitDatabase.currentHabits),

                      const SizedBox(height: 20),
                      _buildHabitList(context),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList(BuildContext context) {
    final habitDatabase = context.watch<HabitDatabase>();
    final _HomePageState homeState = context
        .findAncestorStateOfType<_HomePageState>()!;

    // REMOVED static cardColor
    final contentColor = Theme.of(context).colorScheme.inversePrimary;

    return ListView.builder(
      itemCount: habitDatabase.currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = habitDatabase.currentHabits[index];
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // Calculate the color based on the index, looping through the pastelColors list
        final Color tileColor = pastelColors[index % pastelColors.length];

        return MyHabitTile(
          habit: habit,
          isCompleted: isCompletedToday,
          onTap: () => homeState.checkHabitOnOff(!isCompletedToday, habit),
          onEdit: () => homeState.editHabitBox(habit),
          cardColor: tileColor, // PASS the dynamic color
          contentColor: contentColor,
        );
      },
    );
  }
}
