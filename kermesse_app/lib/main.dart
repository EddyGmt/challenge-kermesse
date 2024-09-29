import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kermesse_app/screens/auth/loginScreen.dart';
import 'package:kermesse_app/screens/auth/profileScreen.dart';
import 'package:kermesse_app/screens/home/homeScreen.dart';
import 'package:kermesse_app/services/auth_service.dart';
import 'package:provider/provider.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kermesse App',
      routes:{
        '/': (context) => LoginScreen(),
        Homescreen.routeName: (_)=> const Homescreen(),
        Profilescreen.routeName: (_)=> const Profilescreen(),
      },
    );
  }
}