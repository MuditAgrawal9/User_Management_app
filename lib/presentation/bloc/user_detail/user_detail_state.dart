import 'package:equatable/equatable.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/todo_model.dart';

abstract class UserDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  final List<PostModel> posts;
  final List<TodoModel> todos;

  UserDetailLoaded(this.posts, this.todos);

  @override
  List<Object?> get props => [posts, todos];
}

class UserDetailError extends UserDetailState {
  final String message;
  UserDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
