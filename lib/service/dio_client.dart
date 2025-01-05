import 'dart:convert';

import 'package:bookshop/service/service_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final DioClient dioClient = DioClient();

class DioClient {
  final Dio _dio = Dio();

  // Singleton
  static final DioClient _instance = DioClient._internal();
  DioClient._internal() {
    _dio.options.baseUrl = ServiceUrl.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 5);
  }
  factory DioClient() {
    return _instance;
  }

  setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Response> post(String path, dynamic data, [bool encode = true]) async {
    try {
      final response =
          await _dio.post(path, data: !encode ? data : jsonEncode(data));
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Response> patch(String path, dynamic data) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
