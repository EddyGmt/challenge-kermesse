import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kermesse_app/screens/admin/productsScreen.dart';
import 'package:kermesse_app/screens/admin/standsScreen.dart';
import 'package:kermesse_app/screens/admin/usersScreen.dart';
import 'package:kermesse_app/screens/auth/loginScreen.dart';
import 'package:kermesse_app/screens/auth/profileScreen.dart';
import 'package:kermesse_app/screens/home/homeScreen.dart';
import 'package:kermesse_app/screens/jetons/jetons-screen.dart';
import 'package:kermesse_app/screens/kermesse_detail/kermesse_detail.dart';
import 'package:kermesse_app/screens/stand_details/standDetailsScreen.dart';
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
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  await Stripe.instance.applySettings();


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
        JetonsScreen.routeName: (_)=>JetonsScreen(),
        UsersScreen.routeName: (_)=> UsersScreen(),
        ProductsScreen.routeName: (_)=>ProductsScreen(),
        StandsScreen.routeName: (_)=>StandsScreen()
      },
      onGenerateRoute: (settings){
        if(settings.name == KermesseDetailsScreen.routeName){
          final int kermesseId = settings.arguments as int;
          return MaterialPageRoute(
              builder: (context){
                return KermesseDetailsScreen(kermesseId: kermesseId);
              }
          );
        }else if(settings.name == StandDetailsScreen.routeName){
          final int standId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return StandDetailsScreen(standId: standId);
            },
          );
        }
      },
    );
  }
}