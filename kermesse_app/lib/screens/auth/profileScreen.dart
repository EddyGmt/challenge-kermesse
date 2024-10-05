import 'package:flutter/material.dart';
import 'package:kermesse_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../models/kermesse.dart';
import '../../models/stand.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _fetchProfile;

  // Controllers pour les champs éditables
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Charger le profil avec le Provider
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

            // Initialiser les valeurs des contrôleurs
            _firstnameController.text = profileData.firstname;
            _lastnameController.text = profileData.lastname;
            _emailController.text = profileData.email;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Affichage de l'avatar utilisateur
                  Center(
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(profileData.picture),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Champs éditables pour le profil
                  _buildTextField("Prénom", _firstnameController),
                  _buildTextField("Nom", _lastnameController),
                  _buildTextField("Email", _emailController),

                  SizedBox(height: 20),

                  // Bouton d'édition/enregistrement
                  _isEditing
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                            _saveProfileChanges();
                          },
                          child: Text('Enregistrer les modifications'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                          child: Text('Modifier le profil'),
                        ),
                  SizedBox(height: 20),

                  // Affichage des listes
                  _buildSectionTitle('Kermesses'),
                  _buildKermesseList(profileData.kermesses ?? []),

                  _buildSectionTitle('Stands'),
                  _buildStandList(profileData.stands ?? []),

                  _buildSectionTitle('Parents'),
                  _buildUserList(profileData.parents ?? []),

                  _buildSectionTitle('Enfants'),
                  _buildUserList(profileData.enfants ?? []),
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

  // Fonction pour construire les champs de texte
  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing, // Active ou désactive l'édition
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Fonction pour afficher les sections (titres)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Fonction pour afficher la liste des Kermesses
  Widget _buildKermesseList(List<Kermesse> kermesses) {
    if (kermesses.isEmpty) {
      return Text('Aucune kermesse.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: kermesses.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(kermesses[index].name),
          subtitle: Text('ID: ${kermesses[index].id}'),
        );
      },
    );
  }

  // Fonction pour afficher la liste des Stands
  Widget _buildStandList(List<Stand> stands) {
    if (stands.isEmpty) {
      return Text('Aucun stand.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: stands.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(stands[index].name),
          subtitle: Text('Type: ${stands[index].type}'),
        );
      },
    );
  }

  // Fonction pour afficher la liste des utilisateurs (Parents ou Enfants)
  Widget _buildUserList(List<User> users) {
    if (users.isEmpty) {
      return Text('Aucun utilisateur.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${users[index].firstname} ${users[index].lastname}'),
          subtitle: Text('Email: ${users[index].email}'),
        );
      },
    );
  }

  // Fonction pour enregistrer les modifications
  void _saveProfileChanges() {
    // Appeler la méthode d'enregistrement des modifications ici
    // Tu peux envoyer les données modifiées vers l'API
    print("Prénom: ${_firstnameController.text}");
    print("Nom: ${_lastnameController.text}");
    print("Email: ${_emailController.text}");
  }
}
