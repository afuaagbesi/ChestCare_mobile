import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Country {
  final String name;
  final String code;

  Country({required this.name, required this.code});

  factory Country.fromJson(Map<String, dynamic> json) {
    try {
      return Country(
        name: json['name']['common'] as String,
        code: json['cca2'] as String,
      );
    } catch (e) {
      debugPrint('Error parsing country: $json');
      debugPrint('Error details: $e');
      rethrow;
    }
  }
}

class CountryService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';
  static const Duration _timeout = Duration(seconds: 10);

  static Future<List<Country>> getCountries() async {
    try {
      debugPrint('Fetching countries from $_baseUrl/all?fields=name,cca2');

      final response = await http
          .get(Uri.parse('$_baseUrl/all?fields=name,cca2'))
          .timeout(_timeout);

      debugPrint('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('Successfully received countries data');
        final List<dynamic> data = json.decode(response.body);
        debugPrint('Parsed JSON data, found ${data.length} countries');

        final countries = data
            .map((country) => Country.fromJson(country))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        debugPrint('Successfully processed ${countries.length} countries');
        return countries;
      } else {
        throw HttpException(
            'Failed to load countries. Status code: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      debugPrint('Network error: $e');
      throw Exception('Please check your internet connection');
    } on TimeoutException catch (e) {
      debugPrint('Request timeout: $e');
      throw Exception('Request timed out. Please try again');
    } on FormatException catch (e) {
      debugPrint('Data parsing error: $e');
      throw Exception('Error parsing country data');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Failed to fetch countries: $e');
    }
  }

  // Fallback method with hardcoded countries in case the API fails
  static List<Country> getFallbackCountries() {
    return [
      Country(name: 'Nigeria', code: 'NG'),
      Country(name: 'Ghana', code: 'GH'),
      Country(name: 'Kenya', code: 'KE'),
      Country(name: 'South Africa', code: 'ZA'),
      Country(name: 'Uganda', code: 'UG'),
      Country(name: 'Tanzania', code: 'TZ'),
      // Add more African countries as needed
    ];
  }
}
