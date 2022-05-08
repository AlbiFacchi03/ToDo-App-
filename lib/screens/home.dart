import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_facchi/database/db_provider.dart';
import 'package:to_do_facchi/models/task_model.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController inputController = TextEditingController();
  String newTaskTxt = "";

  getTask() async {
    final tasks = await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff30384c),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Container(
              //padding: EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder(
                      future: getTask(),
                      builder: (context, AsyncSnapshot tasksData) {
                        switch (tasksData.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());

                          case ConnectionState.done:
                            if (tasksData.hasData) {
                              print(tasksData);

                              print(tasksData.data);
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  itemCount: tasksData.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String task = tasksData.data[index]['task']
                                        .toString();
                                    String day = DateTime.parse(tasksData
                                        .data[index]['creationDate'])
                                        .day
                                        .toString();
                                    return Card(
                                      color: Colors.purple,
                                      child: InkWell(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                              EdgeInsets.only(right: 12),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                day,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Text(
                                                  task,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "You have no Task for today",
                                  style: TextStyle(color: Colors.white54),
                                ),
                              );
                            }
                          case ConnectionState.none:
                            return Text("ok");
                            break;
                          case ConnectionState.active:
                            return Text("ok");
                            break;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: inputController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xff30384c),
                              hintText: "Type a new Task",
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        FlatButton.icon(
                          icon: Icon(Icons.add, color: Colors.white),
                          label: Text("Add Task"),
                          color: Colors.purple,
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              newTaskTxt = inputController.text.toString();
                              inputController.text = "";
                            });
                            Task newTask = Task(
                                task: newTaskTxt, dateTime: DateTime.now());
                            DBProvider.dataBase.addNewTask(newTask);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}