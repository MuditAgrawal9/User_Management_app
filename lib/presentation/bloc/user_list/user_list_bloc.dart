import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user_model.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserRepository repository;
  static const int _limit = 10;
  int _skip = 0;
  bool _isFetching = false;
  String _currentQuery = '';

  UserListBloc(this.repository) : super(UserListInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    _skip = 0;
    _currentQuery = '';
    try {
      final users = await repository.getUsers(limit: _limit, skip: _skip);
      emit(UserListLoaded(users, hasReachedMax: users.length < _limit));
    } catch (e) {
      emit(UserListError('Failed to load users'));
    }
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    _skip = 0;
    _currentQuery = event.query;
    try {
      final users = await repository.searchUsers(
        event.query,
        limit: _limit,
        skip: _skip,
      );
      emit(UserListLoaded(users, hasReachedMax: users.length < _limit));
    } catch (e) {
      emit(UserListError('Search failed'));
    }
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsers event,
    Emitter<UserListState> emit,
  ) async {
    if (_isFetching || state is! UserListLoaded) return;
    _isFetching = true;
    final currentState = state as UserListLoaded;
    _skip += _limit;
    try {
      List<UserModel> users;
      if (_currentQuery.isEmpty) {
        users = await repository.getUsers(limit: _limit, skip: _skip);
      } else {
        users = await repository.searchUsers(
          _currentQuery,
          limit: _limit,
          skip: _skip,
        );
      }
      final allUsers = List<UserModel>.from(currentState.users)..addAll(users);
      emit(UserListLoaded(allUsers, hasReachedMax: users.length < _limit));
    } catch (e) {
      emit(UserListError('Failed to load more users'));
    }
    _isFetching = false;
  }
}
