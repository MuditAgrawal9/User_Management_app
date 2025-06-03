import 'package:equatable/equatable.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/todo_model.dart';

/// Base state class for user detail screen states
abstract class UserDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class UserDetailInitial extends UserDetailState {}

/// Loading state while fetching user details
class UserDetailLoading extends UserDetailState {}

/// Success state containing loaded user posts and todos
class UserDetailLoaded extends UserDetailState {
  final List<PostModel> posts;
  final List<TodoModel> todos;

  UserDetailLoaded(this.posts, this.todos);

  @override
  List<Object?> get props => [posts, todos];
}

/// Error state containing failure message
class UserDetailError extends UserDetailState {
  final String message;
  UserDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
