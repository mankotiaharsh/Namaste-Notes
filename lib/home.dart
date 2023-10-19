import 'package:flutter/material.dart';
import 'package:to_do_list/addUpdateTask.dart';
import 'package:to_do_list/db_handler.dart';
import 'package:to_do_list/model.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Namaste Notes",
          style: TextStyle(
              fontSize: 25, letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: dataList,
              builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No Task Found",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      int todoId = snapshot.data![index].id!;
                      String todoTitle = snapshot.data![index].title.toString();
                      String todoDescription =
                          snapshot.data![index].desc.toString();
                      String todoDateandTime =
                          snapshot.data![index].dateandtime.toString();

                      return Dismissible(
                          key: ValueKey<int>(todoId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.redAccent,
                            child: Icon(Icons.delete),
                          ),
                          onDismissed: (DismissDirection direction) {
                            dbHelper!.delete(todoId);
                            dataList = dbHelper!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                            setState(() {
                              loadData();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                        spreadRadius: 1)
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.lightGreen,
                                      Colors.green,
                                      Colors.lightGreen,
                                      Colors.lightGreen,
                                      Colors.limeAccent.shade700,
                                      Colors.lightGreen,
                                    ],
                                    begin: Alignment
                                        .topLeft, // Align the gradient from top-left
                                    end: Alignment.bottomRight,
                                  )),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        todoTitle,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        todoDescription,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(todoDateandTime),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddUpdateTaskScreen(
                                                        todoId: todoId,
                                                        todoTitle: todoTitle,
                                                        todoDescription:
                                                            todoDescription,
                                                        todoDateandTime:
                                                            todoDateandTime,
                                                        update: true,
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.edit,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddUpdateTaskScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
