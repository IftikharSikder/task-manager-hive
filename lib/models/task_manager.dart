import 'package:hive/hive.dart';

part 'task_manager.g.dart';

@HiveType(typeId: 0)
class TaskManager extends HiveObject{
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;

  TaskManager({required this.title, required this.description});
}