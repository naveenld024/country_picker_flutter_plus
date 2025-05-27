import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/country_info.dart';

/// Enhanced country data manager service with advanced features
class CountryDataManager {
  List<CountryInfo>? _countries;

  /// Get all countries from JSON data
  Future<List<CountryInfo>> getCountries() async {
    if (_countries != null) {
      return _countries!;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/flags/enhanced-countries.json');
      _countries = countryInfoFromJson(jsonString);
      return _countries!;
    } catch (e) {
      // Fallback to basic data if enhanced data is not available
      try {
        final String basicJsonString = await rootBundle.loadString('assets/flags/phone-code-en.json');
        final basicData = json.decode(basicJsonString) as List;
        _countries = basicData.map((item) => CountryInfo(
          name: item['name'] as String,
          code: item['code'] as String,
          phoneCode: item['phoneCode'] as String,
          flagEmoji: item['flagEmoji'] as String,
          region: _determineRegion(item['name'] as String),
        )).toList();
        return _countries!;
      } catch (e2) {
        throw Exception('Failed to load countries: $e2');
      }
    }
  }

  /// Get country by ISO code
  Future<CountryInfo?> getCountryByCode(String code) async {
    final countries = await getCountries();
    try {
      return countries.firstWhere((country) => country.code.toUpperCase() == code.toUpperCase());
    } catch (e) {
      return null;
    }
  }

  /// Get country by phone code
  Future<CountryInfo?> getCountryByPhoneCode(String phoneCode) async {
    final countries = await getCountries();
    try {
      return countries.firstWhere((country) => country.phoneCode == phoneCode);
    } catch (e) {
      return null;
    }
  }

  /// Get default country (Mexico as per original implementation)
  Future<CountryInfo> getDefaultCountry() async {
    final mexico = await getCountryByCode('MX');
    if (mexico != null) {
      return mexico;
    }

    // Fallback if Mexico is not found
    final countries = await getCountries();
    return countries.isNotEmpty ? countries.first : const CountryInfo(
      name: 'Mexico',
      code: 'MX',
      phoneCode: '+52',
      flagEmoji: '🇲🇽',
      region: 'North America',
    );
  }

  /// Enhanced search with fuzzy matching
  Future<List<CountryInfo>> searchCountriesAdvanced(String query) async {
    if (query.isEmpty) {
      return await getCountries();
    }

    final countries = await getCountries();
    final lowerQuery = query.toLowerCase();

    // First, get exact and partial matches
    final matches = countries.where((country) {
      return country.matchesQuery(query);
    }).toList();

    // Sort by relevance
    matches.sort((a, b) {
      // Exact name match gets highest priority
      if (a.name.toLowerCase() == lowerQuery) return -1;
      if (b.name.toLowerCase() == lowerQuery) return 1;

      // Code match gets second priority
      if (a.code.toLowerCase() == lowerQuery) return -1;
      if (b.code.toLowerCase() == lowerQuery) return 1;

      // Starts with name gets third priority
      if (a.name.toLowerCase().startsWith(lowerQuery) && !b.name.toLowerCase().startsWith(lowerQuery)) return -1;
      if (b.name.toLowerCase().startsWith(lowerQuery) && !a.name.toLowerCase().startsWith(lowerQuery)) return 1;

      // Default alphabetical sort
      return a.name.compareTo(b.name);
    });

    return matches;
  }

  /// Get countries grouped by region
  Future<Map<String, List<CountryInfo>>> getCountriesByRegion() async {
    final countries = await getCountries();
    final Map<String, List<CountryInfo>> grouped = {};

    for (final country in countries) {
      final region = country.region ?? 'Other';
      grouped.putIfAbsent(region, () => []).add(country);
    }

    // Sort countries within each region
    for (final region in grouped.keys) {
      grouped[region]!.sort((a, b) => a.name.compareTo(b.name));
    }

    return grouped;
  }

