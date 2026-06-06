import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartcook_ai/main.dart';
import 'package:smartcook_ai/models/meal_plan.dart';
import 'package:smartcook_ai/services/meal_planner_service.dart';

void main() {
  group('MealPlannerService Unit Tests', () {
    test('generatePlan returns valid plan for Vegetarian diet', () {
      final plan = MealPlannerService.generatePlan(
        busyLevel: 'Busy',
        budget: 500.0,
        peopleCount: 2,
        dietPreference: 'Vegetarian',
        ingredients: ['Eggs', 'Rice', 'Tomato'],
      );

      expect(plan.timeline.length, 3);
      expect(plan.timeline[0].mealType, 'Breakfast');
      expect(plan.timeline[1].mealType, 'Lunch');
      expect(plan.timeline[2].mealType, 'Dinner');
      
      // Since it's vegetarian, dinner should contain paneer
      expect(plan.timeline[2].title, contains('Paneer'));
      expect(plan.score.grade, isNotNull);
      expect(plan.totalCost, greaterThan(0));
    });

    test('generatePlan returns Tofu instead of Paneer for Vegan diet', () {
      final plan = MealPlannerService.generatePlan(
        busyLevel: 'Normal',
        budget: 400.0,
        peopleCount: 2,
        dietPreference: 'Vegan',
        ingredients: ['Tomato', 'Rice'],
      );

      // Vegan diet dinner should have Tofu, not Paneer
      expect(plan.timeline[2].title, contains('Tofu'));
      expect(plan.timeline[2].title, isNot(contains('Paneer')));
    });

    test('generatePlan applies substitution correctly', () {
      final initialPlan = MealPlannerService.generatePlan(
        busyLevel: 'Busy',
        budget: 500.0,
        peopleCount: 2,
        dietPreference: 'Vegetarian',
        ingredients: [],
      );

      expect(initialPlan.substitutions.isNotEmpty, true);
      final paneerSub = initialPlan.substitutions.firstWhere((e) => e.original == 'Paneer');

      // Create a plan applying this substitution
      final updatedSubs = initialPlan.substitutions.map((e) {
        if (e.original == 'Paneer') {
          return e.copyWith(isApplied: true);
        }
        return e;
      }).toList();

      final substitutedPlan = MealPlannerService.generatePlan(
        busyLevel: 'Busy',
        budget: 500.0,
        peopleCount: 2,
        dietPreference: 'Vegetarian',
        ingredients: [],
        customSubstitutions: updatedSubs,
      );

      // The dinner title should now be Tofu Wrap instead of Paneer Wrap
      expect(substitutedPlan.timeline[2].title, contains('Tofu'));
      expect(substitutedPlan.timeline[2].title, isNot(contains('Paneer')));
      expect(substitutedPlan.estimatedSavings, greaterThan(initialPlan.estimatedSavings));
      expect(substitutedPlan.totalCost, lessThan(initialPlan.totalCost));
    });
  });

  group('SmartCook AI Widget Tests', () {
    testWidgets('App renders branding and layout correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const SmartCookApp());
      await tester.pump();

      // Verify header branding
      expect(find.text('SmartCook AI'), findsOneWidget);
      expect(
        find.text('Plan meals around your day, budget & ingredients'),
        findsOneWidget,
      );

      // Verify Context inputs section is loaded
      expect(find.text("TODAY'S CONTEXT"), findsOneWidget);
      expect(find.text("How busy are you today?"), findsOneWidget);
      expect(find.text("Budget"), findsOneWidget);

      // Verify dynamic outputs section is present
      expect(find.text("AI DAILY SUMMARY"), findsOneWidget);
      expect(find.text("TODAY'S MEAL TIMELINE"), findsOneWidget);
      expect(find.text("Grocery List"), findsOneWidget);
      expect(find.text("Budget Analysis"), findsOneWidget);
      expect(find.text("PLAN SCORE"), findsOneWidget);
    });

    testWidgets('Toggling busy levels changes summary text', (WidgetTester tester) async {
      await tester.pumpWidget(const SmartCookApp());
      await tester.pump();

      // Default busy level is 'Busy', verify initial summary text
      expect(find.textContaining('Busy day detected'), findsOneWidget);

      // Click on 'Normal' busy level
      await tester.tap(find.text('Normal'));
      await tester.pump();

      // Click on 'Generate Smart Plan'
      await tester.tap(find.text('Generate Smart Plan'));
      // Pump to wait for simulation delay
      await tester.pump(const Duration(milliseconds: 700));

      // Verify updated summary text for Normal level
      expect(find.textContaining('Normal day context'), findsOneWidget);
    });
  });
}
