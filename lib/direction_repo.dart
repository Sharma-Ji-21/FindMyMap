import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '.env.dart';
import 'direction_model.dart';

class DirectionRepo {
  static const String _baseurl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionRepo({Dio? dio}) : _dio = dio ?? Dio();

  Future<Direction?> getDirection({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseurl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}', // Remove space
          'destination':
              '${destination.latitude},${destination.longitude}', // Remove space
          'key': googleAPIKey,
        },
      );

      if (response.statusCode == 200) {
        // Check if routes exist in response
        if (response.data['status'] == 'OK' &&
            response.data['routes'] != null &&
            response.data['routes'].isNotEmpty) {
          return Direction.fromMap(response.data);
        } else {
          print('No valid routes found in response: ${response.data}');
          return null;
        }
      }

      print('Error status code: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error getting directions: $e');
      return null;
    }
  }
}
