import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shivansh_quantum_it/core/services/notification_services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shivansh_quantum_it/core/routes.dart';
import 'package:shivansh_quantum_it/core/ui.dart';
import 'package:shivansh_quantum_it/logic/cubit/task_cubit.dart';
import 'package:shivansh_quantum_it/presentation/screens/splash_screen.dart';





final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
   
//  handle in terminated state
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    // Future.delayed(Duration(seconds: 1), () {
    //   // print(event);
    //   navigatorKey.currentState!.pushNamed('/another',
    //       arguments: initialNotification?.notificationResponse?.payload);
    // });
  }
 
  

  final notificationService = NotificationService();
  await notificationService.init(); 

  Bloc.observer = MyBlocObserver();
  runApp(const QuantumIt());
}

class QuantumIt extends StatelessWidget {
  const QuantumIt({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskCubit(),
        ),
      
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.onGenrateRoute,
        theme: Themes.defaultTheme,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log("Created: $bloc");
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("Change in $bloc: $change");
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log("Change in $bloc: $transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase bloc) {
    log("Closed: $bloc");
    super.onClose(bloc);
  }
}
