import 'package:equatable/equatable.dart';
import '../../../data/models/post_model.dart';

abstract class UserDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserDetail extends UserDetailEvent {
  final int userId;
  FetchUserDetail(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddLocalPost extends UserDetailEvent {
  final int userId;
  final PostModel post;
  AddLocalPost(this.userId, this.post);

  @override
  List<Object?> get props => [userId, post];
}
