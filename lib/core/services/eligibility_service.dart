import '../../features/profile/data/models/user_profile.dart';
import '../../features/schemes/data/models/scheme.dart';

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
    int mandatoryCriteria = 0;
    int mandatoryMatched = 0;

    // MANDATORY: Check Gender (must match if specified)
    if (scheme.eligibility.genders.isNotEmpty &&
        !scheme.eligibility.genders.contains('All')) {
      mandatoryCriteria++;
      totalCriteria++;
      
      // Extract base gender from complex strings like "Female (pregnant women)"
      bool genderMatches = false;
      for (final eligibleGender in scheme.eligibility.genders) {
        final baseGender = _extractBaseGender(eligibleGender);
        if (baseGender == user.gender || baseGender == 'All') {
          genderMatches = true;
          break;
        }
      }
      
      if (genderMatches) {
        matched.add('Gender: ${user.gender}');
        score += 1.0;
        mandatoryMatched++;
      } else {
        unmatched.add('Gender: Scheme is for ${scheme.eligibility.genders.join(", ")}');
        // Return immediately for gender mismatch - this is mandatory
        return EligibilityResult(
          isEligible: false,
          matchScore: 0.0,
          status: 'not_eligible',
          reason: 'This scheme is exclusively for ${scheme.eligibility.genders.join(", ")}',
          matchedCriteria: [],
          unmatchedCriteria: ['Gender requirement not met'],
        );
      }
    }

    // MANDATORY: Check Age
    if (scheme.eligibility.minAge != null || scheme.eligibility.maxAge != null) {
      mandatoryCriteria++;
      totalCriteria++;
      if (_checkAge(user.age, scheme.eligibility.minAge, scheme.eligibility.maxAge)) {
        matched.add('Age: ${user.age} years');
        score += 1.0;
        mandatoryMatched++;
      } else {
        unmatched.add('Age: Must be between ${scheme.eligibility.minAge ?? 0}-${scheme.eligibility.maxAge ?? "any"} years');
      }
    }

    // MANDATORY: Check Category (if not "All")
    if (scheme.eligibility.categories.isNotEmpty &&
        !scheme.eligibility.categories.contains('All')) {
      mandatoryCriteria++;
      totalCriteria++;
      if (scheme.eligibility.categories.contains(user.category)) {
        matched.add('Category: ${user.category}');
        score += 1.0;
        mandatoryMatched++;
      } else {
        unmatched.add('Category: Scheme is for ${scheme.eligibility.categories.join(", ")}');
      }
    }

    // MANDATORY: Check Occupation (if not "All")
    if (scheme.eligibility.occupations.isNotEmpty &&
        !scheme.eligibility.occupations.contains('All')) {
      mandatoryCriteria++;
      totalCriteria++;
      if (scheme.eligibility.occupations.contains(user.occupation)) {
        matched.add('Occupation: ${user.occupation}');
        score += 1.0;
        mandatoryMatched++;
      } else {
        unmatched.add('Occupation: Scheme is for ${scheme.eligibility.occupations.join(", ")}');
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

    // STRICT: All mandatory criteria must be met
    final mandatoryScore = mandatoryCriteria > 0 ? mandatoryMatched / mandatoryCriteria : 1.0;
    
    // Determine eligibility status
    String status;
    String reason;
    bool isEligible;

    // Must meet ALL mandatory criteria (age, gender, category, occupation if specified)
    if (mandatoryScore < 1.0) {
      status = 'not_eligible';
      reason = 'Does not meet mandatory requirements: ${unmatched.take(3).join(", ")}';
      isEligible = false;
    } else if (matchScore >= 1.0) {
      status = 'eligible';
      reason = 'You meet all the eligibility criteria for this scheme';
      isEligible = true;
    } else if (matchScore >= 0.7) {
      status = 'may_be_eligible';
      reason = 'You meet core requirements. Some optional criteria pending';
      isEligible = true;
    } else if (matchScore >= 0.5) {
      status = 'partially_eligible';
      reason = 'You meet some criteria. Please verify with authorities';
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

  String _extractBaseGender(String genderString) {
    // Extract base gender from strings like "Female (pregnant women)"
    final lower = genderString.toLowerCase();
    if (lower.contains('female') || lower.contains('women') || lower.contains('girl')) {
      return 'Female';
    } else if (lower.contains('male') || lower.contains('men') || lower.contains('boy')) {
      return 'Male';
    } else if (lower.contains('transgender')) {
      return 'Transgender';
    }
    return genderString; // Return as-is if can't parse
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
