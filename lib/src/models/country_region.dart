/// Enum representing different geographical regions/continents
enum CountryRegion {
  africa('Africa', '🌍'),
  asia('Asia', '🌏'),
  europe('Europe', '🌍'),
  northAmerica('North America', '🌎'),
  southAmerica('South America', '🌎'),
  oceania('Oceania', '🌏'),
  antarctica('Antarctica', '🧊'),
  caribbean('Caribbean', '🏝️'),
  middleEast('Middle East', '🕌'),
  centralAsia('Central Asia', '🏔️');

  const CountryRegion(this.displayName, this.emoji);

  final String displayName;
  final String emoji;

  /// Get region by name (case insensitive)
  static CountryRegion? fromName(String name) {
    final lowerName = name.toLowerCase();
    for (final region in CountryRegion.values) {
      if (region.displayName.toLowerCase() == lowerName) {
        return region;
      }
    }
    return null;
  }

  /// Get all regions as a list
  static List<CountryRegion> get allRegions => CountryRegion.values;

  /// Get regions sorted alphabetically
  static List<CountryRegion> get sortedRegions {
    final regions = List<CountryRegion>.from(CountryRegion.values);
    regions.sort((a, b) => a.displayName.compareTo(b.displayName));
    return regions;
  }
}

/// Extension to provide additional functionality for regions
extension CountryRegionExtension on CountryRegion {
  /// Check if this region is in the Americas
  bool get isAmericas => this == CountryRegion.northAmerica || 
                        this == CountryRegion.southAmerica || 
                        this == CountryRegion.caribbean;

  /// Check if this region is in the Old World
  bool get isOldWorld => this == CountryRegion.africa || 
                        this == CountryRegion.asia || 
                        this == CountryRegion.europe;

  /// Get a description of the region
  String get description {
    switch (this) {
      case CountryRegion.africa:
        return 'Countries in the African continent';
      case CountryRegion.asia:
        return 'Countries in Asia including East, Southeast, and South Asia';
      case CountryRegion.europe:
        return 'European countries including EU and non-EU nations';
      case CountryRegion.northAmerica:
        return 'North American countries including USA, Canada, and Mexico';
      case CountryRegion.southAmerica:
        return 'South American countries';
      case CountryRegion.oceania:
        return 'Pacific island nations and Australia/New Zealand';
      case CountryRegion.antarctica:
        return 'Antarctic territories';
      case CountryRegion.caribbean:
        return 'Caribbean island nations';
      case CountryRegion.middleEast:
        return 'Middle Eastern countries';
      case CountryRegion.centralAsia:
        return 'Central Asian countries';
    }
  }
}
