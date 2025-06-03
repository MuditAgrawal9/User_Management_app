import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';

/// Data source class for handling API operations related to users, posts, and todos
class UserApi {
  // base API URL and default configuration
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  /// Fetches paginated list of users from the API
  /// [limit]: Number of users to fetch per page
  /// [skip]: Number of users to skip (for pagination)
  /// Returns ListUserModel on success
  Future<List<UserModel>> getUsers({int limit = 10, int skip = 0}) async {
    final response = await _dio.get(
      '/users',
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return (response.data['users'] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();
  }

  /// Searches users by name using the API
  /// [query]: Search term for user names
  /// [limit]: Maximum number of results to return
  /// [skip]: Number of results to skip (for pagination)
  /// Returns List matching the search query
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

  /// Fetches all posts for a specific user
  /// [userId]: ID of the user to fetch posts for
  /// Returns List associated with the user
  Future<List<PostModel>> getUserPosts(int userId) async {
    final response = await _dio.get('/posts/user/$userId');
    return (response.data['posts'] as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }

  /// Fetches all todos for a specific user
  /// [userId]: ID of the user to fetch todos for
  /// Returns List associated with the user
  Future<List<TodoModel>> getUserTodos(int userId) async {
    final response = await _dio.get('/todos/user/$userId');
    return (response.data['todos'] as List)
        .map((e) => TodoModel.fromJson(e))
        .toList();
  }
}
