import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/db_handler.dart';
import 'package:to_do_list/home.dart';
import 'package:to_do_list/model.dart';

class AddUpdateTaskScreen extends StatefulWidget {
  // const AddUpdateTaskScreen({super.key});

  int? todoId;
  String? todoTitle;
  String? todoDescription;
  String? todoDateandTime;
  bool? update;

  AddUpdateTaskScreen({
    this.todoId,
    this.todoTitle,
    this.todoDescription,
    this.todoDateandTime,
    this.update,
  });

  @override
  State<AddUpdateTaskScreen> createState() => _AddUpdateTaskScreenState();
}

class _AddUpdateTaskScreenState extends State<AddUpdateTaskScreen> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDescription);
    String appTile;
    if (widget.update == true) {
      appTile = "Update Task";
    } else {
      appTile = "Add Task";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTile,
          style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                key: _fromKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: "Note Title"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter some Text";
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: descController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: "Write notes here......"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter some Text";
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.pink,
                                  elevation: 10),
                              onPressed: () {
                                if (_fromKey.currentState!.validate()) {
                                  String updatedTime = DateFormat('yMd')
                                      .add_jm()
                                      .format(DateTime.now())
                                      .toString();
                                  if (widget.update == true) {
                                    dbHelper!.update(TodoModel(
                                      id: widget.todoId,
                                      title: titleController.text,
                                      desc: descController.text,
                                      dateandtime: updatedTime,
                                    ));
                                  } else {
                                    dbHelper!.insert(TodoModel(
                                      title: titleController.text,
                                      desc: descController.text,
                                      dateandtime: updatedTime,
                                    ));
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePageScreen()));
                                  titleController.clear();
                                  descController.clear();
                                  print("Task Added");
                                }
                              },
                              child: Text("Submit")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.green,
                                  elevation: 10),
                              onPressed: () {
                                setState(() {
                                  titleController.clear();
                                  descController.clear();
                                });
                              },
                              child: Text("Clear")),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
