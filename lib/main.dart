import 'package:artiluxio/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/app_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        themeMode: ThemeMode.system, // device controls theme
        home: BlocProvider(
            create: (_) => AppBloc(),
            child: BlocBuilder<AppBloc, AppBlocState>(
              builder: (context, state) {
                if (state is AppBlocInitial) {
                  return MainScreen();
                } else if (state is AppBlocModelLoaded) {
                  return const Center(child: Text('Model Loaded'));
                } else if (state is AppBlocImgSelected) {
                  return const Center(child: Text('Image Selected'));
                } else if (state is AppBlocInferenceDone) {
                  return const Center(child: Text('Inference Done'));
                } else {
                  return const Center(child: Text('Home Page'));
                }
              },
            )));
  }
}
