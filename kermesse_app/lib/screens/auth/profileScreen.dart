import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermesse_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _fetchProfile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Utiliser didChangeDependencies pour accéder au Provider
    _fetchProfile = Provider.of<AuthService>(context).profile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil Utilisateur')),
      body: FutureBuilder<User>(
        future: _fetchProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            User profileData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Ajoute l'image du profil ici
                  CircleAvatar(
                    radius: 50,
                  ),
                  Text('Bonjour, ${profileData.firstname} ${profileData.lastname}'),
                ],
              ),
            );
          } else {
            return Center(child: Text('Aucune donnée utilisateur disponible.'));
          }
        },
      ),
    );
  }
}
