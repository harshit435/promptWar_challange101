import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/meal_plan.dart';

class GroceryBudgetSavingsPanel extends StatefulWidget {
  final List<GroceryItem> groceryList;
  final double budget;
  final double totalCost;
  final double estimatedSavings;
  final Function(List<GroceryItem>) onGroceryListChanged;

  const GroceryBudgetSavingsPanel({
    super.key,
    required this.groceryList,
    required this.budget,
    required this.totalCost,
    required this.estimatedSavings,
    required this.onGroceryListChanged,
  });

  @override
  State<GroceryBudgetSavingsPanel> createState() => _GroceryBudgetSavingsPanelState();
}

class _GroceryBudgetSavingsPanelState extends State<GroceryBudgetSavingsPanel> {
  void _toggleGroceryItem(int index, bool? checked) {
    if (checked == null) return;
    final updatedList = List<GroceryItem>.from(widget.groceryList);
    updatedList[index] = updatedList[index].copyWith(isChecked: checked);
    widget.onGroceryListChanged(updatedList);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remainingBudget = widget.budget - widget.totalCost;
    final isOverBudget = remainingBudget < 0;
    
    // Calculate progress ratio
    double progressRatio = 0.0;
    if (widget.budget > 0) {
      progressRatio = widget.totalCost / widget.budget;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;

        if (isMobile) {
          return Column(
            children: [
              _buildGroceryCard(isDark),
              const SizedBox(height: 16),
              _buildBudgetCard(isDark, remainingBudget, isOverBudget, progressRatio),
              const SizedBox(height: 16),
              _buildSavingsCard(isDark),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildGroceryCard(isDark)),
              const SizedBox(width: 16),
              Expanded(child: _buildBudgetCard(isDark, remainingBudget, isOverBudget, progressRatio)),
              const SizedBox(width: 16),
              Expanded(child: _buildSavingsCard(isDark)),
            ],
          );
        }
      },
    );
  }

  // 1. Grocery List Widget
  Widget _buildGroceryCard(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.shopping_basket_rounded, color: Colors.amber[700], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Grocery List",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: isDark ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
              const SizedBox(height: 4),

              // Grocery Checkbox List
              Expanded(
                child: widget.groceryList.isEmpty
                    ? Center(
                        child: Text(
                          "No grocery items needed!",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white.withOpacity(0.5) : Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: widget.groceryList.length,
                          itemBuilder: (context, idx) {
                            final item = widget.groceryList[idx];
                            return Material(
                              color: Colors.transparent,
                              child: CheckboxListTile(
                                value: item.isChecked,
                                title: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                    color: item.isChecked
                                        ? (isDark ? Colors.white38 : Colors.black38)
                                        : (isDark ? Colors.white : Colors.black87),
                                  ),
                                ),
                                subtitle: item.price > 0
                                    ? Text(
                                        "Est: ₹${item.price.round()}",
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      )
                                    : const Text(
                                        "In Kitchen (Saved!)",
                                        style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w500),
                                      ),
                                onChanged: (checked) => _toggleGroceryItem(idx, checked),
                                activeColor: Theme.of(context).colorScheme.primary,
                                checkColor: Colors.white,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            );
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

  // 2. Budget Analysis Widget
  Widget _buildBudgetCard(bool isDark, double remainingBudget, bool isOverBudget, double progressRatio) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.pie_chart_rounded, color: Colors.blueAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Budget Analysis",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: isDark ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
              const SizedBox(height: 12),

              // Details Row
              _buildMetricRow("Budget Limit", "₹${widget.budget.round()}", isDark),
              const SizedBox(height: 8),
              _buildMetricRow("Est. Cost", "₹${widget.totalCost.round()}", isDark),
              const SizedBox(height: 8),
              _buildMetricRow(
                isOverBudget ? "Over Budget" : "Remaining",
                "₹${remainingBudget.abs().round()}",
                isDark,
                valueColor: isOverBudget ? Colors.redAccent : Colors.green,
                isBold: true,
              ),

              const Spacer(),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressRatio.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOverBudget
                        ? Colors.redAccent
                        : (progressRatio > 0.85 ? Colors.amber : Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${(progressRatio * 100).round()}% Spent",
                    style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  if (isOverBudget)
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 12, color: Colors.redAccent),
                        SizedBox(width: 4),
                        Text(
                          "Reduce items to fit budget",
                          style: TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper row builder
  Widget _buildMetricRow(String title, String value, bool isDark, {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }

  // 3. Savings Widget
  Widget _buildSavingsCard(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.stars_rounded, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Savings",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: isDark ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
              const SizedBox(height: 16),

              // Visual representation
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Saved ₹${widget.estimatedSavings.round()}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.estimatedSavings > 0
                            ? "Congrats! Using home ingredients and smart subs saved you money today!"
                            : "Add ingredients you already own to unlock smart kitchen savings!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.3,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
