// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CountryInfoImpl _$$CountryInfoImplFromJson(Map<String, dynamic> json) =>
    _$CountryInfoImpl(
      name: json['name'] as String,
      code: json['code'] as String,
      phoneCode: json['phoneCode'] as String,
      flagEmoji: json['flagEmoji'] as String,
      region: json['region'] as String?,
      nativeName: json['nativeName'] as String?,
      capital: json['capital'] as String?,
      currency: json['currency'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
    );

Map<String, dynamic> _$$CountryInfoImplToJson(_$CountryInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'phoneCode': instance.phoneCode,
      'flagEmoji': instance.flagEmoji,
      'region': instance.region,
      'nativeName': instance.nativeName,
      'capital': instance.capital,
      'currency': instance.currency,
      'currencySymbol': instance.currencySymbol,
    };
