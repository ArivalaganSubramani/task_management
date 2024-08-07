import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/task_provider.dart';
import './screens/task_list_screen.dart';
import './screens/add_task_screen.dart';
import './screens/edit_task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => TaskProvider(),
      child: MaterialApp(
        title: 'Task Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TaskListScreen(),
        routes: {
          AddTaskScreen.routeName: (ctx) => AddTaskScreen(),
          EditTaskScreen.routeName: (ctx) => EditTaskScreen(),
        },
      ),
    );
  }
}
