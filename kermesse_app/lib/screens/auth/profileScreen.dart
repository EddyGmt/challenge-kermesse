import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermesse_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class Profilescreen extends StatefulWidget{
  static const routeName = "/profile";
  const Profilescreen({super.key});

  @override
  _ProfileScreenState createState()=> _ProfileScreenState();
}

class _ProfileScreenState extends State<Profilescreen>{
  late Future<User?> _profile;

  @override
  void initState() {
    super.initState();
    _profile = Provider.of<AuthService>(context, listen: false).profile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
     /* body: FutureBuilder<User>(
        builder: (context, snapshot){

        },
      )*/
    );
  }

}