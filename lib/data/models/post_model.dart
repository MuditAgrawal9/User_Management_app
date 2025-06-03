// lib/data/models/post_model.dart
import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 1)
class PostModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  PostModel({required this.id, required this.title, required this.body});

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      PostModel(id: json['id'], title: json['title'], body: json['body']);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};
}
