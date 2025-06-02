import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class UserListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<UserModel> users;
  final bool hasReachedMax;

  UserListLoaded(this.users, {this.hasReachedMax = false});

  @override
  List<Object?> get props => [users, hasReachedMax];
}

class UserListError extends UserListState {
  final String message;
  UserListError(this.message);

  @override
  List<Object?> get props => [message];
}
