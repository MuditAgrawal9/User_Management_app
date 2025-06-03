import '../datasources/user_api.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';

/// Repository layer that abstracts data operations for user-related entities.
/// Acts as a bridge between data sources (API) and business logic (BLoC).
class UserRepository {
  final UserApi api = UserApi();

  /// Fetches paginated list of users from the remote data source
  /// [limit]: Number of items per page
  /// [skip]: Number of items to skip (for pagination)
  Future<List<UserModel>> getUsers({int limit = 10, int skip = 0}) async {
    // print('[UserRepository] getUsers called with limit=$limit, skip=$skip');
    // final stopwatch = Stopwatch()..start();
    try {
      final users = await api.getUsers(limit: limit, skip: skip);
      // print(
      //   '[UserRepository] getUsers returned ${users.length} users in ${stopwatch.elapsedMilliseconds}ms',
      // );
      return users;
    } catch (e) {
      // print('[UserRepository] getUsers ERROR: $e');
      rethrow;
    }
  }

  /// Searches users by name using the remote data source
  /// [query]: Search term to filter users
  /// [limit]: Maximum number of results per page
  /// [skip]: Number of results to skip (for pagination)
  Future<List<UserModel>> searchUsers(
    String query, {
    int limit = 10,
    int skip = 0,
  }) => api.searchUsers(query, limit: limit, skip: skip);

  /// Retrieves posts for a specific user from the remote data source
  /// [userId]: Unique identifier of the target user
  Future<List<PostModel>> getUserPosts(int userId) => api.getUserPosts(userId);

  // Retrieves todos for a specific user from the remote data source
  /// [userId]: Unique identifier of the target user
  Future<List<TodoModel>> getUserTodos(int userId) => api.getUserTodos(userId);
}
