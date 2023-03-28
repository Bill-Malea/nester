import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nester/login.dart';
import 'package:nester/providers/AttendenceProvider.dart';
import 'package:nester/providers/BottomNavProvider.dart';
import 'package:nester/providers/EmployeProvider.dart';
import 'package:nester/providers/ResignProvider.dart';
import 'package:provider/provider.dart';

import 'Screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MultiProvider(
    key: ObjectKey(DateTime.now().toString()),
    providers: [
      ChangeNotifierProvider(
        create: (context) => BottomNavProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => EmployeeService(),
      ),
      ChangeNotifierProvider(
        create: (context) => AttendanceService(),
      ),
       ChangeNotifierProvider(
        create: (context) => AttendanceService(),
      ), ChangeNotifierProvider(
        create: (context) => ResignService(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nester',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(background: Colors.white)
                .copyWith(secondary: const Color(0xFF3a424d))
                .copyWith(primary: const Color(0xFF58bee6))),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (userSnapshot.hasData) {
              return const MyHomePage(
                title: 'Nester',
              );
            }
            return const LoginPage();
          },
        ));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 1),
    );
  }
}
