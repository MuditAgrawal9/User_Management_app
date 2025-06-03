// lib/data/models/post_model.dart
import 'package:hive/hive.dart';

part 'post_model.g.dart';

/// Integrated with Hive for local persistence.
@HiveType(typeId: 1)
class PostModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  /// Constructor for creating a PostModel instance.
  PostModel({required this.id, required this.title, required this.body});

  /// Factory constructor to create a PostModel from JSON.
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      PostModel(id: json['id'], title: json['title'], body: json['body']);

  /// Converts the PostModel instance to a JSON map
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};
}
