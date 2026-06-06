import 'package:flutter/material.dart';
import 'models/meal_plan.dart';
import 'services/meal_planner_service.dart';
import 'widgets/context_input_panel.dart';
import 'widgets/summary_panel.dart';
import 'widgets/timeline_panel.dart';
import 'widgets/grocery_budget_savings_panel.dart';
import 'widgets/substitutions_panel.dart';
import 'widgets/plan_score_panel.dart';

void main() {
  runApp(const SmartCookApp());
}

class SmartCookApp extends StatefulWidget {
  const SmartCookApp({super.key});

  @override
  State<SmartCookApp> createState() => _SmartCookAppState();
}

class _SmartCookAppState extends State<SmartCookApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCook AI',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5722),
          brightness: Brightness.light,
          primary: const Color(0xFFFF5722),
          secondary: const Color(0xFF00B0FF),
          background: const Color(0xFFF5F7FA),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7043),
          brightness: Brightness.dark,
          primary: const Color(0xFFFF7043),
          secondary: const Color(0xFF40C4FF),
          background: const Color(0xFF0D1B2A),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Input contexts state variables
  String _busyLevel = "Busy";
  double _budget = 500.0;
  int _peopleCount = 2;
  String _dietPreference = "Vegetarian";
  List<String> _ingredients = ["Eggs", "Rice", "Tomato"];

  // Meal Plan Output state
  late MealPlan _currentPlan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Generate an initial plan on startup
    _generatePlanDirectly();
  }

  void _generatePlanDirectly() {
    _currentPlan = MealPlannerService.generatePlan(
      busyLevel: _busyLevel,
      budget: _budget,
      peopleCount: _peopleCount,
      dietPreference: _dietPreference,
      ingredients: _ingredients,
    );
  }

  // Generate with loading simulation for AI feel
  void _generatePlan() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _currentPlan = MealPlannerService.generatePlan(
          busyLevel: _busyLevel,
          budget: _budget,
          peopleCount: _peopleCount,
          dietPreference: _dietPreference,
          ingredients: _ingredients,
        );
        _isLoading = false;
      });
    });
  }

  void _onSubstitutionToggled(Substitution sub) {
    setState(() {
      // Toggle substitution state
      final updatedSubs = _currentPlan.substitutions.map((item) {
        if (item.original == sub.original &&
            item.replacement == sub.replacement) {
          return item.copyWith(isApplied: !item.isApplied);
        }
        return item;
      }).toList();

      // Recalculate using active options
      _currentPlan = MealPlannerService.generatePlan(
        busyLevel: _busyLevel,
        budget: _budget,
        peopleCount: _peopleCount,
        dietPreference: _dietPreference,
        ingredients: _ingredients,
        customSubstitutions: updatedSubs,
      );
    });
  }

  void _onGroceryListChanged(List<GroceryItem> newList) {
    setState(() {
      _currentPlan = _currentPlan.copyWith(groceryList: newList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Background gradient matching visual requirements
    final backgroundGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1E38), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFE2E8F0), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Premium branding custom Appbar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "🍳 ",
                              style: TextStyle(fontSize: 26),
                            ),
                            Text(
                              "SmartCook AI",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Plan meals around your day, budget & ingredients",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Tooltip(
                          message: "Toggle light/dark theme",
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.04),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isDark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                color: isDark ? Colors.amber : Colors.indigo,
                              ),
                              onPressed: widget.onToggleTheme,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Core scrollable body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 950;

                      if (isDesktop) {
                        // Two-Column Grid for Desktop
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column: Context input
                            Expanded(
                              flex: 4,
                              child: ContextInputPanel(
                                busyLevel: _busyLevel,
                                budget: _budget,
                                peopleCount: _peopleCount,
                                dietPreference: _dietPreference,
                                ingredients: _ingredients,
                                isLoading: _isLoading,
                                onBusyLevelChanged: (val) =>
                                    setState(() => _busyLevel = val),
                                onBudgetChanged: (val) =>
                                    setState(() => _budget = val),
                                onPeopleCountChanged: (val) =>
                                    setState(() => _peopleCount = val),
                                onDietPreferenceChanged: (val) =>
                                    setState(() => _dietPreference = val),
                                onIngredientsChanged: (val) =>
                                    setState(() => _ingredients = val),
                                onGeneratePressed: _generatePlan,
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Right column: AI Outputs
                            Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  SummaryPanel(
                                    summaryText: _currentPlan.dailySummary,
                                    totalPrepTime: _currentPlan
                                        .estimatedCookingTimeMinutes,
                                    estimatedSavings:
                                        _currentPlan.estimatedSavings,
                                  ),
                                  const SizedBox(height: 16),
                                  TimelinePanel(
                                      timelineItems: _currentPlan.timeline),
                                  const SizedBox(height: 16),
                                  GroceryBudgetSavingsPanel(
                                    groceryList: _currentPlan.groceryList,
                                    budget: _currentPlan.budget,
                                    totalCost: _currentPlan.totalCost,
                                    estimatedSavings:
                                        _currentPlan.estimatedSavings,
                                    onGroceryListChanged: _onGroceryListChanged,
                                  ),
                                  const SizedBox(height: 16),
                                  SubstitutionsPanel(
                                    substitutions: _currentPlan.substitutions,
                                    onSubstitutionToggled:
                                        _onSubstitutionToggled,
                                  ),
                                  const SizedBox(height: 16),
                                  PlanScorePanel(
                                    budgetScore: _currentPlan.score.budgetScore,
                                    timeScore: _currentPlan.score.timeScore,
                                    wasteScore: _currentPlan.score.wasteScore,
                                    grade: _currentPlan.score.grade,
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Single Column Stack for Mobile
                        return Column(
                          children: [
                            ContextInputPanel(
                              busyLevel: _busyLevel,
                              budget: _budget,
                              peopleCount: _peopleCount,
                              dietPreference: _dietPreference,
                              ingredients: _ingredients,
                              isLoading: _isLoading,
                              onBusyLevelChanged: (val) =>
                                  setState(() => _busyLevel = val),
                              onBudgetChanged: (val) =>
                                  setState(() => _budget = val),
                              onPeopleCountChanged: (val) =>
                                  setState(() => _peopleCount = val),
                              onDietPreferenceChanged: (val) =>
                                  setState(() => _dietPreference = val),
                              onIngredientsChanged: (val) =>
                                  setState(() => _ingredients = val),
                              onGeneratePressed: _generatePlan,
                            ),
                            const SizedBox(height: 20),
                            SummaryPanel(
                              summaryText: _currentPlan.dailySummary,
                              totalPrepTime:
                                  _currentPlan.estimatedCookingTimeMinutes,
                              estimatedSavings: _currentPlan.estimatedSavings,
                            ),
                            const SizedBox(height: 16),
                            TimelinePanel(timelineItems: _currentPlan.timeline),
                            const SizedBox(height: 16),
                            GroceryBudgetSavingsPanel(
                              groceryList: _currentPlan.groceryList,
                              budget: _currentPlan.budget,
                              totalCost: _currentPlan.totalCost,
                              estimatedSavings: _currentPlan.estimatedSavings,
                              onGroceryListChanged: _onGroceryListChanged,
                            ),
                            const SizedBox(height: 16),
                            SubstitutionsPanel(
                              substitutions: _currentPlan.substitutions,
                              onSubstitutionToggled: _onSubstitutionToggled,
                            ),
                            const SizedBox(height: 16),
                            PlanScorePanel(
                              budgetScore: _currentPlan.score.budgetScore,
                              timeScore: _currentPlan.score.timeScore,
                              wasteScore: _currentPlan.score.wasteScore,
                              grade: _currentPlan.score.grade,
                            ),
                            const SizedBox(height: 40),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
