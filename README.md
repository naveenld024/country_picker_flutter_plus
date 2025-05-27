# Country Picker Flutter Plus

An advanced Flutter package for country selection with enhanced features beyond basic country picking functionality. This package provides a comprehensive country picker with fuzzy search, regional grouping, popular countries, and extensive customization options.

## Features

✨ **Enhanced Search**: Advanced fuzzy search with typo tolerance and multiple search strategies
🌍 **Regional Organization**: Countries grouped by continents and regions
📱 **Modern UI**: Beautiful, customizable interface with Material Design
🔍 **Multiple Search Methods**: Search by name, code, phone code, capital, or native name
⭐ **Popular Countries**: Quick access to commonly used countries
🎨 **Customizable**: Extensive customization options for appearance and behavior
🌐 **Comprehensive Data**: Extended country information including capitals, currencies, and native names
🔧 **Developer Friendly**: Clean API with proper documentation and examples
✅ **Well Tested**: Comprehensive test coverage
🔄 **Backward Compatible**: Compatible with existing country picker implementations

## Enhanced Features Over Basic Country Pickers

This package goes beyond simple country selection by providing:

- **Advanced Search Engine**: Fuzzy matching with scoring and relevance ranking
- **Regional Grouping**: Organize countries by continents for better navigation
- **Extended Country Data**: Capital cities, currencies, native names, and more
- **Popular Countries Section**: Quick access to frequently used countries
- **Multiple Display Modes**: Show country names, phone codes, or custom formats
- **Search Delegate**: Full-screen search experience with advanced filtering
- **Customizable UI**: Extensive theming and layout options
- **Performance Optimized**: Efficient data loading and caching

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  country_picker_flutter_plus: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Basic Usage

### Simple Country Selector

```dart
import 'package:country_picker_flutter_plus/country_picker_flutter_plus.dart';

EnhancedCountrySelector(
  onChanged: (CountryInfo country) {
    print('Selected: ${country.name}');
  },
  showFlag: true,
  showDropDownButton: true,
)
```

### With Initial Selection

```dart
EnhancedCountrySelector(
  initialSelectionCode: 'US',
  onChanged: (CountryInfo country) {
    print('Selected: ${country.displayName}');
  },
)
```

### Custom Builder

```dart
EnhancedCountrySelector(
  builder: (CountryInfo? country) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(country?.flagEmoji ?? '🏳️'),
          SizedBox(width: 8),
          Text(country?.displayName ?? 'Select Country'),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  },
  onChanged: (CountryInfo country) {
    // Handle selection
  },
)
```

## Advanced Usage

### Enhanced Features

```dart
EnhancedCountrySelector(
  enableSearch: true,              // Enable search functionality
  showRegionHeaders: true,         // Group by regions
  showPopularCountries: true,      // Show popular countries first
  showCountryOnly: true,           // Show country names instead of phone codes
  onChanged: (CountryInfo country) {
    print('Selected: ${country.name}');
    print('Capital: ${country.capital}');
    print('Currency: ${country.currency}');
    print('Region: ${country.region}');
  },
)
```

### Using the Search Delegate

```dart
// Show full-screen search
final countries = await CountryDataManager().getCountries();
final selected = await showSearch<CountryInfo>(
  context: context,
  delegate: CountrySearchDelegate(
    countries: countries,
    countryDataManager: CountryDataManager(),
  ),
);

if (selected != null) {
  print('Selected: ${selected.name}');
}
```

### Working with Country Data

```dart
final dataManager = CountryDataManager();

// Get all countries
final countries = await dataManager.getCountries();

// Search countries
final searchResults = await dataManager.searchCountriesAdvanced('germ');

// Get popular countries
final popular = await dataManager.getPopularCountries();

// Get countries by region
final europeanCountries = await dataManager.getCountriesByRegionName('Europe');

// Group countries by region
final grouped = await dataManager.getCountriesByRegion();
```

### Using Utility Functions

```dart
// Sort countries
final sortedByName = CountryUtils.sortByName(countries);
final sortedByCode = CountryUtils.sortByPhoneCode(countries);

// Find specific countries
final usa = CountryUtils.findByCode(countries, 'US');
final ukByPhone = CountryUtils.findByPhoneCode(countries, '+44');

// Filter and group
final europeanCountries = CountryUtils.filterByRegion(countries, 'Europe');
final groupedByRegion = CountryUtils.groupByRegion(countries);

// Get all regions and currencies
final allRegions = CountryUtils.getAllRegions(countries);
final allCurrencies = CountryUtils.getAllCurrencies(countries);
```

