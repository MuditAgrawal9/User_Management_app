import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user_model.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) =>
      droppable<E>().call(events.throttle(duration), mapper);
}

/// BLoC responsible for managing user list state including:
/// - Initial user loading
/// - Search functionality
/// - Pagination with infinite scroll
/// - Error state handling
class UserListBloc extends Bloc<UserListEvent, UserListState> {
  // Pagination configuration
  final UserRepository repository;
  static const int _limit = 10; // Number of items per page
  int _skip = 0; // Number of items to skip for pagination

  // Internal state variables
  bool _isFetching = false;
  String _currentQuery = '';
  List<UserModel> _users = [];
  bool _hasReachedMax = false;

  UserListBloc(this.repository) : super(UserListInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
    on<LoadMoreUsers>(
      _onLoadMoreUsers,
      transformer: throttleDroppable(const Duration(milliseconds: 500)),
    );
  }

  /// Handles initial user fetch or refresh action
  /// Resets all pagination parameters and fetches first page
  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    _skip = 0;
    _currentQuery = '';
    _users = [];
    _hasReachedMax = false;
    try {
      final users = await repository.getUsers(limit: _limit, skip: _skip);
      _users = users;
      _hasReachedMax = users.length < _limit;
      emit(
        UserListLoaded(
          List<UserModel>.from(_users),
          hasReachedMax: _hasReachedMax,
        ),
      );
    } catch (e) {
      emit(UserListError('Failed to load users'));
    }
  }

  /// Handles user search functionality
  /// Resets pagination and maintains current search query
  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    _skip = 0;
    _currentQuery = event.query;
    _users = [];
    _hasReachedMax = false;
    try {
      final users = await repository.searchUsers(
        event.query,
        limit: _limit,
        skip: _skip,
      );
      _users = users;
      _hasReachedMax = users.length < _limit;
      emit(
        UserListLoaded(
          List<UserModel>.from(_users),
          hasReachedMax: _hasReachedMax,
        ),
      );
    } catch (e) {
      emit(UserListError('Search failed'));
    }
  }

  /// Handles pagination for infinite scroll
  /// Prevents duplicate requests and checks for remaining data
  Future<void> _onLoadMoreUsers(
    LoadMoreUsers event,
    Emitter<UserListState> emit,
  ) async {
    // print(
    //   '[UserListBloc] LoadMoreUsers event received. _isFetching=$_isFetching, _hasReachedMax=$_hasReachedMax, _skip=$_skip',
    // );
    if (_isFetching || _hasReachedMax) return;
    _isFetching = true;
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
      // print(
      //   '[UserListBloc] Loaded ${users.length} users for skip=$_skip, limit=$_limit',
      // );
      if (users.isEmpty) {
        _hasReachedMax = true;
      } else {
        _users.addAll(users);
        _hasReachedMax = users.length < _limit;
      }
      emit(
        UserListLoaded(
          List<UserModel>.from(_users),
          hasReachedMax: _hasReachedMax,
        ),
      );
    } catch (e) {
      emit(UserListError('Failed to load more users'));
    }
    _isFetching = false;
  }
}
