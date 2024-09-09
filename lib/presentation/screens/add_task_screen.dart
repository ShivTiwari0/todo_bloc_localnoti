// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:shivansh_quantum_it/core/services/notification_services.dart';
import 'package:shivansh_quantum_it/core/ui.dart';
import 'package:shivansh_quantum_it/data/model/task_model.dart';
import 'package:shivansh_quantum_it/logic/cubit/task_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;
  final bool? isUpdate;
  const AddTaskScreen({
    super.key,
     this.task,
    this.isUpdate,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();

  static const routeName = "add-task";
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  TaskPriority _priority = TaskPriority.low;
  DateTime _dueDate = DateTime.now();
  DateTime? _reminder;

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _selectReminder(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the picked date and time
        final DateTime pickedReminder = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _reminder = pickedReminder;
        });
      }
    }
  }

_submitTask(BuildContext context, bool isUpdate) {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    TaskModel newTask = TaskModel(
      id: isUpdate ? widget.task?.id : null,
      title: _title,
      description: _description,
      priority: _priority,
      dueDate: _dueDate,
      reminder: _reminder,
    );

    if (isUpdate && widget.task != null) {
      BlocProvider.of<TaskCubit>(context).updateTask(newTask);
    } else {
      BlocProvider.of<TaskCubit>(context).addTask(newTask);
    }

    // Schedule the notification
    final DateTime notificationTime = _reminder!;
    NotificationService.showScheduleNotification(
      title: "Your task '$_title' is due soon",
      body: "Priority is ${_priority.toString().split('.').last.toUpperCase()}",
      payload: _description,
      scheduledTime: notificationTime,
    );

    Navigator.pop(context); // Go back after adding or updating the task
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Title Field
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    border: Border.all(color: Colors.yellow, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      fillColor: AppColors.accent,
                      filled: true,
                      border: InputBorder.none,
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Description Field
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    border: Border.all(color: Colors.yellow, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      fillColor: AppColors.accent,
                      filled: true,
                      border: InputBorder.none,
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Priority Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    border: Border.all(color: Colors.yellow, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<TaskPriority>(
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      fillColor: AppColors.accent,
                      filled: true,
                      border: InputBorder.none,
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    value: _priority,
                    onChanged: (TaskPriority? newValue) {
                      setState(() {
                        _priority = newValue!;
                      });
                    },
                    items: TaskPriority.values.map((TaskPriority priority) {
                      return DropdownMenuItem<TaskPriority>(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Due Date
                ListTile(
                  title: Text(
                    "Due Date: ${DateFormat('yMMMd').format(_dueDate)}",
                    style: TextStyle(color: AppColors.accent),
                  ),
                  trailing:
                      const Icon(Icons.calendar_today, color: Colors.amber),
                  onTap: () => _selectDueDate(context),
                ),

                // Reminder
                ListTile(
                  title: Text(
                    _reminder == null
                        ? "Set Reminder (Optional)"
                        : "Reminder: ${DateFormat('yMMMd').format(_reminder!)}",
                    style: TextStyle(color: AppColors.accent),
                  ),
                  trailing:
                      const Icon(Icons.notifications, color: Colors.amber),
                  onTap: () => _selectReminder(context),
                ),
                const SizedBox(height: 20),

                // Add Task Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Background color
                    shadowColor: Colors.yellow.withOpacity(0.5),
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  onPressed: () =>
                      _submitTask(context, widget.isUpdate ?? false),
                  child:  Text(widget.isUpdate??false ?"Update":
                    'Add Task',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
