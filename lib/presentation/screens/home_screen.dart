import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shivansh_quantum_it/core/services/notification_services.dart';
import 'package:shivansh_quantum_it/core/ui.dart';
import 'package:shivansh_quantum_it/data/model/task_model.dart';
import 'package:shivansh_quantum_it/logic/cubit/task_cubit.dart';
import 'package:shivansh_quantum_it/logic/cubit/task_state.dart';
import 'package:shivansh_quantum_it/presentation/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static const routeName = 'home';
}

enum SortOption { priority, dueDate }

class _HomeScreenState extends State<HomeScreen> {
 TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
   @override
  void initState() {
  
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  // Function to filter tasks by title
  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    if (_searchQuery.isEmpty) {
      return tasks;
    } else {
      return tasks
          .where((task) => task.title.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }


  SortOption _selectedSort = SortOption.priority;

  void _sortTasks(List<TaskModel> tasks) {
    switch (_selectedSort) {
      case SortOption.priority:
        tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortOption.dueDate:
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      floatingActionButton: Container(
          width: 56.0, // Size of the circular button
          height: 56.0, // Size of the circular button
          decoration: BoxDecoration(
            color: AppColors.accent, // Your accent color here
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () async {
              List<TaskModel> task =
                  await BlocProvider.of<TaskCubit>(context).getAllTasks();
              Navigator.pushNamed(context, AddTaskScreen.routeName,
                  arguments: task);
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      appBar: AppBar(toolbarHeight:80   ,
        centerTitle: true,
        title:Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search tasks by title...",
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        actions: [
          DropdownButton<SortOption>(
          value: _selectedSort,
          icon:  Icon(Icons.sort, color: AppColors.accent),
          underline: Container(), // Remove the default underline
          dropdownColor: Colors.white, // Background color of the dropdown
          items: [
            DropdownMenuItem(
              value: SortOption.priority,
              child: Text(
                'By Priority',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
            DropdownMenuItem(
              value: SortOption.dueDate,
              child: Text(
                'Due Date',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
          ],
          onChanged: (SortOption? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSort = newValue;
              });
            }
          },
        ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskInitialState && state.tasks.isEmpty) {
            return const Center(child: Text("No data Found"));
          }
          if (state is TaskLoadingState && state.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskLoadedState && state.tasks.isEmpty) {
            return Center(
                child: Text(
              "No data Found",
              style: TextStyles.heading2,
            ));
          }

       
          List<TaskModel> tasks = _filterTasks(state.tasks);
          _sortTasks(tasks); 

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dismissible(
                  key: ValueKey<int>(tasks.length),
                  onDismissed: (direction) {
                    BlocProvider.of<TaskCubit>(context).deleteTask(task.id!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen(task: task, isUpdate: true,),));} ,
                      trailing: Text(
                        task.priority.toString().split('.').last.toUpperCase(),
                        style: TextStyles.body2.copyWith(
                          color: () {
                            switch (task.priority) {
                              case TaskPriority.immediate:
                                return const Color.fromARGB(255, 255, 63, 50);
                              case TaskPriority.high:
                                return Colors.orange;
                              case TaskPriority.medium:
                                return AppColors.accent;
                              case TaskPriority.low:
                                return Colors.green;
                              default:
                                return Colors.black; // Default color
                            }
                          }(),
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyles.heading3
                            .copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        task.description,
                        style: TextStyles.body2
                            .copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
