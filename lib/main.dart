import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/provider/auth.dart';
import 'package:task_app/screens/loading_scree.dart';
import 'package:task_app/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: Auth())],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Tasker',
            home: auth.userId == ''
                ? FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) {
                      if (authResultSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return LoadingScreen();
                      }
                      return SplashScreen(
                          auth: auth.userId != '' ? true : false,
                         );
                    })
                : SplashScreen(
                    auth: auth.userId != '' ? true : false,),
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
