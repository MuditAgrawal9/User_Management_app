import 'package:equatable/equatable.dart';

class FetchUserDetail extends Equatable {
  final int userId;
  FetchUserDetail(this.userId);

  @override
  List<Object> get props => [userId];
}
