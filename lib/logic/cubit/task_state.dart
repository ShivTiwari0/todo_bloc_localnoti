import 'package:shivansh_quantum_it/data/model/task_model.dart';

abstract class TaskState {
  final List<TaskModel> tasks;

  TaskState(this.tasks);
}

class TaskInitialState extends TaskState {
  TaskInitialState() : super([]);
}

class TaskLoadingState extends TaskState {
  TaskLoadingState(super.tasks);
}

class TaskLoadedState extends TaskState {
  TaskLoadedState(super.tasks);
}

class TaskErrorState extends TaskState{
  final String message;
  TaskErrorState(super.tasks, this.message);
  }