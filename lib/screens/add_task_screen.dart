import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = '/add-task';

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  var _description = '';
  var _dueDate = DateTime.now();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<TaskProvider>(context, listen: false).addTask(
        _title,
        _description,
        _dueDate,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
    final double labelFontSize = screenWidth * 0.04;
    final double buttonFontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(fontSize: labelFontSize),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a title.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: marginVertical),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(fontSize: labelFontSize),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a description.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: marginVertical),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Due Date: ${_dueDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(fontSize: labelFontSize),
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _dueDate) {
                        setState(() {
                          _dueDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select date'),
                  ),
                ],
              ),
              SizedBox(height: marginVertical),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  textStyle: TextStyle(fontSize: buttonFontSize),
                  padding: EdgeInsets.symmetric(
                    vertical: paddingVertical * 1.5,
                  ),
                ),
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
