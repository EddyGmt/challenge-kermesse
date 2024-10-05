import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kermesse_app/screens/auth/loginScreen.dart';
import 'package:kermesse_app/screens/auth/profileScreen.dart';
import 'package:kermesse_app/screens/home/homeScreen.dart';
import 'package:kermesse_app/screens/jetons/jetons-screen.dart';
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
                return GestureDetector(
                  onTap: () {
                    // Naviguer vers le profil lorsque l'utilisateur clique sur le header
                    Navigator.pushNamed(context, ProfileScreen.routeName);
                  },
                  child: DrawerHeader(
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
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40, // Ajuste la taille de l'avatar
                          backgroundImage: NetworkImage(currentUser.picture),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${currentUser.firstname} ${currentUser.lastname}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
            leading: const Icon(Icons.generating_tokens_rounded),
            title: Text('Acheter des jetons'),
            onTap: () {
              Navigator.pushNamed(context, JetonsScreen.routeName);
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
