import 'package:equatable/equatable.dart';

// Abstract base class for all user list events.
abstract class UserListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event to trigger fetching the initial user list or refreshing it.
class FetchUsers extends UserListEvent {}

/// Event to trigger a search for users by name.
class SearchUsers extends UserListEvent {
  final String query;
  SearchUsers(this.query);

  @override
  List<Object> get props => [query];
}

/// Event to trigger loading more users (pagination/infinite scroll).
class LoadMoreUsers extends UserListEvent {}
