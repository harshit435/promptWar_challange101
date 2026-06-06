import '../models/meal_plan.dart';

class MealPlannerService {
  static MealPlan generatePlan({
    required String busyLevel,
    required double budget,
    required int peopleCount,
    required String dietPreference,
    required List<String> ingredients,
    List<Substitution>? customSubstitutions,
  }) {
    // Normalise ingredients
    final cleanIngredients = ingredients.map((e) => e.trim().toLowerCase()).toList();

    // 1. Determine base meal templates based on diet and available ingredients
    String breakfastTitle = "Veggie Sandwich";
    List<String> breakfastIngredients = ["Bread", "Tomato", "Onion", "Butter"];
    List<String> breakfastInstructions = [
      "Slice the tomatoes and onions.",
      "Spread butter on the bread slices.",
      "Assemble with sliced veggies and grill until golden brown."
    ];

    String lunchTitle = "Rice Bowl";
    List<String> lunchIngredients = ["Rice", "Tomato", "Onion", "Spices"];
    List<String> lunchInstructions = [
      "Cook the rice in a pot or cooker.",
      "Sauté chopped onions and tomatoes with spices in a pan.",
      "Mix the cooked rice with the sautéed mixture and serve hot."
    ];

    String dinnerTitle = "Paneer Wrap";
    List<String> dinnerIngredients = ["Paneer", "Wheat Flour", "Onion", "Yogurt"];
    List<String> dinnerInstructions = [
      "Prepare a dough with wheat flour and roll out thin rotis.",
      "Sauté paneer cubes with onions and yogurt dressing.",
      "Place paneer in the rotis, roll them up tightly, and serve."
    ];

    // Customize based on diet preference
    if (dietPreference == "Vegan") {
      breakfastTitle = "Tofu Toast";
      breakfastIngredients = ["Bread", "Tofu", "Tomato", "Olive Oil"];
      breakfastInstructions = [
        "Toast the bread slices.",
        "Scramble tofu with turmeric and salt in olive oil.",
        "Top the toast with scrambled tofu and sliced tomatoes."
      ];

      lunchTitle = "Tofu Rice Bowl";
      lunchIngredients = ["Rice", "Tofu", "Onion", "Broccoli"];
      lunchInstructions = [
        "Cook rice.",
        "Stir-fry tofu, onions, and broccoli in a pan with soy sauce.",
        "Serve the stir-fry over the hot rice."
      ];

      dinnerTitle = "Tofu Veggie Wrap";
      dinnerIngredients = ["Tofu", "Wheat Flour", "Bell Peppers", "Hummus"];
      dinnerInstructions = [
        "Make thin flatbreads from wheat flour.",
        "Sauté tofu cubes and sliced bell peppers.",
        "Spread hummus on the flatbread, add fillings, and wrap."
      ];
    } else if (dietPreference == "Non-Vegetarian") {
      if (cleanIngredients.contains("eggs")) {
        breakfastTitle = "Egg Scramble & Toast";
        breakfastIngredients = ["Eggs", "Bread", "Butter", "Tomato"];
        breakfastInstructions = [
          "Whisk eggs with salt and pepper.",
          "Scramble in butter over medium heat.",
          "Serve with toasted bread and sliced tomatoes."
        ];
      } else {
        breakfastTitle = "Egg Sandwich";
        breakfastIngredients = ["Eggs", "Bread", "Onion", "Mayo"];
        breakfastInstructions = [
          "Boil eggs and mash them with mayo and chopped onion.",
          "Spread the mixture between bread slices."
        ];
      }

      lunchTitle = "Egg Fried Rice Bowl";
      lunchIngredients = ["Rice", "Eggs", "Onion", "Garlic"];
      lunchInstructions = [
        "Cook rice and let it cool slightly.",
        "Scramble eggs in a hot pan, then set aside.",
        "Sauté onions and garlic, toss in rice, scramble back in, and season with soy sauce."
      ];

      dinnerTitle = "Chicken Rice Curry";
      dinnerIngredients = ["Chicken", "Rice", "Tomato", "Onion", "Spices"];
      dinnerInstructions = [
        "Cook rice separately.",
        "Sauté chicken cubes with onions, tomatoes, and curry spices.",
        "Simmer until chicken is cooked, and serve hot over rice."
      ];
    } else if (dietPreference == "Keto") {
      breakfastTitle = "Avocado & Egg Salad";
      breakfastIngredients = ["Eggs", "Avocado", "Olive Oil", "Spinach"];
      breakfastInstructions = [
        "Boil eggs and dice them.",
        "Mix with diced avocado, fresh spinach, and drizzle with olive oil."
      ];

      lunchTitle = "Paneer Tikka Salad";
      lunchIngredients = ["Paneer", "Capsicum", "Yogurt", "Butter"];
      lunchInstructions = [
        "Marinate paneer and capsicum in spiced yogurt.",
        "Pan-sear in butter until lightly charred."
      ];

      dinnerTitle = "Cauliflower Egg Rice";
      dinnerIngredients = ["Cauliflower", "Eggs", "Butter", "Garlic"];
      dinnerInstructions = [
        "Grate cauliflower into rice-like grains.",
        "Sauté in butter with garlic, then stir in whisked eggs until cooked."
      ];
    }

    // Integrate user's specific available ingredients dynamically
    if (cleanIngredients.contains("rice") && !lunchIngredients.contains("Rice")) {
      lunchIngredients.insert(0, "Rice");
    }
    if (cleanIngredients.contains("tomato") && !breakfastIngredients.contains("Tomato")) {
      breakfastIngredients.add("Tomato");
    }

    // 2. Adjust prep times and descriptions based on busy level
    int breakfastTime = 10;
    int lunchTime = 15;
    int dinnerTime = 20;
    String dailySummaryText = "";

    if (busyLevel == "Busy") {
      breakfastTime = (breakfastTime * 0.8).round();
      lunchTime = (lunchTime * 0.8).round();
      dinnerTime = (dinnerTime * 0.8).round();
      dailySummaryText = "Busy day detected. Quick meals selected.";
      breakfastInstructions.insert(0, "Quick tip: Prep veggies the night before.");
    } else if (busyLevel == "Normal") {
      breakfastTime = 12;
      lunchTime = 18;
      dinnerTime = 25;
      dailySummaryText = "Normal day context. Balanced and healthy recipes selected.";
    } else {
      // Relaxed
      breakfastTime = 18;
      lunchTime = 28;
      dinnerTime = 35;
      dailySummaryText = "Relaxed day detected. Enjoy cooking fresh, slow-cooked meals!";
      dinnerInstructions.add("Take your time to simmer the curry for deeper flavor integration.");
    }

    // 3. Scale grocery item cost based on number of people
    // Define base cost of ingredients per item
    Map<String, double> itemPrices = {
      "Bread": 40.0,
      "Tomato": 30.0,
      "Onion": 25.0,
      "Butter": 45.0,
      "Rice": 50.0,
      "Spices": 20.0,
      "Paneer": 120.0,
      "Wheat Flour": 30.0,
      "Yogurt": 40.0,
      "Tofu": 80.0,
      "Olive Oil": 60.0,
      "Broccoli": 50.0,
      "Bell Peppers": 45.0,
      "Hummus": 70.0,
      "Eggs": 40.0,
      "Mayo": 35.0,
      "Garlic": 15.0,
      "Chicken": 180.0,
      "Avocado": 90.0,
      "Spinach": 30.0,
      "Capsicum": 35.0,
      "Cauliflower": 40.0,
      "Milk": 35.0,
      "Almond Milk": 110.0,
    };

    // Calculate which ingredients are required
    Set<String> requiredIngredients = {};
    requiredIngredients.addAll(breakfastIngredients);
    requiredIngredients.addAll(lunchIngredients);
    requiredIngredients.addAll(dinnerIngredients);

    // Build the Grocery List
    List<GroceryItem> groceryList = [];
    double baseGroceryCost = 0.0;

    for (var ing in requiredIngredients) {
      // If the user already has this ingredient in their "Available Ingredients",
      // we mark it as owned, meaning they don't have to buy it, OR we reduce the price.
      // Let's say if they have it, the grocery item is already marked as checked (bought)
      // or we don't charge them for it. Let's make it so that if they have it, it's checked
      // and cost is 0, illustrating "smart savings" from using own ingredients!
      bool isOwned = cleanIngredients.contains(ing.toLowerCase());
      double pricePerUnit = itemPrices[ing] ?? 30.0;
      // Scale by people count (discounted for more people)
      double scaledPrice = pricePerUnit * (1 + (peopleCount - 1) * 0.7);
      
      groceryList.add(GroceryItem(
        name: ing,
        price: isOwned ? 0.0 : scaledPrice,
        isChecked: isOwned,
      ));

      if (!isOwned) {
        baseGroceryCost += scaledPrice;
      }
    }

    // 4. Substitution Suggestions
    // Generate default substitutions if none exist
    List<Substitution> substitutions = customSubstitutions ?? [];
    if (customSubstitutions == null) {
      if (dietPreference == "Vegetarian" || dietPreference == "Keto") {
        substitutions.add(Substitution(original: "Paneer", replacement: "Tofu", savings: 40.0 * peopleCount));
      }
      if (dietPreference == "Vegan") {
        substitutions.add(Substitution(original: "Almond Milk", replacement: "Regular Milk", savings: 60.0 * peopleCount));
      } else {
        substitutions.add(Substitution(original: "Butter", replacement: "Olive Oil", savings: 15.0 * peopleCount));
      }
    }

    // Apply any active substitutions to the meal titles, ingredients, and costs
    double substitutionSavings = 0.0;
    for (var sub in substitutions) {
      if (sub.isApplied) {
        substitutionSavings += sub.savings;
        
        // Update timeline titles and ingredients
        if (breakfastIngredients.contains(sub.original)) {
          breakfastIngredients = breakfastIngredients.map((e) => e == sub.original ? sub.replacement : e).toList();
          breakfastTitle = breakfastTitle.replaceAll(sub.original, sub.replacement);
        }
        if (lunchIngredients.contains(sub.original)) {
          lunchIngredients = lunchIngredients.map((e) => e == sub.original ? sub.replacement : e).toList();
          lunchTitle = lunchTitle.replaceAll(sub.original, sub.replacement);
        }
        if (dinnerIngredients.contains(sub.original)) {
          dinnerIngredients = dinnerIngredients.map((e) => e == sub.original ? sub.replacement : e).toList();
          dinnerTitle = dinnerTitle.replaceAll(sub.original, sub.replacement);
        }

        // Update grocery list
        groceryList = groceryList.map((item) {
          if (item.name == sub.original) {
            double pricePerUnit = itemPrices[sub.replacement] ?? 30.0;
            double scaledPrice = pricePerUnit * (1 + (peopleCount - 1) * 0.7);
            return GroceryItem(
              name: sub.replacement,
              price: item.isChecked ? 0.0 : scaledPrice,
              isChecked: item.isChecked,
            );
          }
          return item;
        }).toList();
      }
    }

    double totalCost = baseGroceryCost - substitutionSavings;
    if (totalCost < 0) totalCost = 0;

    // Estimated savings calculation:
    // Base savings from using own ingredients + substitution savings
    double ownedSavings = 0.0;
    for (var ing in requiredIngredients) {
      if (cleanIngredients.contains(ing.toLowerCase())) {
        double pricePerUnit = itemPrices[ing] ?? 30.0;
        ownedSavings += pricePerUnit * (1 + (peopleCount - 1) * 0.7);
      }
    }
    double totalEstimatedSavings = ownedSavings + substitutionSavings;

    // 5. Calculate Plan Scores
    // Budget score: high if cost is below budget
    int budgetScore = 100;
    if (totalCost > budget) {
      double overstep = totalCost - budget;
      budgetScore = (100 - (overstep / budget * 100)).round().clamp(10, 100);
    } else {
      // cost <= budget. High score, closer to 100 if we saved money.
      double ratio = totalCost / (budget == 0 ? 1 : budget);
      budgetScore = (100 - (ratio * 15)).round().clamp(85, 100);
    }

    // Time score: high if busy and time is low
    int timeScore = 95;
    if (busyLevel == "Busy") {
      timeScore = 95;
    } else if (busyLevel == "Normal") {
      timeScore = 88;
    } else {
      timeScore = 82;
    }

    // Waste reduction score: based on percentage of available ingredients used
    int wasteScore = 75;
    if (ingredients.isNotEmpty) {
      int matchedCount = 0;
      for (var userIng in cleanIngredients) {
        if (requiredIngredients.any((req) => req.toLowerCase() == userIng)) {
          matchedCount++;
        }
      }
      double matchRatio = matchedCount / ingredients.length;
      wasteScore = (70 + (matchRatio * 30)).round().clamp(70, 100);
    } else {
      wasteScore = 85; // default neutral score
    }

    // Overall Grade
    double avgScore = (budgetScore + timeScore + wasteScore) / 3;
    String grade = "A+";
    if (avgScore >= 93) {
      grade = "A+";
    } else if (avgScore >= 88) {
      grade = "A";
    } else if (avgScore >= 83) {
      grade = "B+";
    } else if (avgScore >= 78) {
      grade = "B";
    } else {
      grade = "C";
    }

    int totalPrepTime = breakfastTime + lunchTime + dinnerTime;

    return MealPlan(
      dailySummary: dailySummaryText,
      timeline: [
        MealTimelineItem(
          time: "07:30 AM",
          mealType: "Breakfast",
          title: breakfastTitle,
          prepTimeMinutes: breakfastTime,
          ingredients: breakfastIngredients,
          instructions: breakfastInstructions,
        ),
        MealTimelineItem(
          time: "01:00 PM",
          mealType: "Lunch",
          title: lunchTitle,
          prepTimeMinutes: lunchTime,
          ingredients: lunchIngredients,
          instructions: lunchInstructions,
        ),
        MealTimelineItem(
          time: "08:00 PM",
          mealType: "Dinner",
          title: dinnerTitle,
          prepTimeMinutes: dinnerTime,
          ingredients: dinnerIngredients,
          instructions: dinnerInstructions,
        ),
      ],
      groceryList: groceryList,
      substitutions: substitutions,
      score: PlanScore(
        budgetScore: budgetScore,
        timeScore: timeScore,
        wasteScore: wasteScore,
        grade: grade,
      ),
      estimatedCookingTimeMinutes: totalPrepTime,
      estimatedSavings: totalEstimatedSavings,
      totalCost: totalCost,
      budget: budget,
    );
  }
}
