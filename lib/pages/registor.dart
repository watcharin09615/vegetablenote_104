import 'package:flutter/material.dart';
import 'package:vegetablenote/pages/login.dart';
import 'package:vegetablenote/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistorPage extends StatefulWidget {
  const RegistorPage({ Key? key }) : super(key: key);

  @override
  State<RegistorPage> createState() => _RegistorPageState();
}

class _RegistorPageState extends State<RegistorPage> {

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register by Firestore Database'),
      ),
      body: ListView(
        children: [
          txt(),
          input( _name,'name',false),
          input( _email,'email',false),
          input( _password,'password',true),
          submit(),
        ],
      ),
    );
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Future<void> addUser() {
    return users
        .add({
          'name': _name.text,
          'email': _email.text,
          'password': _password.text,
        })
        .then((value) => print("Data has been successfully"))
        .catchError((error) => print("Failed to add data: $error"));
  }

  Container txt() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: const Text(
        'Register',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }

  Container submit() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          registerWithEmail(_email.text, _password.text);
          addUser();
          siginWithEmail(_email.text, _password.text);
            var route = MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );
            Navigator.push(context, route);
        },
        child: const Text(
          "Register",
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(150, 50),
        ),
      ),
    );
  }

  Container input(a,b,c) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        controller: a,
        obscureText: c,
        decoration: InputDecoration(
          label: Text(
            'Enter your '+ b,
            style: TextStyle(color: Colors.grey[800], fontSize: 18),
          ),
          prefixIcon: const Icon(Icons.key),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.green,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}