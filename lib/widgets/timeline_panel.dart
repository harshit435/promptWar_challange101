import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/meal_plan.dart';

class TimelinePanel extends StatefulWidget {
  final List<MealTimelineItem> timelineItems;

  const TimelinePanel({
    super.key,
    required this.timelineItems,
  });

  @override
  State<TimelinePanel> createState() => _TimelinePanelState();
}

class _TimelinePanelState extends State<TimelinePanel> {
  // Store indexes of expanded cards
  final Set<int> _expandedIndices = {};
  // Store indexes of completed meals
  final Set<int> _cookedIndices = {};

  void _toggleExpanded(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  void _toggleCooked(int index) {
    setState(() {
      if (_cookedIndices.contains(index)) {
        _cookedIndices.remove(index);
      } else {
        _cookedIndices.add(index);
      }
    });
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
              // Panel Header
              Row(
                children: [
                  Icon(
                    Icons.dashboard_customize_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "TODAY'S MEAL TIMELINE",
                    style: TextStyle(
                      fontSize: 14,
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

              // Vertical Timeline list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.timelineItems.length,
                itemBuilder: (context, index) {
                  final item = widget.timelineItems[index];
                  final isExpanded = _expandedIndices.contains(index);
                  final isCooked = _cookedIndices.contains(index);
                  final isLast = index == widget.timelineItems.length - 1;

                  // Define icons based on meal type
                  IconData mealIcon;
                  Color iconColor;
                  if (item.mealType.toLowerCase() == "breakfast") {
                    mealIcon = Icons.wb_twilight_rounded;
                    iconColor = Colors.orange;
                  } else if (item.mealType.toLowerCase() == "lunch") {
                    mealIcon = Icons.light_mode_rounded;
                    iconColor = Colors.amber;
                  } else {
                    mealIcon = Icons.nightlight_round;
                    iconColor = Colors.indigoAccent;
                  }

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left timeline line & markers
                        Column(
                          children: [
                            // Time stamp
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Dot indicator
                            InkWell(
                              onTap: () => _toggleCooked(index),
                              borderRadius: BorderRadius.circular(100),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isCooked
                                      ? Colors.green
                                      : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04)),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isCooked
                                        ? Colors.green
                                        : (isDark ? Colors.white24 : Colors.black26),
                                    width: 2,
                                  ),
                                ),
                                child: isCooked
                                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                    : Icon(mealIcon, color: iconColor, size: 14),
                              ),
                            ),
                            // Line connecting dots
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08),
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Meal Card Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn,
                              decoration: BoxDecoration(
                                color: isCooked
                                    ? (isDark ? Colors.green.withOpacity(0.05) : Colors.green.withOpacity(0.03))
                                    : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.015)),
                                border: Border.all(
                                  color: isCooked
                                      ? Colors.green.withOpacity(0.4)
                                      : (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04)),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  onTap: () => _toggleExpanded(index),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Header Row
                                        Row(
                                          children: [
                                            Text(
                                              item.mealType.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.0,
                                                color: isCooked
                                                    ? Colors.green
                                                    : (isDark ? Colors.white.withOpacity(0.5) : Colors.black54),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.timer_outlined, size: 12, color: Colors.blueGrey),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${item.prepTimeMinutes} mins",
                                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        // Recipe Title
                                        Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration: isCooked ? TextDecoration.lineThrough : null,
                                            color: isCooked
                                                ? (isDark ? Colors.white60 : Colors.black45)
                                                : (isDark ? Colors.white : Colors.black87),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // Tap to reveal instruction label
                                        Row(
                                          children: [
                                            Icon(
                                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                              size: 14,
                                              color: Colors.blueGrey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isExpanded ? "Collapse Recipe" : "Tap for recipe & steps",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.blueGrey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Expandable Details Section
                                        if (isExpanded) ...[
                                          const SizedBox(height: 12),
                                          Divider(color: isDark ? Colors.white12 : Colors.black12),
                                          const SizedBox(height: 8),
                                          // Ingredients required for this meal
                                          const Text(
                                            "Ingredients used:",
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 6,
                                            children: item.ingredients.map((ing) {
                                              return Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                                                  ),
                                                ),
                                                child: Text(
                                                  ing,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: isDark ? Colors.white70 : Colors.black.withOpacity(0.7),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          const SizedBox(height: 12),
                                          // Step instructions
                                          const Text(
                                            "Preparation Steps:",
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 6),
                                          ...item.instructions.asMap().entries.map((entry) {
                                            int idx = entry.key + 1;
                                            String step = entry.value;
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 6.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "$idx. ",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).colorScheme.primary,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      step,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        height: 1.3,
                                                        color: isDark ? Colors.white70 : Colors.black.withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
