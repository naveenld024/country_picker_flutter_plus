import '../models/country_info.dart';

/// Simple fuzzy search implementation for country searching
class FuzzySearchEngine {
  /// Search countries with basic fuzzy matching
  static List<CountrySearchResult> searchCountries(
    List<CountryInfo> countries,
    String query, {
    double threshold = 0.3,
    int maxResults = 50,
  }) {
    if (query.isEmpty) {
      return countries
          .map((country) => CountrySearchResult(country, 1.0, SearchMatchType.exact))
          .toList();
    }

    final results = <CountrySearchResult>[];
    final lowerQuery = query.toLowerCase();

    for (final country in countries) {
      final score = _calculateCountryScore(country, lowerQuery);
      if (score >= threshold) {
        final matchType = _determineMatchType(country, lowerQuery);
        results.add(CountrySearchResult(country, score, matchType));
      }
    }

    // Sort by score (descending) and then by name
    results.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) return scoreComparison;
      return a.country.name.compareTo(b.country.name);
    });

    return results.take(maxResults).toList();
  }

  /// Calculate fuzzy match score for a country
  static double _calculateCountryScore(CountryInfo country, String query) {
    double maxScore = 0.0;

    // Check exact matches first (highest score)
    if (country.name.toLowerCase() == query) return 1.0;
    if (country.code.toLowerCase() == query) return 0.95;
    if (country.phoneCode.replaceAll('+', '') == query.replaceAll('+', '')) return 0.9;

    // Check starts with matches
    if (country.name.toLowerCase().startsWith(query)) {
      maxScore = 0.85;
    } else if (country.code.toLowerCase().startsWith(query)) {
      maxScore = 0.8;
    }

    // Check contains matches
    if (country.name.toLowerCase().contains(query)) {
      maxScore = maxScore > 0 ? maxScore : 0.7;
    }

    // Check native name
    if (country.nativeName != null) {
      if (country.nativeName!.toLowerCase() == query) {
        maxScore = maxScore > 0.9 ? maxScore : 0.9;
      } else if (country.nativeName!.toLowerCase().startsWith(query)) {
        maxScore = maxScore > 0.75 ? maxScore : 0.75;
      } else if (country.nativeName!.toLowerCase().contains(query)) {
        maxScore = maxScore > 0.6 ? maxScore : 0.6;
      }
    }

    // Check capital
    if (country.capital != null && country.capital!.toLowerCase().contains(query)) {
      maxScore = maxScore > 0.5 ? maxScore : 0.5;
    }

    // Note: alternativeNames not available in simplified model

    // Fuzzy string matching for typos
    if (maxScore < 0.5) {
      final fuzzyScore = _calculateLevenshteinScore(country.name.toLowerCase(), query);
      if (fuzzyScore > 0.6) {
        maxScore = maxScore > fuzzyScore * 0.8 ? maxScore : fuzzyScore * 0.8;
      }
    }

    return maxScore;
  }

  /// Determine the type of match found
  static SearchMatchType _determineMatchType(CountryInfo country, String query) {
    final lowerName = country.name.toLowerCase();
    final lowerCode = country.code.toLowerCase();
    final phoneCode = country.phoneCode.replaceAll('+', '');
    final queryCode = query.replaceAll('+', '');

    if (lowerName == query || lowerCode == query || phoneCode == queryCode) {
      return SearchMatchType.exact;
    }

    if (lowerName.startsWith(query) || lowerCode.startsWith(query)) {
      return SearchMatchType.startsWith;
    }

    if (lowerName.contains(query) || lowerCode.contains(query)) {
      return SearchMatchType.contains;
    }

    if (country.nativeName?.toLowerCase().contains(query) == true) {
      return SearchMatchType.nativeName;
    }

    if (country.capital?.toLowerCase().contains(query) == true) {
      return SearchMatchType.capital;
    }

    // Note: alternativeNames not available in simplified model

    return SearchMatchType.fuzzy;
  }

  /// Calculate Levenshtein distance-based score
  static double _calculateLevenshteinScore(String s1, String s2) {
    if (s1.isEmpty) return s2.isEmpty ? 1.0 : 0.0;
    if (s2.isEmpty) return 0.0;

    final distance = _levenshteinDistance(s1, s2);
    final maxLength = s1.length > s2.length ? s1.length : s2.length;

    return 1.0 - (distance / maxLength);
  }

  /// Calculate Levenshtein distance between two strings
  static int _levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;

    final matrix = List.generate(
      len1 + 1,
      (i) => List.filled(len2 + 1, 0),
    );

    for (int i = 0; i <= len1; i++) {
      matrix[i][0] = i;
    }

    for (int j = 0; j <= len2; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,      // deletion
          matrix[i][j - 1] + 1,      // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[len1][len2];
  }
}

/// Result of a country search with scoring information
class CountrySearchResult {
  final CountryInfo country;
  final double score;
  final SearchMatchType matchType;

  const CountrySearchResult(this.country, this.score, this.matchType);

  @override
  String toString() {
    return 'CountrySearchResult(${country.name}, score: ${score.toStringAsFixed(2)}, type: $matchType)';
  }
}

/// Types of search matches
enum SearchMatchType {
  exact('Exact match'),
  startsWith('Starts with'),
  contains('Contains'),
  nativeName('Native name'),
  capital('Capital city'),
  alternative('Alternative name'),
  fuzzy('Fuzzy match');

  const SearchMatchType(this.description);
  final String description;
}

/// Search filters for advanced country searching
class CountrySearchFilters {
  final List<String>? regions;
  final List<String>? currencies;
  final String? phoneCodePrefix;

  const CountrySearchFilters({
    this.regions,
    this.currencies,
    this.phoneCodePrefix,
  });

  /// Apply filters to a list of countries
  List<CountryInfo> apply(List<CountryInfo> countries) {
    var filtered = countries;

    if (regions != null && regions!.isNotEmpty) {
      filtered = filtered.where((country) =>
        country.region != null && regions!.contains(country.region)).toList();
    }

    if (currencies != null && currencies!.isNotEmpty) {
      filtered = filtered.where((country) =>
        country.currency != null && currencies!.contains(country.currency)).toList();
    }

    if (phoneCodePrefix != null && phoneCodePrefix!.isNotEmpty) {
      filtered = filtered.where((country) =>
        country.phoneCode.startsWith(phoneCodePrefix!)).toList();
    }

    return filtered;
  }
}
