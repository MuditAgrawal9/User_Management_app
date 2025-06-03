class TodoModel {
  final int id;
  final String todo;
  final bool completed;

  TodoModel({required this.id, required this.todo, required this.completed});

  /// Factory constructor to create a TodoModel from a JSON map.
  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    id: json['id'],
    todo: json['todo'],
    completed: json['completed'],
  );
}
