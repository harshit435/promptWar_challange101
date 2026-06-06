class MealTimelineItem {
  final String time;
  final String mealType; // Breakfast, Lunch, Dinner
  final String title;
  final int prepTimeMinutes;
  final List<String> ingredients;
  final List<String> instructions;

  MealTimelineItem({
    required this.time,
    required this.mealType,
    required this.title,
    required this.prepTimeMinutes,
    required this.ingredients,
    required this.instructions,
  });

  MealTimelineItem copyWith({
    String? time,
    String? mealType,
    String? title,
    int? prepTimeMinutes,
    List<String>? ingredients,
    List<String>? instructions,
  }) {
    return MealTimelineItem(
      time: time ?? this.time,
      mealType: mealType ?? this.mealType,
      title: title ?? this.title,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
    );
  }
}

class GroceryItem {
  final String name;
  final double price;
  final bool isChecked;

  GroceryItem({
    required this.name,
    required this.price,
    this.isChecked = false,
  });

  GroceryItem copyWith({
    String? name,
    double? price,
    bool? isChecked,
  }) {
    return GroceryItem(
      name: name ?? this.name,
      price: price ?? this.price,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class Substitution {
  final String original;
  final String replacement;
  final double savings;
  final bool isApplied;

  Substitution({
    required this.original,
    required this.replacement,
    required this.savings,
    this.isApplied = false,
  });

  Substitution copyWith({
    String? original,
    String? replacement,
    double? savings,
    bool? isApplied,
  }) {
    return Substitution(
      original: original ?? this.original,
      replacement: replacement ?? this.replacement,
      savings: savings ?? this.savings,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}

class PlanScore {
  final int budgetScore;
  final int timeScore;
  final int wasteScore;
  final String grade;

  PlanScore({
    required this.budgetScore,
    required this.timeScore,
    required this.wasteScore,
    required this.grade,
  });
}

class MealPlan {
  final String dailySummary;
  final List<MealTimelineItem> timeline;
  final List<GroceryItem> groceryList;
  final List<Substitution> substitutions;
  final PlanScore score;
  final int estimatedCookingTimeMinutes;
  final double estimatedSavings;
  final double totalCost;
  final double budget;

  MealPlan({
    required this.dailySummary,
    required this.timeline,
    required this.groceryList,
    required this.substitutions,
    required this.score,
    required this.estimatedCookingTimeMinutes,
    required this.estimatedSavings,
    required this.totalCost,
    required this.budget,
  });

  MealPlan copyWith({
    String? dailySummary,
    List<MealTimelineItem>? timeline,
    List<GroceryItem>? groceryList,
    List<Substitution>? substitutions,
    PlanScore? score,
    int? estimatedCookingTimeMinutes,
    double? estimatedSavings,
    double? totalCost,
    double? budget,
  }) {
    return MealPlan(
      dailySummary: dailySummary ?? this.dailySummary,
      timeline: timeline ?? this.timeline,
      groceryList: groceryList ?? this.groceryList,
      substitutions: substitutions ?? this.substitutions,
      score: score ?? this.score,
      estimatedCookingTimeMinutes: estimatedCookingTimeMinutes ?? this.estimatedCookingTimeMinutes,
      estimatedSavings: estimatedSavings ?? this.estimatedSavings,
      totalCost: totalCost ?? this.totalCost,
      budget: budget ?? this.budget,
    );
  }
}
