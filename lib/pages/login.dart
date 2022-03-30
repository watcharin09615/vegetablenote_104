import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vegetablenote/pages/loginProfile.dart';
import 'package:vegetablenote/pages/plant.dart';
import 'package:vegetablenote/pages/registor.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ignore: non_constant_identifier_names
  final _FormKey = GlobalKey<FormState>();

  LoginProfile loginprofile = LoginProfile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Scaffold(
         body: Form(
          child: formfield(),
        ),
        );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      
    );
  }

  
  

  Widget formfield() {
    return Form(
      key: _FormKey,
      child: ListView(
          children: [
            img(),
            text('ยินดีต้อนรับสู่'),
            text('ระบบบันทึกการปลูก'),
            input(),
            inputpass(),
            login(),
            registorformbutton(),
          ],
        ),
    );
  }

  CircleAvatar img() {
    return const CircleAvatar(
      backgroundImage: AssetImage('images/logo.png'),
      radius: 120.0,
    );
  }

  Container text(a) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Text(
        a,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container registorformbutton(){
    return Container(
      child: TextButton(
        onPressed: () {
          var route = MaterialPageRoute(builder: (context) => const RegistorPage(),);
           Navigator.push(context, route);
        }, 
        child: const Text('Registor'),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 88, 182, 1)),
        ),
      ),
    );
  }

  SizedBox login(){
    return SizedBox(
      width: 130,
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 88, 182, 1)),
        ),
        onPressed: () async {  
          if (_FormKey.currentState!.validate()) {
          _FormKey.currentState!.save();
          try {
            await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                email: loginprofile.email!,
                password: loginprofile.password!
              )
              .then((value) {
              _FormKey.currentState!.reset();
              var route = MaterialPageRoute(builder: (context) => PlantPages(email: loginprofile.email!,));
              Navigator.pushReplacement(context,route);
            });
          } on FirebaseAuthException catch (e) {
            Fluttertoast.showToast(
              msg: e.message!,
              gravity: ToastGravity.CENTER);
          }
        }
        },
        child: const Text('Login'),
      ), 
    );
  }

  // Container loginwithgoogle() {
  //   return Container(
  //     padding: const EdgeInsets.all(25),
  //     child: GoogleAuthButton(
  //       onPressed: () {
  //         signInWithGoogle();
  //       },
  //       darkMode: false,
  //     ),
  //   );
  // }

  Container input() {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: TextFormField(

        validator: MultiValidator([
          RequiredValidator(errorText: "กรุณาป้อนอีเมล"),
          EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
        ]),
        keyboardType: TextInputType.emailAddress,
        onSaved: (String? email) {
          loginprofile.email = email;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),

          prefixIcon: Icon(
            Icons.account_circle,
            color: Color.fromARGB(255, 99, 206, 0),
          ),
          label: Text(
            'Email',
            style: TextStyle(color: Color.fromARGB(255, 99, 206, 0)),
          ),
        ),
      ),
    );
  }
  Container inputpass() {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: TextFormField(

        validator: MultiValidator([
          RequiredValidator(errorText: "กรุณาป้อนรหัสผ่าน"),
        ]),
        // keyboardType: TextInputType.emailAddress,
        onSaved: (String? password) {
          loginprofile.password = password;
        },
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Color.fromARGB(255, 99, 206, 0),
          ),
          label: Text(
            'password',
            style: TextStyle(color: Color.fromARGB(255, 99, 206, 0)),
          ),
        ),
      ),
    );
  }
}