import '../profile/data/models/user_profile.dart';
import '../schemes/data/models/scheme.dart';

class EligibilityResult {
  final bool isEligible;
  final double matchScore;
  final String status;
  final String reason;
  final List<String> matchedCriteria;
  final List<String> unmatchedCriteria;

  EligibilityResult({
    required this.isEligible,
    required this.matchScore,
    required this.status,
    required this.reason,
    required this.matchedCriteria,
    required this.unmatchedCriteria,
  });
}

class EligibilityService {
  EligibilityResult checkEligibility(UserProfile user, Scheme scheme) {
    final matched = <String>[];
    final unmatched = <String>[];
    double score = 0.0;
    int totalCriteria = 0;

    // Check Age
    if (scheme.eligibility.minAge != null || scheme.eligibility.maxAge != null) {
      totalCriteria++;
      if (_checkAge(user.age, scheme.eligibility.minAge, scheme.eligibility.maxAge)) {
        matched.add('Age requirement met');
        score += 1.0;
      } else {
        unmatched.add('Age requirement not met');
      }
    }

    // Check Category
    if (scheme.eligibility.categories.isNotEmpty &&
        !scheme.eligibility.categories.contains('All')) {
      totalCriteria++;
      if (scheme.eligibility.categories.contains(user.category)) {
        matched.add('Category: ${user.category}');
        score += 1.0;
      } else {
        unmatched.add('Category: ${user.category} not eligible');
      }
    }

    // Check Occupation
    if (scheme.eligibility.occupations.isNotEmpty &&
        !scheme.eligibility.occupations.contains('All')) {
      totalCriteria++;
      if (scheme.eligibility.occupations.contains(user.occupation)) {
        matched.add('Occupation: ${user.occupation}');
        score += 1.0;
      } else {
        unmatched.add('Occupation: ${user.occupation} not eligible');
      }
    }

    // Check State
    if (scheme.eligibility.states.isNotEmpty &&
        !scheme.eligibility.states.contains('All')) {
      totalCriteria++;
      if (scheme.eligibility.states.contains(user.location.state)) {
        matched.add('State: ${user.location.state}');
        score += 1.0;
      } else {
        unmatched.add('State: ${user.location.state} not covered');
      }
    }

    // Check Education
    if (scheme.eligibility.education.isNotEmpty &&
        !scheme.eligibility.education.contains('All')) {
      totalCriteria++;
      if (scheme.eligibility.education.contains(user.education)) {
        matched.add('Education: ${user.education}');
        score += 1.0;
      } else {
        unmatched.add('Education: ${user.education} not matching');
      }
    }

    // Check Income
    if (scheme.eligibility.incomeMax != null) {
      totalCriteria++;
      if (_checkIncome(user.income, scheme.eligibility.incomeMax!)) {
        matched.add('Income within limit');
        score += 1.0;
      } else {
        unmatched.add('Income exceeds limit');
      }
    }

    // Calculate final score
    final matchScore = totalCriteria > 0 ? score / totalCriteria : 0.0;

    // Determine eligibility status
    String status;
    String reason;
    bool isEligible;

    if (matchScore >= 1.0) {
      status = 'eligible';
      reason = 'You meet all the eligibility criteria for this scheme';
      isEligible = true;
    } else if (matchScore >= 0.7) {
      status = 'may_be_eligible';
      reason = 'You meet most criteria. Manual verification may be required';
      isEligible = true;
    } else if (matchScore >= 0.5) {
      status = 'may_be_eligible';
      reason = 'You meet some criteria. Please check with authorities';
      isEligible = false;
    } else {
      status = 'not_eligible';
      reason = 'You do not meet the minimum eligibility criteria';
      isEligible = false;
    }

    return EligibilityResult(
      isEligible: isEligible,
      matchScore: matchScore,
      status: status,
      reason: reason,
      matchedCriteria: matched,
      unmatchedCriteria: unmatched,
    );
  }

  bool _checkAge(int userAge, int? minAge, int? maxAge) {
    if (minAge != null && userAge < minAge) return false;
    if (maxAge != null && userAge > maxAge) return false;
    return true;
  }

  bool _checkIncome(String userIncome, String maxIncome) {
    // Simple income comparison logic
    // You can enhance this based on actual income range format
    final incomeOrder = [
      'Below 1L',
      '1-2L',
      '2-5L',
      '5-10L',
      'Above 10L',
    ];

    final userIndex = incomeOrder.indexOf(userIncome);
    final maxIndex = incomeOrder.indexOf(maxIncome);

    if (userIndex == -1 || maxIndex == -1) return true; // If format unknown, allow
    return userIndex <= maxIndex;
  }

  List<Scheme> filterEligibleSchemes(UserProfile user, List<Scheme> schemes) {
    return schemes.where((scheme) {
      final result = checkEligibility(user, scheme);
      return result.isEligible;
    }).toList();
  }

  List<Scheme> rankSchemesByEligibility(UserProfile user, List<Scheme> schemes) {
    final rankedSchemes = schemes.map((scheme) {
      final result = checkEligibility(user, scheme);
      return {'scheme': scheme, 'score': result.matchScore};
    }).toList();

    rankedSchemes.sort((a, b) => 
      (b['score'] as double).compareTo(a['score'] as double));

    return rankedSchemes.map((item) => item['scheme'] as Scheme).toList();
  }
}
