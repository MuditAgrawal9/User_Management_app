import 'package:hive/hive.dart';
import '../models/post_model.dart';

class LocalPostsRepository {
  static final LocalPostsRepository _instance =
      LocalPostsRepository._internal();
  factory LocalPostsRepository() => _instance;
  LocalPostsRepository._internal();

  final Box<List> _box = Hive.box<List>('local_posts');

  List<PostModel> getLocalPosts(int userId) {
    final raw = _box.get(userId.toString());
    if (raw == null) return [];
    return List<PostModel>.from(raw);
  }

  void addLocalPost(int userId, PostModel post) {
    final key = userId.toString();
    final posts = getLocalPosts(userId);
    posts.insert(0, post);
    _box.put(key, posts);
  }
}
