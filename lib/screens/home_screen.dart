import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/screens/view_task_screen.dart';

import '../models/task_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final taskManagerBox = Hive.box("Task Manager");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Task Manager",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: ValueListenableBuilder(
        valueListenable: taskManagerBox.listenable(),
        builder: (context, box, _) {
          return box.isEmpty?Center(child: Text("No data found",style: TextStyle(fontSize: 18),)):ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final task = box.getAt(index);
              final formKey = GlobalKey<FormState>();
              final titleController = TextEditingController();
              final descriptionController = TextEditingController();

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    title: Text(task.title),
                    subtitle: Text(
                      task.description,
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ViewTaskScreen(
                            title: task.title,
                            description: task.description,
                          ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                titleController.text = task.title;
                                descriptionController.text = task.description;

                                return AlertDialog(
                                  title: Text("Edit Task"),
                                  content: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: titleController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter title";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: " Add task title",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        TextFormField(
                                          controller: descriptionController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter description";
                                            }
                                            return null;
                                          },
                                          minLines: 4,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Add description",
                                            alignLabelWithHint: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              TaskManager newTask = TaskManager(
                                                title: titleController.text,
                                                description:
                                                descriptionController.text,
                                              );
                                              final taskManagerBox = Hive.box(
                                                "Task Manager",
                                              );
                                              taskManagerBox.putAt(
                                                index,
                                                newTask,
                                              );
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: const Text(
                                            "Ok",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit_outlined, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            taskManagerBox.deleteAt(index);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final titleController = TextEditingController();
          final descriptionController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return customAlertDialogue(
                context: context,
                title: 'Add New Task',
                titleController: titleController,
                descriptionController: descriptionController,
              );
            },
          );
        },
        child: const Text("New"),
      ),
    );
  }
}

Widget customAlertDialogue({
  required BuildContext context,
  required String title,
  required TextEditingController titleController,
  required TextEditingController descriptionController,
}) {
  final formKey = GlobalKey<FormState>();

  return AlertDialog(
    title: Center(child: Text(title)),
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter title";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: " Add task title",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: descriptionController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter description";
              }
              return null;
            },
            minLines: 4,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Add description",
              labelStyle: TextStyle(color: Colors.grey),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                TaskManager newTask = TaskManager(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                final taskManagerBox = Hive.box("Task Manager");
                taskManagerBox.add(newTask);
                Navigator.of(context).pop();
              }
            },
            child: const Text("Ok", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ],
  );
}
