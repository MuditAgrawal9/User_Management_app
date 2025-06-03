import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/post_model.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository repository;

  // Map to store local posts per user
  final Map<int, List<PostModel>> _localPosts = {};

  UserDetailBloc(this.repository) : super(UserDetailInitial()) {
    on<FetchUserDetail>(_onFetchUserDetail);
    on<AddLocalPost>(_onAddLocalPost);
  }

  Future<void> _onFetchUserDetail(
    FetchUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserDetailLoading());
    try {
      final remotePosts = await repository.getUserPosts(event.userId);
      final todos = await repository.getUserTodos(event.userId);
      final localPosts = _localPosts[event.userId] ?? [];
      final allPosts = [...localPosts, ...remotePosts]; // Local posts at top
      emit(UserDetailLoaded(allPosts, todos));
    } catch (e) {
      emit(UserDetailError('Failed to load user details'));
    }
  }

  Future<void> _onAddLocalPost(
    AddLocalPost event,
    Emitter<UserDetailState> emit,
  ) async {
    print('🟢 Adding local post: ${event.post.title}');
    // 1. Add the new local post
    _localPosts.putIfAbsent(event.userId, () => []);
    _localPosts[event.userId]!.insert(0, event.post);

    // 2. Merge local and remote posts
    if (state is UserDetailLoaded) {
      final currentState = state as UserDetailLoaded;
      // Only include remote posts (positive IDs)
      final remotePosts = currentState.posts.where((p) => p.id > 0).toList();
      final updatedPosts = [..._localPosts[event.userId]!, ...remotePosts];

      print('🔄 Emitting ${updatedPosts.length} posts');
      // 3. Emit new state
      emit(UserDetailLoaded(updatedPosts, currentState.todos));
    }
  }
}
