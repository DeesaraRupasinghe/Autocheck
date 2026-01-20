import '../models/models.dart';
import '../core/constants/app_constants.dart';

/// Service for calculating vehicle health scores based on inspection results
/// Implements weighted scoring system with risk categorization
class HealthScoreService {
  /// Calculate overall health score from inspection items
  HealthScoreResult calculateHealthScore(List<InspectionItem> items) {
    if (items.isEmpty) {
      return const HealthScoreResult(
        score: 0,
        riskLevel: RiskLevel.highRisk,
        recommendation: 'No inspection data available',
        categoryScores: {},
      );
    }

    int totalWeight = 0;
    int weightedScore = 0;
    final Map<String, int> categoryScores = {};
    final Map<String, int> categoryWeights = {};

    for (final item in items) {
      totalWeight += item.riskWeight;

      // Calculate score based on answer
      int itemScore = 0;
      switch (item.answer) {
        case InspectionAnswer.yes:
          // Yes means good condition
          itemScore = item.riskWeight;
          break;
        case InspectionAnswer.no:
          // No means problem found
          itemScore = 0;
          break;
        case InspectionAnswer.notSure:
          // Not sure gets partial credit
          itemScore = (item.riskWeight * 0.5).round();
          break;
        case null:
          // Unanswered items get 0
          itemScore = 0;
          break;
      }

      weightedScore += itemScore;

      // Track category scores
      categoryScores[item.category] =
          (categoryScores[item.category] ?? 0) + itemScore;
      categoryWeights[item.category] =
          (categoryWeights[item.category] ?? 0) + item.riskWeight;
    }

    // Calculate percentage score
    final score =
        totalWeight > 0 ? ((weightedScore / totalWeight) * 100).round() : 0;

    // Calculate category percentages
    final Map<String, int> categoryPercentages = {};
    for (final category in categoryScores.keys) {
      final categoryWeight = categoryWeights[category] ?? 1;
      categoryPercentages[category] =
          ((categoryScores[category]! / categoryWeight) * 100).round();
    }

    // Determine risk level
    final riskLevel = _determineRiskLevel(score);

    // Generate recommendation
    final recommendation = _generateRecommendation(score, categoryPercentages);

    return HealthScoreResult(
      score: score,
      riskLevel: riskLevel,
      recommendation: recommendation,
      categoryScores: categoryPercentages,
    );
  }

  RiskLevel _determineRiskLevel(int score) {
    if (score >= AppConstants.healthScoreGreenMin) {
      return RiskLevel.safe;
    } else if (score >= AppConstants.healthScoreYellowMin) {
      return RiskLevel.mediumRisk;
    } else {
      return RiskLevel.highRisk;
    }
  }

  String _generateRecommendation(int score, Map<String, int> categoryScores) {
    if (score >= AppConstants.healthScoreGreenMin) {
      return 'This vehicle appears to be in good condition. '
          'You may proceed with a professional inspection to confirm.';
    } else if (score >= AppConstants.healthScoreYellowMin) {
      // Find problematic categories
      final problemAreas = categoryScores.entries
          .where((e) => e.value < 60)
          .map((e) => e.key)
          .toList();

      if (problemAreas.isNotEmpty) {
        return 'Some concerns found in: ${problemAreas.join(', ')}. '
            'Recommend professional inspection before purchase.';
      }
      return 'Some concerns were identified. '
          'Consider getting a professional inspection before making a decision.';
    } else {
      final majorIssues = categoryScores.entries
          .where((e) => e.value < 40)
          .map((e) => e.key)
          .toList();

      if (majorIssues.isNotEmpty) {
        return 'WARNING: Significant issues found in: ${majorIssues.join(', ')}. '
            'Consider avoiding this vehicle unless issues are addressed.';
      }
      return 'WARNING: Multiple issues detected. '
          'This vehicle may have significant problems. Consider avoiding.';
    }
  }

  /// Validate if an inspection is complete enough to calculate score
  bool isInspectionComplete(List<InspectionItem> items) {
    if (items.isEmpty) return false;

    // At least 60% of items should be answered
    final answeredCount = items.where((item) => item.answer != null).length;
    return answeredCount >= items.length * 0.6;
  }

  /// Get critical items that need attention
  List<InspectionItem> getCriticalIssues(List<InspectionItem> items) {
    return items
        .where((item) =>
            item.answer == InspectionAnswer.no && item.riskWeight >= 8)
        .toList();
  }

  /// Get items marked as "not sure" for follow-up
  List<InspectionItem> getUncertainItems(List<InspectionItem> items) {
    return items.where((item) => item.answer == InspectionAnswer.notSure).toList();
  }
}

/// Result of health score calculation
class HealthScoreResult {
  final int score;
  final RiskLevel riskLevel;
  final String recommendation;
  final Map<String, int> categoryScores;

  const HealthScoreResult({
    required this.score,
    required this.riskLevel,
    required this.recommendation,
    required this.categoryScores,
  });
}
