import 'package:flutter/material.dart';
import '../models/country_info.dart';
import '../services/country_data_manager.dart';
import '../utils/country_utils.dart';

/// Search delegate for country selection with advanced search capabilities
class CountrySearchDelegate extends SearchDelegate<CountryInfo?> {
  final List<CountryInfo> countries;
  final CountryDataManager countryDataManager;
  final CountryInfo? selectedCountry;

  CountrySearchDelegate({
    required this.countries,
    required this.countryDataManager,
    this.selectedCountry,
  });

  @override
  String get searchFieldLabel => 'Search countries...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildPopularCountries();
    }
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<CountryInfo>>(
      future: countryDataManager.searchCountriesAdvanced(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty) {
          return const Center(
            child: Text('No countries found'),
          );
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final country = results[index];
            return _buildCountryTile(country);
          },
        );
      },
    );
  }

  Widget _buildPopularCountries() {
    return FutureBuilder<List<CountryInfo>>(
      future: countryDataManager.getPopularCountries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final popular = snapshot.data ?? [];

        return ListView(
          children: [
            if (popular.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Popular Countries',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...popular.map((country) => _buildCountryTile(country)),
              const Divider(),
            ],
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'All Countries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...CountryUtils.sortByName(countries).map((country) => _buildCountryTile(country)),
          ],
        );
      },
    );
  }

  Widget _buildCountryTile(CountryInfo country) {
    final isSelected = country.code == selectedCountry?.code;

    return Builder(
      builder: (context) => ListTile(
        leading: Text(
          country.flagEmoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(CountryUtils.getDisplayName(country)),
        subtitle: country.capital != null
            ? Text('Capital: ${country.capital}')
            : null,
        trailing: Text(
          CountryUtils.formatPhoneCode(country.phoneCode),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        onTap: () {
          close(context, country);
        },
      ),
    );
  }
}
