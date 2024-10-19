import 'package:finstagram/model/services/service.dart';
import 'package:finstagram/views/pages/home_page.dart';
import 'package:finstagram/views/pages/login_page.dart';
import 'package:finstagram/views/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get_it/get_it.dart';




void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetIt.instance.registerSingleton<FirebaseService>(FirebaseService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F-Instagram',
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (context)=> const LoginPage(),
        'signup': (context)=> const SignupPage(),
        'home': (context)=> const HomePage()
      },
    );
  }
}
