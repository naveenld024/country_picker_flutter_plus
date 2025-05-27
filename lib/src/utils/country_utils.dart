import '../models/country_info.dart';

/// Utility functions for working with countries
class CountryUtils {
  /// Get countries sorted by name
  static List<CountryInfo> sortByName(List<CountryInfo> countries) {
    final sorted = List<CountryInfo>.from(countries);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  /// Get countries sorted by phone code
  static List<CountryInfo> sortByPhoneCode(List<CountryInfo> countries) {
    final sorted = List<CountryInfo>.from(countries);
    sorted.sort((a, b) => a.phoneCode.compareTo(b.phoneCode));
    return sorted;
  }

  /// Group countries by region
  static Map<String, List<CountryInfo>> groupByRegion(List<CountryInfo> countries) {
    final Map<String, List<CountryInfo>> grouped = {};
    
    for (final country in countries) {
      final region = country.region ?? 'Other';
      grouped.putIfAbsent(region, () => []).add(country);
    }
    
    // Sort countries within each region
    for (final region in grouped.keys) {
      grouped[region] = sortByName(grouped[region]!);
    }
    
    return grouped;
  }

  /// Filter countries by region
  static List<CountryInfo> filterByRegion(List<CountryInfo> countries, String region) {
    return countries.where((country) => country.region == region).toList();
  }

  /// Get countries that match a phone code prefix
  static List<CountryInfo> filterByPhoneCodePrefix(List<CountryInfo> countries, String prefix) {
    return countries.where((country) => country.phoneCode.startsWith(prefix)).toList();
  }

  /// Find country by ISO code (case insensitive)
  static CountryInfo? findByCode(List<CountryInfo> countries, String code) {
    try {
      return countries.firstWhere((country) => 
        country.code.toUpperCase() == code.toUpperCase());
    } catch (e) {
      return null;
    }
  }

  /// Find country by phone code
  static CountryInfo? findByPhoneCode(List<CountryInfo> countries, String phoneCode) {
    try {
      return countries.firstWhere((country) => country.phoneCode == phoneCode);
    } catch (e) {
      return null;
    }
  }

  /// Get popular countries (commonly used ones)
  static List<CountryInfo> getPopularCountries(List<CountryInfo> countries) {
    const popularCodes = ['US', 'GB', 'CA', 'AU', 'DE', 'FR', 'IT', 'ES', 'MX', 'BR', 'IN', 'CN', 'JP'];
    
    final popular = <CountryInfo>[];
    for (final code in popularCodes) {
      final country = findByCode(countries, code);
      if (country != null) {
        popular.add(country);
      }
    }
    
    return popular;
  }

  /// Format phone code for display
  static String formatPhoneCode(String phoneCode) {
    return phoneCode.startsWith('+') ? phoneCode : '+$phoneCode';
  }

  /// Get display name with native name if available
  static String getDisplayName(CountryInfo country) {
    if (country.nativeName != null && country.nativeName != country.name) {
      return '${country.name} (${country.nativeName})';
    }
    return country.name;
  }

  /// Check if country matches search query
  static bool matchesSearchQuery(CountryInfo country, String query) {
    final lowerQuery = query.toLowerCase();
    
    // Check main name
    if (country.name.toLowerCase().contains(lowerQuery)) return true;
    
    // Check native name
    if (country.nativeName?.toLowerCase().contains(lowerQuery) == true) return true;
    
    // Check country code
    if (country.code.toLowerCase().contains(lowerQuery)) return true;
    
    // Check phone code
    if (country.phoneCode.contains(query)) return true;
    
    // Check capital
    if (country.capital?.toLowerCase().contains(lowerQuery) == true) return true;
    
    return false;
  }

  /// Get all unique regions from countries list
  static List<String> getAllRegions(List<CountryInfo> countries) {
    final regions = countries
        .map((country) => country.region)
        .where((region) => region != null)
        .cast<String>()
        .toSet()
        .toList();
    
    regions.sort();
    return regions;
  }

  /// Get all unique currencies from countries list
  static List<String> getAllCurrencies(List<CountryInfo> countries) {
    final currencies = countries
        .map((country) => country.currency)
        .where((currency) => currency != null)
        .cast<String>()
        .toSet()
        .toList();
    
    currencies.sort();
    return currencies;
  }

  /// Convert CountryInfo to a map for easy serialization
  static Map<String, dynamic> toMap(CountryInfo country) {
    return {
      'name': country.name,
      'code': country.code,
      'phoneCode': country.phoneCode,
      'flagEmoji': country.flagEmoji,
      'region': country.region,
      'nativeName': country.nativeName,
      'capital': country.capital,
      'currency': country.currency,
      'currencySymbol': country.currencySymbol,
    };
  }

  /// Create CountryInfo from a map
  static CountryInfo fromMap(Map<String, dynamic> map) {
    return CountryInfo(
      name: map['name'] as String,
      code: map['code'] as String,
      phoneCode: map['phoneCode'] as String,
      flagEmoji: map['flagEmoji'] as String,
      region: map['region'] as String?,
      nativeName: map['nativeName'] as String?,
      capital: map['capital'] as String?,
      currency: map['currency'] as String?,
      currencySymbol: map['currencySymbol'] as String?,
    );
  }
}
