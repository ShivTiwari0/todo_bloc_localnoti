
import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shivansh_quantum_it/logic/cubit/task_cubit.dart';
import 'package:shivansh_quantum_it/logic/cubit/task_state.dart';
import 'package:shivansh_quantum_it/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = "Splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void gotoNextScreen() {
   
  
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () => gotoNextScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) {
        gotoNextScreen();
      },
      child:  AnimatedSplashScreen(duration:10000 ,
        splash: Center(
          child: Lottie.asset(
              'assets/animated/Animation - 1722927455635.json', fit: BoxFit.fitHeight),
        ),
       nextScreen: const SizedBox(),//because CubitState is handling navigation
        
        ));
  } 
}
