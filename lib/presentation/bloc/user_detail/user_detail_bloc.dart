import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/local_posts_repository.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

/// BLoC responsible for managing user detail screen state including:
/// - Fetching user posts and todos
/// - Handling local post creation
/// - Combining remote and local data sources
class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository repository;
  final LocalPostsRepository localPostsRepo = LocalPostsRepository();

  UserDetailBloc(this.repository) : super(UserDetailInitial()) {
    on<FetchUserDetail>(_onFetchUserDetail);
    on<AddLocalPost>(_onAddLocalPost);
  }

  /// Handles user detail fetching event
  /// 1. Shows loading state
  /// 2. Fetches remote posts and todos concurrently
  /// 3. Combines with locally stored posts
  /// 4. Emits loaded state with combined data
  Future<void> _onFetchUserDetail(
    FetchUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserDetailLoading());
    try {
      final remotePosts = await repository.getUserPosts(event.userId);
      final todos = await repository.getUserTodos(event.userId);
      final localPosts = localPostsRepo.getLocalPosts(event.userId);
      final allPosts = [...localPosts, ...remotePosts];
      emit(UserDetailLoaded(allPosts, todos));
    } catch (e) {
      emit(UserDetailError('Failed to load user details'));
    }
  }

  /// Handles local post creation event
  /// 1. Stores post in local storage
  /// 2. Updates UI state with new post at top
  /// 3. Maintains existing remote posts
  Future<void> _onAddLocalPost(
    AddLocalPost event,
    Emitter<UserDetailState> emit,
  ) async {
    // Persist to local storage
    localPostsRepo.addLocalPost(event.userId, event.post);

    if (state is UserDetailLoaded) {
      final currentState = state as UserDetailLoaded;
      // Filter out previous local posts (preserve remote)
      final remotePosts = currentState.posts.where((p) => p.id > 0).toList();
      // Combine new local posts with original remote posts
      final updatedPosts = [
        ...localPostsRepo.getLocalPosts(event.userId),
        ...remotePosts,
      ];
      emit(UserDetailLoaded(updatedPosts, currentState.todos));
    }
  }
}
