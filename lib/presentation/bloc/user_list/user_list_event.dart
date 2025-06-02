import 'package:equatable/equatable.dart';

abstract class UserListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUsers extends UserListEvent {}

class SearchUsers extends UserListEvent {
  final String query;
  SearchUsers(this.query);

  @override
  List<Object> get props => [query];
}

class LoadMoreUsers extends UserListEvent {}
