import 'dart:ui';
import 'package:flutter/material.dart';

class ContextInputPanel extends StatefulWidget {
  final String busyLevel;
  final double budget;
  final int peopleCount;
  final String dietPreference;
  final List<String> ingredients;
  final bool isLoading;
  final Function(String) onBusyLevelChanged;
  final Function(double) onBudgetChanged;
  final Function(int) onPeopleCountChanged;
  final Function(String) onDietPreferenceChanged;
  final Function(List<String>) onIngredientsChanged;
  final VoidCallback onGeneratePressed;

  const ContextInputPanel({
    super.key,
    required this.busyLevel,
    required this.budget,
    required this.peopleCount,
    required this.dietPreference,
    required this.ingredients,
    required this.isLoading,
    required this.onBusyLevelChanged,
    required this.onBudgetChanged,
    required this.onPeopleCountChanged,
    required this.onDietPreferenceChanged,
    required this.onIngredientsChanged,
    required this.onGeneratePressed,
  });

  @override
  State<ContextInputPanel> createState() => _ContextInputPanelState();
}

class _ContextInputPanelState extends State<ContextInputPanel> {
  final TextEditingController _ingredientController = TextEditingController();
  bool _isAddingIngredient = false;

  void _addIngredient() {
    final text = _ingredientController.text.trim();
    if (text.isNotEmpty) {
      final updated = List<String>.from(widget.ingredients);
      if (!updated.map((e) => e.toLowerCase()).contains(text.toLowerCase())) {
        updated.add(text);
        widget.onIngredientsChanged(updated);
      }
      _ingredientController.clear();
      setState(() {
        _isAddingIngredient = false;
      });
    }
  }

  void _removeIngredient(String name) {
    final updated = List<String>.from(widget.ingredients)..remove(name);
    widget.onIngredientsChanged(updated);
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.35) : Colors.white.withOpacity(0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "TODAY'S CONTEXT",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                thickness: 1,
              ),
              const SizedBox(height: 16),

              // How busy are you today?
              Text(
                "How busy are you today?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: ["Busy", "Normal", "Relaxed"].map((level) {
                  final isSelected = widget.busyLevel == level;
                  IconData icon;
                  Color activeColor;
                  if (level == "Busy") {
                    icon = Icons.bolt_rounded;
                    activeColor = Colors.amber;
                  } else if (level == "Normal") {
                    icon = Icons.schedule_rounded;
                    activeColor = Colors.blue;
                  } else {
                    icon = Icons.spa_rounded;
                    activeColor = Colors.green;
                  }

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Tooltip(
                        message: "Select $level cooking pace",
                        child: InkWell(
                          onTap: () => widget.onBusyLevelChanged(level),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                      ? activeColor.withOpacity(0.25)
                                      : activeColor.withOpacity(0.15))
                                  : (isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.black.withOpacity(0.03)),
                              border: Border.all(
                                color: isSelected
                                    ? activeColor
                                    : (isDark
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.black.withOpacity(0.08)),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  color: isSelected
                                      ? activeColor
                                      : (isDark ? Colors.white.withOpacity(0.5) : Colors.black45),
                                  size: 20,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  level,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected
                                        ? (isDark ? Colors.white : Colors.black87)
                                        : (isDark ? Colors.white60 : Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Budget Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Budget",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  Text(
                    "₹${widget.budget.round()}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
                  thumbColor: Theme.of(context).colorScheme.primary,
                  overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  trackHeight: 4.0,
                ),
                child: Slider(
                  value: widget.budget,
                  min: 100,
                  max: 2000,
                  divisions: 38, // steps of ₹50
                  label: "₹${widget.budget.round()}",
                  onChanged: widget.onBudgetChanged,
                ),
              ),
              const SizedBox(height: 16),

              // Number of People & Diet Preference row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Number of People
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "People",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_rounded, size: 16),
                                onPressed: widget.peopleCount > 1
                                    ? () => widget.onPeopleCountChanged(widget.peopleCount - 1)
                                    : null,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                splashRadius: 20,
                              ),
                              Text(
                                "${widget.peopleCount}",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_rounded, size: 16),
                                onPressed: widget.peopleCount < 10
                                    ? () => widget.onPeopleCountChanged(widget.peopleCount + 1)
                                    : null,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Diet Preference
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Diet Preference",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: widget.dietPreference,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              dropdownColor: isDark ? Colors.grey[900] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              isExpanded: true,
                              onChanged: (val) {
                                if (val != null) widget.onDietPreferenceChanged(val);
                              },
                              items: ["Vegetarian", "Vegan", "Non-Vegetarian", "Keto", "Gluten-Free"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Ingredients Available
              Text(
                "Ingredients Available",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ...widget.ingredients.map((ing) {
                    return InputChip(
                      label: Text(ing),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      backgroundColor: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04),
                      deleteIconColor: isDark ? Colors.white60 : Colors.black54,
                      onDeleted: () => _removeIngredient(ing),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.08),
                        ),
                      ),
                    );
                  }),
                  if (_isAddingIngredient)
                    Container(
                      width: 140,
                      height: 32,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _ingredientController,
                        autofocus: true,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: "Ingredient name...",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.check_rounded, size: 14),
                            onPressed: _addIngredient,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        onSubmitted: (_) => _addIngredient(),
                      ),
                    )
                  else
                    ActionChip(
                      avatar: Icon(
                        Icons.add_rounded,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      label: const Text("+ Add Ingredient"),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isAddingIngredient = true;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 28),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: widget.isLoading ? null : widget.onGeneratePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                "Generate Smart Plan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
