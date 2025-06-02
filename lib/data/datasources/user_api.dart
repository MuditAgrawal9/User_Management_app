import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';

class UserApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  Future<List<UserModel>> getUsers({int limit = 10, int skip = 0}) async {
    final response = await _dio.get(
      '/users',
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return (response.data['users'] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();
  }

  Future<List<UserModel>> searchUsers(
    String query, {
    int limit = 10,
    int skip = 0,
  }) async {
    final response = await _dio.get(
      '/users/search',
      queryParameters: {'q': query, 'limit': limit, 'skip': skip},
    );
    return (response.data['users'] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();
  }

  Future<List<PostModel>> getUserPosts(int userId) async {
    final response = await _dio.get('/posts/user/$userId');
    return (response.data['posts'] as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }

  Future<List<TodoModel>> getUserTodos(int userId) async {
    final response = await _dio.get('/todos/user/$userId');
    return (response.data['todos'] as List)
        .map((e) => TodoModel.fromJson(e))
        .toList();
  }
}
