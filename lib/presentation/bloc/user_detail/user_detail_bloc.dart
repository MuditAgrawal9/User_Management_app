import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/local_posts_repository.dart';
import '../../../data/models/post_model.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository repository;
  final LocalPostsRepository localPostsRepo = LocalPostsRepository();

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
      final localPosts = localPostsRepo.getLocalPosts(event.userId);
      final allPosts = [...localPosts, ...remotePosts];
      emit(UserDetailLoaded(allPosts, todos));
    } catch (e) {
      emit(UserDetailError('Failed to load user details'));
    }
  }

  Future<void> _onAddLocalPost(
    AddLocalPost event,
    Emitter<UserDetailState> emit,
  ) async {
    localPostsRepo.addLocalPost(event.userId, event.post);

    if (state is UserDetailLoaded) {
      final currentState = state as UserDetailLoaded;
      final remotePosts = currentState.posts.where((p) => p.id > 0).toList();
      final updatedPosts = [
        ...localPostsRepo.getLocalPosts(event.userId),
        ...remotePosts,
      ];
      emit(UserDetailLoaded(updatedPosts, currentState.todos));
    }
  }
}
