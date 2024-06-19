import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Task extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late bool completed;

  Task(this.title, {this.completed = false});
  // JSON serialization
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