  /// Get popular countries (commonly used ones)
  Future<List<CountryInfo>> getPopularCountries() async {
    final countries = await getCountries();

    // Define popular country codes
    const popularCodes = ['US', 'GB', 'CA', 'AU', 'DE', 'FR', 'IT', 'ES', 'MX', 'BR', 'IN', 'CN', 'JP'];

    final popular = <CountryInfo>[];
    for (final code in popularCodes) {
      final country = countries.where((c) => c.code == code).firstOrNull;
      if (country != null) {
        popular.add(country);
      }
    }

    return popular;
  }

  /// Get countries by continent/region
  Future<List<CountryInfo>> getCountriesByRegionName(String regionName) async {
    final countries = await getCountries();
    return countries.where((country) =>
      country.region?.toLowerCase() == regionName.toLowerCase()).toList();
  }

  /// Simple region determination based on country name (fallback)
  String _determineRegion(String countryName) {
    final name = countryName.toLowerCase();

    // North America
    if (['united states', 'canada', 'mexico'].any((n) => name.contains(n))) {
      return 'North America';
    }

    // Europe
    if (['united kingdom', 'germany', 'france', 'italy', 'spain', 'netherlands',
         'belgium', 'switzerland', 'austria', 'sweden', 'norway', 'denmark',
         'finland', 'poland', 'czech', 'hungary', 'romania', 'bulgaria',
         'greece', 'portugal', 'ireland', 'croatia', 'slovenia', 'slovakia',
         'estonia', 'latvia', 'lithuania', 'luxembourg', 'malta', 'cyprus'].any((n) => name.contains(n))) {
      return 'Europe';
    }

    // Asia
    if (['china', 'japan', 'india', 'korea', 'thailand', 'vietnam', 'singapore',
         'malaysia', 'indonesia', 'philippines', 'taiwan', 'hong kong', 'pakistan',
         'bangladesh', 'sri lanka', 'nepal', 'myanmar', 'cambodia', 'laos',
         'mongolia', 'kazakhstan', 'uzbekistan', 'kyrgyzstan', 'tajikistan',
         'turkmenistan', 'afghanistan', 'iran', 'iraq', 'turkey', 'israel',
         'jordan', 'lebanon', 'syria', 'saudi arabia', 'uae', 'qatar', 'kuwait',
         'bahrain', 'oman', 'yemen'].any((n) => name.contains(n))) {
      return 'Asia';
    }

    // Africa
    if (['south africa', 'nigeria', 'egypt', 'kenya', 'ghana', 'morocco',
         'algeria', 'tunisia', 'libya', 'sudan', 'ethiopia', 'uganda', 'tanzania',
         'zimbabwe', 'botswana', 'namibia', 'zambia', 'malawi', 'mozambique',
         'madagascar', 'mauritius', 'seychelles', 'congo', 'cameroon', 'ivory coast',
         'senegal', 'mali', 'burkina faso', 'niger', 'chad', 'central african',
         'gabon', 'equatorial guinea', 'sao tome', 'cape verde', 'guinea',
         'sierra leone', 'liberia', 'togo', 'benin', 'rwanda', 'burundi',
         'djibouti', 'eritrea', 'somalia', 'comoros'].any((n) => name.contains(n))) {
      return 'Africa';
    }

    // South America
    if (['brazil', 'argentina', 'chile', 'peru', 'colombia', 'venezuela',
         'ecuador', 'bolivia', 'paraguay', 'uruguay', 'guyana', 'suriname',
         'french guiana'].any((n) => name.contains(n))) {
      return 'South America';
    }

    // Oceania
    if (['australia', 'new zealand', 'fiji', 'papua new guinea', 'samoa',
         'tonga', 'vanuatu', 'solomon islands', 'palau', 'micronesia',
         'marshall islands', 'kiribati', 'tuvalu', 'nauru'].any((n) => name.contains(n))) {
      return 'Oceania';
    }

    // Caribbean
    if (['jamaica', 'cuba', 'haiti', 'dominican republic', 'puerto rico',
         'trinidad', 'barbados', 'bahamas', 'antigua', 'saint lucia',
         'grenada', 'saint vincent', 'dominica', 'saint kitts'].any((n) => name.contains(n))) {
      return 'Caribbean';
    }

    return 'Other';
  }
}

extension on Iterable<CountryInfo> {
  CountryInfo? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
