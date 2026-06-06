import 'dart:ui';
import 'package:flutter/material.dart';

class PlanScorePanel extends StatelessWidget {
  final int budgetScore;
  final int timeScore;
  final int wasteScore;
  final String grade;

  const PlanScorePanel({
    super.key,
    required this.budgetScore,
    required this.timeScore,
    required this.wasteScore,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define grade color coding
    Color gradeColor;
    if (grade.startsWith("A")) {
      gradeColor = Colors.greenAccent;
    } else if (grade.startsWith("B")) {
      gradeColor = Colors.amberAccent;
    } else {
      gradeColor = Colors.redAccent;
    }

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
                    Icons.speed_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "PLAN SCORE",
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

              // Layout: Score details and big grade badge side-by-side or stacked
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTight = constraints.maxWidth < 280;
                  
                  final scoresColumn = Column(
                    children: [
                      _buildScoreRow("Budget Score", budgetScore, Colors.green, context),
                      const SizedBox(height: 12),
                      _buildScoreRow("Time Score", timeScore, Colors.blue, context),
                      const SizedBox(height: 12),
                      _buildScoreRow("Waste Reduction", wasteScore, Colors.orange, context),
                    ],
                  );

                  final gradeBadge = Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            gradeColor.withOpacity(0.25),
                            gradeColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: gradeColor.withOpacity(0.8),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gradeColor.withOpacity(0.2),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            grade,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            "Grade",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                  if (isTight) {
                    return Column(
                      children: [
                        gradeBadge,
                        const SizedBox(height: 20),
                        scoresColumn,
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(flex: 5, child: scoresColumn),
                        const SizedBox(width: 24),
                        Expanded(flex: 4, child: gradeBadge),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(String name, int score, Color color, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            Text(
              "$score%",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: score / 100.0,
            minHeight: 6,
            backgroundColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.06),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