## CountryInfo Model

The `CountryInfo` model provides comprehensive country data:

```dart
class CountryInfo {
  final String name;           // Country name (e.g., "United States")
  final String code;           // ISO country code (e.g., "US")
  final String phoneCode;      // Phone code (e.g., "+1")
  final String flagEmoji;      // Flag emoji (e.g., "🇺🇸")
  final String? region;        // Region (e.g., "North America")
  final String? nativeName;    // Native name (e.g., "Deutschland")
  final String? capital;       // Capital city (e.g., "Washington, D.C.")
  final String? currency;      // Currency code (e.g., "USD")
  final String? currencySymbol; // Currency symbol (e.g., "$")
}
```

### Compatibility Extensions

For backward compatibility with existing country picker packages:

```dart
// These properties are available for compatibility
country.dialCode    // Same as phoneCode
country.isoCode     // Same as code
country.flagUri     // Returns "emoji:🇺🇸" format
```

## Customization Options

### EnhancedCountrySelector Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `initialSelection` | `CountryInfo?` | `null` | Initial country selection |
| `initialSelectionCode` | `String?` | `null` | Initial selection by ISO code |
| `onChanged` | `Function(CountryInfo)?` | `null` | Callback when country changes |
| `onInit` | `Function(CountryInfo?)?` | `null` | Callback when initialized |
| `showFlag` | `bool` | `true` | Show flag emoji |
| `showDropDownButton` | `bool` | `true` | Show dropdown arrow |
| `showCountryOnly` | `bool` | `false` | Show country name instead of phone code |
| `enableSearch` | `bool` | `true` | Enable search functionality |
| `showRegionHeaders` | `bool` | `false` | Group countries by region |
| `showPopularCountries` | `bool` | `true` | Show popular countries section |
| `textStyle` | `TextStyle?` | `null` | Custom text styling |
| `padding` | `EdgeInsets` | `EdgeInsets.zero` | Custom padding |
| `builder` | `Widget Function(CountryInfo?)?` | `null` | Custom widget builder |

## Comparison with Original Implementation

This enhanced package provides significant improvements over the basic SF app implementation:

### Original SF App Features:
- Basic country selection with phone codes
- Simple text search (name, code, phone code)
- Modal bottom sheet interface
- Flag emoji display
- Basic country data (name, code, phoneCode, flagEmoji)

### Enhanced Package Features:
- ✅ All original features maintained
- ✅ **Advanced fuzzy search** with typo tolerance and relevance scoring
- ✅ **Regional organization** with continent grouping
- ✅ **Extended country data** including capitals, currencies, native names
- ✅ **Popular countries section** for quick access
- ✅ **Multiple search strategies** (name, native name, capital, etc.)
- ✅ **Search delegate** for full-screen search experience
- ✅ **Customizable UI** with extensive theming options
- ✅ **Utility functions** for data manipulation and filtering
- ✅ **Comprehensive testing** with full test coverage
- ✅ **Better performance** with optimized data loading
- ✅ **Developer-friendly API** with clear documentation

### Function Name Differences (No Conflicts):

| Original SF App | Enhanced Package |
|----------------|------------------|
| `CustomCountryPicker` | `EnhancedCountrySelector` |
| `PhoneCountryService` | `CountryDataManager` |
| `PhoneCountry` | `CountryInfo` |
| `_showCountryPicker()` | `_showAdvancedCountryPicker()` |
| `searchCountries()` | `searchCountriesAdvanced()` |

## Testing

Run the comprehensive test suite:

```bash
flutter test
```

The package includes tests for:
- CountryInfo model and extensions
- CountryDataManager service methods
- FuzzySearchEngine functionality
- CountryUtils utility functions
- Widget behavior and interactions

## Example App

Check out the complete example in the `/example` folder:

```bash
cd example
flutter run
```

The example demonstrates:
- Basic country selection
- Custom builder usage
- Advanced features showcase
- Search delegate implementation
- Country information display

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and version history.
