import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kermesse_app/screens/auth/loginScreen.dart';
import 'package:kermesse_app/screens/auth/profileScreen.dart';
import 'package:kermesse_app/screens/home/homeScreen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatefulWidget{
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>{
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    int? userRole = authService.getUserRole();

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
              ),
            child: Text(
              'KERMESSE ESGI',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Home'),
            onTap: (){
              Navigator.pushNamed(context, Homescreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: (){
              Navigator.pushNamed(context, Profilescreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnection'),
            onTap: (){
              const storage = FlutterSecureStorage();
              storage.delete(key: 'auth_token');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const LoginScreen()
                  )
              );
            },
          ),
        ],
      ),
    );
  }

}