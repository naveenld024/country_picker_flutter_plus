import 'package:flutter/material.dart';
import 'package:country_picker_flutter_plus/country_picker_flutter_plus.dart';

void main() {
  runApp(const EnhancedCountryPickerDemo());
}

/// Main application widget demonstrating the Country Picker Flutter Plus package
class EnhancedCountryPickerDemo extends StatelessWidget {
  const EnhancedCountryPickerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Picker Flutter Plus Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const DemoHomePage(),
    );
  }
}

/// Main demo page showcasing all Enhanced Country Picker features
class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

/// State class for the demo page with comprehensive examples
class _DemoHomePageState extends State<DemoHomePage> {
  CountryInfo? _selectedCountry;
  final CountryDataManager _countryDataManager = CountryDataManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Picker Flutter Plus Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),
            const SizedBox(height: 24),

            // Demo Examples
            _buildBasicExample(),
            const SizedBox(height: 16),
            _buildCustomBuilderExample(),
            const SizedBox(height: 16),
            _buildAdvancedFeaturesExample(),
            const SizedBox(height: 24),

            // Selected Country Info
            if (_selectedCountry != null) _buildSelectedCountryInfo(),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Builds the header section with package information
  Widget _buildHeaderSection() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.public, color: Colors.blue.shade700, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Country Picker Flutter Plus',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'A comprehensive Flutter package for country selection with advanced features including fuzzy search, regional grouping, and extensive customization options.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildFeatureChip('🔍 Fuzzy Search'),
                _buildFeatureChip('🌍 Regional Grouping'),
                _buildFeatureChip('⭐ Popular Countries'),
                _buildFeatureChip('🎨 Customizable UI'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a feature chip for the header
  Widget _buildFeatureChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.blue.shade100,
      side: BorderSide.none,
    );
  }

  /// Builds the basic country selector example
  Widget _buildBasicExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Country Selector',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            EnhancedCountrySelector(
              onChanged: (CountryInfo country) {
                setState(() {
                  _selectedCountry = country;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected: ${country.displayName}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              showFlag: true,
              showDropDownButton: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the custom builder example
  Widget _buildCustomBuilderExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Builder Example',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            EnhancedCountrySelector(
              builder: (CountryInfo? country) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        country?.flagEmoji ?? '🏳️',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        country?.displayName ?? 'Select Country',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                );
              },
              onChanged: (CountryInfo country) {
                setState(() {
                  _selectedCountry = country;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the advanced features example
  Widget _buildAdvancedFeaturesExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Advanced Features',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            EnhancedCountrySelector(
              enableSearch: true,
              showRegionHeaders: true,
              showPopularCountries: true,
              showCountryOnly: true,
              onChanged: (CountryInfo country) {
                setState(() {
                  _selectedCountry = country;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the selected country information display
  Widget _buildSelectedCountryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Country Information:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _selectedCountry!.flagEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCountry!.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Code: ${_selectedCountry!.code}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Phone Code', _selectedCountry!.phoneCode),
                if (_selectedCountry!.capital != null)
                  _buildInfoRow('Capital', _selectedCountry!.capital!),
                if (_selectedCountry!.currency != null)
                  _buildInfoRow('Currency',
                    '${_selectedCountry!.currency} (${_selectedCountry!.currencySymbol ?? ''})'),
                if (_selectedCountry!.region != null)
                  _buildInfoRow('Region', _selectedCountry!.region!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the action buttons section
  Widget _buildActionButtons() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          final countries = await _countryDataManager.getCountries();
          if (!mounted) return;

          final selected = await showSearch<CountryInfo?>(
            context: context,
            delegate: CountrySearchDelegate(
              countries: countries,
              countryDataManager: _countryDataManager,
              selectedCountry: _selectedCountry,
            ),
          );

          if (selected != null && mounted) {
            setState(() {
              _selectedCountry = selected;
            });
          }
        },
        icon: const Icon(Icons.search),
        label: const Text('Search Countries'),
      ),
    );
  }

  /// Builds an information row for country details
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
