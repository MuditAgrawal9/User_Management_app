import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

/// Abstract base class for all user list states.
abstract class UserListState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// State before any users are loaded or when the BLoC is first created.
class UserListInitial extends UserListState {}

/// State when users are being loaded (shows loading indicator in UI).
class UserListLoading extends UserListState {}

/// State when users are successfully loaded.
/// [users]: The list of loaded users.
/// [hasReachedMax]: True if all users have been loaded (no more data for pagination).
class UserListLoaded extends UserListState {
  final List<UserModel> users;
  final bool hasReachedMax;

  UserListLoaded(this.users, {this.hasReachedMax = false});

  @override
  List<Object?> get props => [users, hasReachedMax];
}

/// State when an error occurs during user loading or searching.
/// [message]: The error message to display in the UI.
class UserListError extends UserListState {
  final String message;
  UserListError(this.message);

  @override
  List<Object?> get props => [message];
}
