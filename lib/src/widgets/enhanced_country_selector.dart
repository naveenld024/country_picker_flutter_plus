import 'package:flutter/material.dart';
import '../models/country_info.dart';
import '../services/country_data_manager.dart';

/// Enhanced country selector widget with advanced features
class EnhancedCountrySelector extends StatefulWidget {
  final CountryInfo? initialSelection;
  final String? initialSelectionCode;
  final Function(CountryInfo)? onChanged;
  final Function(CountryInfo?)? onInit;
  final bool showFlag;
  final bool showDropDownButton;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final Widget Function(CountryInfo?)? builder;
  final bool showCountryOnly;
  final bool showOnlyCountryWhenClosed;
  final bool alignLeft;
  final bool enableSearch;
  final bool showRegionHeaders;
  final bool showPopularCountries;

  const EnhancedCountrySelector({
    Key? key,
    this.initialSelection,
    this.initialSelectionCode,
    this.onChanged,
    this.onInit,
    this.showFlag = true,
    this.showDropDownButton = true,
    this.textStyle,
    this.padding = EdgeInsets.zero,
    this.builder,
    this.showCountryOnly = false,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.enableSearch = true,
    this.showRegionHeaders = false,
    this.showPopularCountries = true,
  }) : super(key: key);

  @override
  State<EnhancedCountrySelector> createState() => _EnhancedCountrySelectorState();
}

class _EnhancedCountrySelectorState extends State<EnhancedCountrySelector> {
  CountryInfo? _selectedCountry;
  final CountryDataManager _countryDataManager = CountryDataManager();

  @override
  void initState() {
    super.initState();
    _initializeCountry();
  }

  Future<void> _initializeCountry() async {
    CountryInfo? country;

    if (widget.initialSelection != null) {
      country = widget.initialSelection;
    } else if (widget.initialSelectionCode != null) {
      country = await _countryDataManager.getCountryByCode(widget.initialSelectionCode!);
    }

    country ??= await _countryDataManager.getDefaultCountry();

    setState(() {
      _selectedCountry = country;
    });

    if (widget.onInit != null) {
      widget.onInit!(country);
    }
  }

  void _showAdvancedCountryPicker() async {
    final countries = await _countryDataManager.getCountries();

    if (!mounted) return;

    final selected = await showModalBottomSheet<CountryInfo>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EnhancedCountryPickerBottomSheet(
        countries: countries,
        selectedCountry: _selectedCountry,
        enableSearch: widget.enableSearch,
        showRegionHeaders: widget.showRegionHeaders,
        showPopularCountries: widget.showPopularCountries,
        countryDataManager: _countryDataManager,
      ),
    );

    if (selected != null && selected != _selectedCountry) {
      setState(() {
        _selectedCountry = selected;
      });

      if (widget.onChanged != null) {
        widget.onChanged!(selected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return GestureDetector(
        onTap: _showAdvancedCountryPicker,
        child: widget.builder!(_selectedCountry),
      );
    }

    return GestureDetector(
      onTap: _showAdvancedCountryPicker,
      child: Padding(
        padding: widget.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showFlag && _selectedCountry != null) ...[
              Text(
                _selectedCountry!.flagEmoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
            ],
            if (!widget.showCountryOnly) ...[
              Text(
                _selectedCountry?.phoneCode ?? '+52',
                style: widget.textStyle,
              ),
            ] else ...[
              Text(
                _selectedCountry?.displayName ?? 'Mexico',
                style: widget.textStyle,
              ),
            ],
            if (widget.showDropDownButton) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 24,
                color: Colors.grey.shade600,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EnhancedCountryPickerBottomSheet extends StatefulWidget {
  final List<CountryInfo> countries;
  final CountryInfo? selectedCountry;
  final bool enableSearch;
  final bool showRegionHeaders;
  final bool showPopularCountries;
  final CountryDataManager countryDataManager;

  const _EnhancedCountryPickerBottomSheet({
    Key? key,
    required this.countries,
    this.selectedCountry,
    required this.enableSearch,
    required this.showRegionHeaders,
    required this.showPopularCountries,
    required this.countryDataManager,
  }) : super(key: key);

  @override
  State<_EnhancedCountryPickerBottomSheet> createState() => _EnhancedCountryPickerBottomSheetState();
}

class _EnhancedCountryPickerBottomSheetState extends State<_EnhancedCountryPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryInfo> _filteredCountries = [];
  List<CountryInfo> _popularCountries = [];
  bool _showingSearchResults = false;

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
    _loadPopularCountries();
  }

  Future<void> _loadPopularCountries() async {
    if (widget.showPopularCountries) {
      final popular = await widget.countryDataManager.getPopularCountries();
      setState(() {
        _popularCountries = popular;
      });
    }
  }

  void _filterCountries(String query) async {
    setState(() {
      _showingSearchResults = query.isNotEmpty;
    });

    if (query.isEmpty) {
      setState(() {
        _filteredCountries = widget.countries;
      });
    } else {
      final results = await widget.countryDataManager.searchCountriesAdvanced(query);
      setState(() {
        _filteredCountries = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select Country',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Search field
          if (widget.enableSearch) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search countries...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterCountries('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _filterCountries,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Countries list
          Expanded(
            child: _buildCountriesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCountriesList() {
    if (!_showingSearchResults && widget.showPopularCountries && _popularCountries.isNotEmpty) {
      return _buildSectionedList();
    } else {
      return _buildSimpleList();
    }
  }

  Widget _buildSimpleList() {
    return ListView.builder(
      itemCount: _filteredCountries.length,
      itemBuilder: (context, index) {
        final country = _filteredCountries[index];
        return _buildCountryTile(country);
      },
    );
  }

  Widget _buildSectionedList() {
    return ListView(
      children: [
        if (_popularCountries.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Popular Countries',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          ..._popularCountries.map((country) => _buildCountryTile(country)),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'All Countries',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        ],
        ..._filteredCountries.map((country) => _buildCountryTile(country)),
      ],
    );
  }

  Widget _buildCountryTile(CountryInfo country) {
    final isSelected = country.code == widget.selectedCountry?.code;

    return ListTile(
      leading: Text(
        country.flagEmoji,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(country.displayName),
      subtitle: country.capital != null ? Text(country.capital!) : null,
      trailing: Text(
        country.phoneCode,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      onTap: () => Navigator.pop(context, country),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
