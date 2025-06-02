import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserDetailBloc extends Bloc<FetchUserDetail, UserDetailState> {
  final UserRepository repository;

  UserDetailBloc(this.repository) : super(UserDetailInitial()) {
    on<FetchUserDetail>(_onFetchUserDetail);
  }

  Future<void> _onFetchUserDetail(
    FetchUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserDetailLoading());
    try {
      final posts = await repository.getUserPosts(event.userId);
      final todos = await repository.getUserTodos(event.userId);
      emit(UserDetailLoaded(posts, todos));
    } catch (e) {
      emit(UserDetailError('Failed to load user details'));
    }
  }
}
