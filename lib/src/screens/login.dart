import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_final/src/model/user.dart';
import 'package:flutter_application_final/src/screens/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password, _name = "";
  final auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  Future<void> asyncMethod() async {
    await intenthome();
  }

  intenthome() async {
    if (auth.currentUser != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => HomeScreen())));
    } else {
      print("object nullllllllllllllllllllllll");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        width: double.infinity,
        //margin: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        //  constraints: BoxConstraints(maxWidth: 100),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                setState(() {
                  _name = value.trim();
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).accentColor,
                    child: Text('Signin'),
                    onPressed: () {
                      auth.signInWithEmailAndPassword(
                          email: _email, password: _password);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => HomeScreen())));
                    }),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).accentColor,
                    child: Text('Signup'),
                    onPressed: () async {
                      auth
                          .createUserWithEmailAndPassword(
                              email: _email, password: _password)
                          .whenComplete(() {
                        String? id =
                            auth.currentUser?.uid.toLowerCase().toString();
                        print("idddddddddddd$id");
                        Person p =
                            new Person(id: id, name: _name, email: _email);

                        users.doc(id).set(p.toFirestore());
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => HomeScreen())));
                      });
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
