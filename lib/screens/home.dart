import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_facchi/database/db_provider.dart';
import 'package:to_do_facchi/models/task_model.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController inputController = TextEditingController();
  String newTaskTxt = "";
  DateTime _selectedValue = DateTime.now();

  List<String> m_names = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];

  getTask() async {
    final tasks = await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff30384c),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            children: <Widget>[
              Container(
                //padding: EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  children: <Widget>[
                    DatePicker(
                      DateTime.now(),
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.black,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        // New date selected
                        setState(() {
                          print("Giorno: ${date.day}");
                          _selectedValue = date;
                        });
                      },
                    ),

                    Expanded(
                      child: FutureBuilder(
                        future: getTask(),
                        builder: (context, AsyncSnapshot tasksData) {
                          switch (tasksData.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());

                            case ConnectionState.done:
                              if (tasksData.data != Null) {
                                print(
                                    "Task data: " + tasksData.data.toString());

                                print(tasksData.data);
                                return Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    itemCount: tasksData.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String task = tasksData
                                          .data[index]['task']
                                          .toString();
                                      String day = DateTime
                                          .parse(tasksData
                                          .data[index]['creationDate'])
                                          .day
                                          .toString();

                                      String month = DateTime
                                          .parse(tasksData
                                          .data[index]['creationDate'])
                                          .month
                                          .toString();

                                      return Slidable(
                                        actionPane: SlidableDrawerActionPane(),
                                        actionExtentRatio: 0.2,
                                        secondaryActions: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            width: 5,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(25)
                                            ),
                                            child: IconSlideAction(
                                              color: Colors.transparent,
                                              icon: Icons.check_circle,
                                              onTap: () {
                                                DBProvider.dataBase.deleteTask(tasksData
                                                    .data[index]["id"]);

                                                print(index);
                                                tasksData.data.removeAt(index);

                                              },
                                            ),
                                          ),
                                        ],
                                        child: Card(
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
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        day,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      Text(
                                                        m_names[int.parse(month)-1],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ],
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 18),
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
                                hintStyle: TextStyle(color: Colors.white70),
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
                                  task: newTaskTxt, dateTime: _selectedValue);
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
      ),
    );
  }
}

