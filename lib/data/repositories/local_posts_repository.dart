import 'package:hive/hive.dart';
import '../models/post_model.dart';

/// Repository for managing local (offline) posts using Hive.
/// Implements the singleton pattern to ensure a single instance across the app.
class LocalPostsRepository {
  // Singleton instance
  static final LocalPostsRepository _instance =
      LocalPostsRepository._internal();
  factory LocalPostsRepository() => _instance;
  LocalPostsRepository._internal();

  // Hive box for storing lists of posts per user (keyed by userId as String)
  final Box<List> _box = Hive.box<List>('local_posts');

  /// Retrieves the list of locally stored posts for a specific user.
  /// [userId]: The ID of the user whose posts are being retrieved.
  /// Returns a list of [PostModel]s, or an empty list if none exist.
  List<PostModel> getLocalPosts(int userId) {
    final raw = _box.get(userId.toString());
    if (raw == null) return [];
    return List<PostModel>.from(raw);
  }

  /// Adds a local post for a specific user and saves it to Hive.
  /// [userId]: The ID of the user.
  /// [post]: The [PostModel] to add.
  void addLocalPost(int userId, PostModel post) {
    final key = userId.toString();
    final posts = getLocalPosts(userId);
    posts.insert(0, post);
    _box.put(key, posts);
  }
}
