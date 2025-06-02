import '../datasources/user_api.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';

class UserRepository {
  final UserApi api = UserApi();

  Future<List<UserModel>> getUsers({int limit = 10, int skip = 0}) =>
      api.getUsers(limit: limit, skip: skip);
  Future<List<UserModel>> searchUsers(
    String query, {
    int limit = 10,
    int skip = 0,
  }) => api.searchUsers(query, limit: limit, skip: skip);
  Future<List<PostModel>> getUserPosts(int userId) => api.getUserPosts(userId);
  Future<List<TodoModel>> getUserTodos(int userId) => api.getUserTodos(userId);
}
