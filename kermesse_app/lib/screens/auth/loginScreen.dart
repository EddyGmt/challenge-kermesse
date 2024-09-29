import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kermesse_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Password Input
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),

              // Login Button
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });

                    // Appel au service d'authentification
                    bool success = await authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    setState(() {
                      _isLoading = false;
                    });

                    if (success) {
                      // Naviguer vers une autre page après le succès de la connexion
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Connexion réussie!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Exemple: Naviguer vers une page d'accueil
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      // Gérer l'erreur de connexion
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur de connexion'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
