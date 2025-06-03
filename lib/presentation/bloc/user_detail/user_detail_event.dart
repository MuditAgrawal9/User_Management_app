import 'package:equatable/equatable.dart';
import '../../../data/models/post_model.dart';

/// Abstract base class for all user detail events.
abstract class UserDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to trigger fetching of user details (posts and todos) for a given user.
class FetchUserDetail extends UserDetailEvent {
  final int userId;
  FetchUserDetail(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Event to add a local post for a specific user.
class AddLocalPost extends UserDetailEvent {
  final int userId;
  final PostModel post;
  AddLocalPost(this.userId, this.post);

  @override
  List<Object?> get props => [userId, post];
}
