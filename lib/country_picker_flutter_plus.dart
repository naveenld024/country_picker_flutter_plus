/// Enhanced Flutter country picker with advanced search, regional grouping,
/// and extensive customization options.
///
/// This package provides a comprehensive country picker that goes beyond basic
/// country selection with features like:
///
/// - **Advanced Search**: Fuzzy search with typo tolerance and relevance scoring
/// - **Regional Organization**: Countries grouped by continents and regions
/// - **Popular Countries**: Quick access to frequently used countries
/// - **Extended Data**: Native names, capitals, currencies, and more
/// - **Customizable UI**: Extensive theming and layout options
/// - **Backward Compatibility**: Compatible with existing country picker packages
///
/// ## Quick Start
///
/// ```dart
/// import 'package:country_picker_flutter_plus/country_picker_flutter_plus.dart';
///
/// EnhancedCountrySelector(
///   onChanged: (CountryInfo country) {
///     print('Selected: ${country.displayName}');
///   },
///   showFlag: true,
///   enableSearch: true,
/// )
/// ```
library;

export 'src/models/country_info.dart';
export 'src/models/country_region.dart';
export 'src/services/country_data_manager.dart';
export 'src/widgets/enhanced_country_selector.dart';
export 'src/widgets/country_search_delegate.dart';
export 'src/utils/fuzzy_search.dart';
export 'src/utils/country_utils.dart';
