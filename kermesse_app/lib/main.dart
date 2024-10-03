import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kermesse_app/screens/auth/loginScreen.dart';
import 'package:kermesse_app/screens/auth/profileScreen.dart';
import 'package:kermesse_app/screens/home/homeScreen.dart';
import 'package:kermesse_app/screens/kermesse_detail/kermesse_detail.dart';
import 'package:kermesse_app/services/auth_service.dart';
import 'package:kermesse_app/services/eleve_service.dart';
import 'package:kermesse_app/services/jetons_service.dart';
import 'package:kermesse_app/services/kermesse_service.dart';
import 'package:kermesse_app/services/parent_service.dart';
import 'package:kermesse_app/services/payment_service.dart';
import 'package:kermesse_app/services/product_service.dart';
import 'package:kermesse_app/services/stand_service.dart';
import 'package:kermesse_app/services/transaction_service.dart';
import 'package:kermesse_app/services/user_service.dart';
import 'package:provider/provider.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => KermesseService()),
        ChangeNotifierProvider(create: (_) => StandService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => JetonsService()),
        ChangeNotifierProvider(create: (_) => ParentService()),
        ChangeNotifierProvider(create: (_) => EleveService()),
        ChangeNotifierProvider(create: (_) => TransactionService()),
        ChangeNotifierProvider(create: (_) => PaymentService()),
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
        Homescreen.routeName: (_)=> Homescreen(),
        ProfileScreen.routeName: (_)=> ProfileScreen(),
      },
      onGenerateRoute: (settings){
        if(settings.name == KermesseDetailsScreen.routeName){
          final int kermesseId = settings.arguments as int;
          return MaterialPageRoute(
              builder: (context){
                return KermesseDetailsScreen(kermesseId: kermesseId);
              }
          );
        }
      },
    );
  }
}