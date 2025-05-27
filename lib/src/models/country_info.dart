import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'country_info.freezed.dart';
part 'country_info.g.dart';

/// Parse JSON string to list of CountryInfo
List<CountryInfo> countryInfoFromJson(String str) =>
    List<CountryInfo>.from(json.decode(str).map((x) => CountryInfo.fromJson(x)));

/// Convert list of CountryInfo to JSON string
String countryInfoToJson(List<CountryInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Enhanced country information model with additional data
@freezed
class CountryInfo with _$CountryInfo {
  const factory CountryInfo({
    required String name,
    required String code,
    required String phoneCode,
    required String flagEmoji,
    String? region,
    String? nativeName,
    String? capital,
    String? currency,
    String? currencySymbol,
  }) = _CountryInfo;

  factory CountryInfo.fromJson(Map<String, dynamic> json) => _$CountryInfoFromJson(json);
}

// Extension to provide compatibility with the old PhoneCountry from package
extension CountryInfoExtension on CountryInfo {
  // For compatibility with existing code that expects dialCode
  String get dialCode => phoneCode;

  // For compatibility with existing code that expects isoCode
  String get isoCode => code;

  // For compatibility with existing code that expects flagUri
  String get flagUri => 'emoji:$flagEmoji';

  // Enhanced search functionality
  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();

    // Check main name
    if (name.toLowerCase().contains(lowerQuery)) return true;

    // Check native name
    if (nativeName?.toLowerCase().contains(lowerQuery) == true) return true;

    // Check country code
    if (code.toLowerCase().contains(lowerQuery)) return true;

    // Check phone code
    if (phoneCode.contains(query)) return true;

    // Check capital
    if (capital?.toLowerCase().contains(lowerQuery) == true) return true;

    return false;
  }

  // Get display name with native name if available
  String get displayName {
    if (nativeName != null && nativeName != name) {
      return '$name ($nativeName)';
    }
    return name;
  }

  // Get formatted phone code for display
  String get formattedPhoneCode {
    return phoneCode.startsWith('+') ? phoneCode : '+$phoneCode';
  }
}
