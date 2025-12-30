import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/api_keys.dart';

// Provider for the ApiService
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.siteUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add WooCommerce Authentication
        // Typically WooCommerce uses Basic Auth or specific query params for Consumer Key/Secret depending on HTTPS.
        // For simplicity and common setup, we'll append query parameters for now, or use Basic Auth if preferred.
        // Implementing Query Param auth for simplicity:
        options.queryParameters.addAll({
          'consumer_key': AppConstants.consumerKey,
          'consumer_secret': AppConstants.consumerSecret,
        });
        return handler.next(options);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Basic error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      return Exception('Network Error: ${error.message}');
    }
    return Exception('Unknown Error: $error');
  }
}
