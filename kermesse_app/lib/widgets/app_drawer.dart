import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kermesse_app/screens/auth/loginScreen.dart';
import 'package:kermesse_app/screens/auth/profileScreen.dart';
import 'package:kermesse_app/screens/home/homeScreen.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late Future<User> _fetchProfile;

  @override
  void initState() {
    super.initState();
    // Différer l'accès au contexte avec Future.delayed
    Future.delayed(Duration.zero, () {
      setState(() {
        _fetchProfile = Provider.of<AuthService>(context, listen: false).profile();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context, listen: false);

    return Drawer(
      child: ListView(
        children: <Widget>[
          FutureBuilder<User>(
            future: _fetchProfile, // Utilise le Future que nous avons défini
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return DrawerHeader(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Text('Erreur: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                User currentUser = snapshot.data!;
                return DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).canvasColor,
                        Theme.of(context).canvasColor.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    currentUser.firstname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                  ),
                );
              } else {
                return const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.grey),
                  child: Text('Utilisateur non trouvé'),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, Homescreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () {
              const storage = FlutterSecureStorage();
              storage.delete(key: 'auth_token');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
