import 'package:country_picker_flutter_plus/country_picker_flutter_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryInfo Tests', () {
    test('should create CountryInfo with required fields', () {
      const country = CountryInfo(
        name: 'United States',
        code: 'US',
        phoneCode: '+1',
        flagEmoji: '🇺🇸',
      );

      expect(country.name, 'United States');
      expect(country.code, 'US');
      expect(country.phoneCode, '+1');
      expect(country.flagEmoji, '🇺🇸');
    });

    test('should create CountryInfo with optional fields', () {
      const country = CountryInfo(
        name: 'Germany',
        code: 'DE',
        phoneCode: '+49',
        flagEmoji: '🇩🇪',
        region: 'Europe',
        nativeName: 'Deutschland',
        capital: 'Berlin',
        currency: 'EUR',
        currencySymbol: '€',
      );

      expect(country.region, 'Europe');
      expect(country.nativeName, 'Deutschland');
      expect(country.capital, 'Berlin');
      expect(country.currency, 'EUR');
      expect(country.currencySymbol, '€');
    });

    test('should provide compatibility properties', () {
      const country = CountryInfo(
        name: 'Mexico',
        code: 'MX',
        phoneCode: '+52',
        flagEmoji: '🇲🇽',
      );

      expect(country.dialCode, '+52');
      expect(country.isoCode, 'MX');
      expect(country.flagUri, 'emoji:🇲🇽');
    });

    test('should match search queries correctly', () {
      const country = CountryInfo(
        name: 'United Kingdom',
        code: 'GB',
        phoneCode: '+44',
        flagEmoji: '🇬🇧',
        nativeName: 'United Kingdom',
        capital: 'London',
      );

      expect(country.matchesQuery('United'), true);
      expect(country.matchesQuery('GB'), true);
      expect(country.matchesQuery('+44'), true);
      expect(country.matchesQuery('44'), true);
      expect(country.matchesQuery('London'), true);
      expect(country.matchesQuery('xyz'), false);
    });

    test('should provide correct display name', () {
      const countryWithNative = CountryInfo(
        name: 'Germany',
        code: 'DE',
        phoneCode: '+49',
        flagEmoji: '🇩🇪',
        nativeName: 'Deutschland',
      );

      const countryWithoutNative = CountryInfo(
        name: 'Canada',
        code: 'CA',
        phoneCode: '+1',
        flagEmoji: '🇨🇦',
      );

      expect(countryWithNative.displayName, 'Germany (Deutschland)');
      expect(countryWithoutNative.displayName, 'Canada');
    });

    test('should format phone code correctly', () {
      const countryWithPlus = CountryInfo(
        name: 'US',
        code: 'US',
        phoneCode: '+1',
        flagEmoji: '🇺🇸',
      );

      const countryWithoutPlus = CountryInfo(
        name: 'Test',
        code: 'TE',
        phoneCode: '123',
        flagEmoji: '🏳️',
      );

      expect(countryWithPlus.formattedPhoneCode, '+1');
      expect(countryWithoutPlus.formattedPhoneCode, '+123');
    });
  });

  group('CountryUtils Tests', () {
    final testCountries = [
      const CountryInfo(
        name: 'United States',
        code: 'US',
        phoneCode: '+1',
        flagEmoji: '🇺🇸',
        region: 'North America',
      ),
      const CountryInfo(
        name: 'Germany',
        code: 'DE',
        phoneCode: '+49',
        flagEmoji: '🇩🇪',
        region: 'Europe',
      ),
      const CountryInfo(
        name: 'Australia',
        code: 'AU',
        phoneCode: '+61',
        flagEmoji: '🇦🇺',
        region: 'Oceania',
      ),
    ];

    test('should sort countries by name', () {
      final sorted = CountryUtils.sortByName(testCountries);
      expect(sorted[0].name, 'Australia');
      expect(sorted[1].name, 'Germany');
      expect(sorted[2].name, 'United States');
    });

    test('should sort countries by phone code', () {
      final sorted = CountryUtils.sortByPhoneCode(testCountries);
      expect(sorted[0].phoneCode, '+1');
      expect(sorted[1].phoneCode, '+49');
      expect(sorted[2].phoneCode, '+61');
    });

    test('should find country by code', () {
      final found = CountryUtils.findByCode(testCountries, 'DE');
      expect(found?.name, 'Germany');

      final notFound = CountryUtils.findByCode(testCountries, 'XX');
      expect(notFound, null);
    });

    test('should find country by phone code', () {
      final found = CountryUtils.findByPhoneCode(testCountries, '+49');
      expect(found?.name, 'Germany');

      final notFound = CountryUtils.findByPhoneCode(testCountries, '+999');
      expect(notFound, null);
    });

    test('should filter by region', () {
      final europeanCountries = CountryUtils.filterByRegion(testCountries, 'Europe');
      expect(europeanCountries.length, 1);
      expect(europeanCountries[0].name, 'Germany');
    });

    test('should group by region', () {
      final grouped = CountryUtils.groupByRegion(testCountries);
      expect(grouped.keys.length, 3);
      expect(grouped['Europe']?.length, 1);
      expect(grouped['North America']?.length, 1);
      expect(grouped['Oceania']?.length, 1);
    });

    test('should get all regions', () {
      final regions = CountryUtils.getAllRegions(testCountries);
      expect(regions.length, 3);
      expect(regions.contains('Europe'), true);
      expect(regions.contains('North America'), true);
      expect(regions.contains('Oceania'), true);
    });
  });

  group('FuzzySearchEngine Tests', () {
    final testCountries = [
      const CountryInfo(
        name: 'United States',
        code: 'US',
        phoneCode: '+1',
        flagEmoji: '🇺🇸',
      ),
      const CountryInfo(
        name: 'United Kingdom',
        code: 'GB',
        phoneCode: '+44',
        flagEmoji: '🇬🇧',
      ),
      const CountryInfo(
        name: 'Germany',
        code: 'DE',
        phoneCode: '+49',
        flagEmoji: '🇩🇪',
        nativeName: 'Deutschland',
      ),
    ];

    test('should return all countries for empty query', () {
      final results = FuzzySearchEngine.searchCountries(testCountries, '');
      expect(results.length, 3);
    });

    test('should find exact matches', () {
      final results = FuzzySearchEngine.searchCountries(testCountries, 'Germany');
      expect(results.isNotEmpty, true);
      expect(results[0].country.name, 'Germany');
      expect(results[0].matchType, SearchMatchType.exact);
    });

    test('should find partial matches', () {
      final results = FuzzySearchEngine.searchCountries(testCountries, 'United');
      expect(results.length, 2);
      expect(results.any((r) => r.country.name == 'United States'), true);
      expect(results.any((r) => r.country.name == 'United Kingdom'), true);
    });

    test('should find matches by code', () {
      final results = FuzzySearchEngine.searchCountries(testCountries, 'DE');
      expect(results.isNotEmpty, true);
      expect(results[0].country.name, 'Germany');
    });

    test('should find matches by phone code', () {
      final results = FuzzySearchEngine.searchCountries(testCountries, '+44');
      expect(results.isNotEmpty, true);
      expect(results[0].country.name, 'United Kingdom');
    });
  });
}
