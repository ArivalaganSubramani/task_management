import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../screens/add_task_screen.dart';
import '../screens/edit_task_screen.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<TaskProvider>(context).fetchAndSetTasks().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    // MediaQuery to get screen size
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Dynamic padding and margin based on screen size
    final double paddingVertical = screenHeight * 0.01;
    final double paddingHorizontal = screenWidth * 0.04;
    final double marginVertical = screenHeight * 0.01;
    final double marginHorizontal = screenWidth * 0.04;

    // Dynamic text size
    final double titleFontSize = screenWidth * 0.05;
    final double subtitleFontSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Dashboard')),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(AddTaskScreen.routeName);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (ctx, i) {
          final dueDate = DateFormat.yMMMd().format(tasks[i].dueDate);

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(
              vertical: marginVertical,
              horizontal: marginHorizontal,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: paddingVertical,
                horizontal: paddingHorizontal,
              ),
              title: Text(
                tasks[i].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                ),
              ),
              subtitle: Text(
                '${tasks[i].description}\nDue: $dueDate',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        EditTaskScreen.routeName,
                        arguments: tasks[i].id,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text('Do you want to remove this task?'),
                          actions: [
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                taskProvider.deleteTask(tasks[i].id);
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  EditTaskScreen.routeName,
                  arguments: tasks[i].id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
