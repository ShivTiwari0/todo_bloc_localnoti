import 'package:flutter/cupertino.dart';
import 'package:shivansh_quantum_it/data/model/task_model.dart';
import 'package:shivansh_quantum_it/presentation/screens/add_task_screen.dart';
import 'package:shivansh_quantum_it/presentation/screens/home_screen.dart';
import 'package:shivansh_quantum_it/presentation/screens/splash_screen.dart';

class Routes {
  static Route? onGenrateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const SplashScreen());

      case HomeScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const HomeScreen());

      case AddTaskScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => AddTaskScreen(
                 
                ));

      default:
        return null;
    }
  }
}
