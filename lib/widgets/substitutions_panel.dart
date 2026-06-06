import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/meal_plan.dart';

class SubstitutionsPanel extends StatelessWidget {
  final List<Substitution> substitutions;
  final Function(Substitution) onSubstitutionToggled;

  const SubstitutionsPanel({
    super.key,
    required this.substitutions,
    required this.onSubstitutionToggled,
  });

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
              // Header
              Row(
                children: [
                  Icon(
                    Icons.swap_horiz_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "SMART SUBSTITUTIONS",
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
              const SizedBox(height: 12),

              substitutions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "No substitutions suggested for this plan.",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white.withOpacity(0.5) : Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: substitutions.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final sub = substitutions[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: sub.isApplied
                                ? (isDark ? Colors.green.withOpacity(0.1) : Colors.green.withOpacity(0.05))
                                : (isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02)),
                            border: Border.all(
                              color: sub.isApplied
                                  ? Colors.green.withOpacity(0.4)
                                  : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // Substitution text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          sub.original,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            decoration: sub.isApplied ? TextDecoration.lineThrough : null,
                                            color: sub.isApplied
                                                ? (isDark ? Colors.white.withOpacity(0.5) : Colors.black45)
                                                : (isDark ? Colors.white : Colors.black87),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_right_alt_rounded,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          sub.replacement,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: sub.isApplied
                                                ? Colors.green
                                                : (isDark ? Colors.white : Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Save ₹${sub.savings.round()}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Apply / Applied Button
                              ElevatedButton(
                                onPressed: () => onSubstitutionToggled(sub),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: sub.isApplied
                                      ? Colors.green
                                      : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
                                  foregroundColor: sub.isApplied ? Colors.white : (isDark ? Colors.white : Colors.black87),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: sub.isApplied
                                          ? Colors.green
                                          : (isDark ? Colors.white12 : Colors.black12),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                child: Text(
                                  sub.isApplied ? "Applied" : "Apply",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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
