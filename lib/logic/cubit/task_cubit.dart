import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shivansh_quantum_it/data/database/db_helper.dart';
import 'package:shivansh_quantum_it/data/model/task_model.dart';
import 'package:shivansh_quantum_it/logic/cubit/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final DbHelper dbHelper = DbHelper.getInstance;
  TaskCubit() : super(TaskInitialState()) {
    _initialize();
  }

  void _initialize() async {
    emit(TaskLoadingState(state.tasks));
    try {
      List<TaskModel> tasks = await getAllTasks();
    
      emit(TaskLoadedState(tasks));
    
    } catch (e) {
      emit(TaskErrorState(state.tasks, "Error initializing tasks: $e"));
    }
  }

   // Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final tasks = await dbHelper.getTasks();
       log("Task Loaded $tasks");
      return tasks;
    } catch (e) {
      emit(TaskErrorState(state.tasks, "Error fetching tasks: $e"));
      return [];
    }
  }

  // Create a new task
  Future<void> addTask(TaskModel task) async {
    try {
        log("Data Inserting");
      await dbHelper.insertTask(task);
         log("Data Inserted");
      List<TaskModel> tasks = await getAllTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState(state.tasks, "Error adding task: $e"));
    }
  }

 

  // Update a task
Future<void> updateTask(TaskModel task) async {
  try {
    await dbHelper.updateTask(task);
    List<TaskModel> tasks = await getAllTasks();
    if (tasks.isNotEmpty) {
      emit(TaskLoadedState(tasks)); // Emit state with updated tasks
    } else {
      emit(TaskErrorState(state.tasks, "No tasks found after update")); // Handle empty state
    }
  } catch (e) {
    emit(TaskErrorState(state.tasks, "Error updating task: $e"));
  }
}


   // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      await dbHelper.deleteTask(id);
      List<TaskModel> tasks = await getAllTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState(state.tasks, "Error deleting task: $e"));
    }
  }



}
