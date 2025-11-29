import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:reto_obile/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart'; // Para obtener token si es necesario

class ApiError implements Exception {
  final String message;
  final int? status;
  ApiError(this.message, {this.status});
  @override
  String toString() => message;
}

class PostService {
  final String baseUrl;

  PostService({this.baseUrl = 'http://192.168.1.72:8000/api'});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// Crear un post
  Future<Post> createPost({
    required String title,
    String? description,
    List<File>? photos,
    List<File>? videos,
  }) async {
    final token = await _getToken();
    if (token == null) throw ApiError("No hay token de autenticación");

    var uri = Uri.parse('$baseUrl/posts/');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    if (description != null) request.fields['description'] = description;

    if (photos != null) {
      for (var photo in photos) {
        request.files.add(await http.MultipartFile.fromPath('photos', photo.path));
      }
    }

    if (videos != null) {
      for (var video in videos) {
        request.files.add(await http.MultipartFile.fromPath('videos', video.path));
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw ApiError(error['detail'] ?? 'Error al crear post', status: response.statusCode);
    }
  }

  /// Obtener lista de posts
  Future<List<Post>> listPosts({int offset = 0, int limit = 20}) async {
    final token = await _getToken();
    if (token == null) throw ApiError("No hay token de autenticación");

    final uri = Uri.parse('$baseUrl/posts?offset=$offset&limit=$limit');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw ApiError(error['detail'] ?? 'Error al obtener posts', status: response.statusCode);
    }
  }

  /// Obtener un post
  Future<Post> getPost(String postId) async {
    final token = await _getToken();
    if (token == null) throw ApiError("No hay token de autenticación");

    final uri = Uri.parse('$baseUrl/posts/$postId');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw ApiError(error['detail'] ?? 'Error al obtener post', status: response.statusCode);
    }
  }

  /// Eliminar post
  Future<void> deletePost(String postId) async {
    final token = await _getToken();
    if (token == null) throw ApiError("No hay token de autenticación");

    final uri = Uri.parse('$baseUrl/posts/$postId');
    final response = await http.delete(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode != 204) {
      final error = jsonDecode(response.body);
      throw ApiError(error['detail'] ?? 'Error al eliminar post', status: response.statusCode);
    }
  }
}
