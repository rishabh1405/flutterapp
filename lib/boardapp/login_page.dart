

import 'package:BoardApp/boardapp/AdminPage.dart';
import 'package:BoardApp/boardapp/board_app.dart';
import 'package:BoardApp/boardapp/dashboardpage.dart';
import 'package:BoardApp/boardapp/userpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email,_password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Login in"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.grey.shade400,
      body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 50,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: Image.asset('./assets/abd.jpeg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                )
              ),
              SizedBox(height: 20.0,),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(width: 1.0,color:Colors.black),
                    color: Colors.white60
                  ),
                  child: TextFormField(
                    validator: (input){
                      if(input.isEmpty)
                      {
                        return "please type email";
                      }
                    },
                    onSaved: (input)=> _email = input.trim(), 
                    decoration: InputDecoration(
                      labelText: "Email",
                      
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(width: 1.0,color:Colors.black),
                    color: Colors.white60
                  ),

                  child: TextFormField(
                    validator: (input){
                      if(input.isEmpty)
                      {
                        return "please type password";
                      }
                    },
                    onSaved: (input)=> _password = input.trim(),
                    decoration: InputDecoration(
                      labelText: "Password",
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0), 
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: 
                    (){
                      signIn();
                    },
                    child: Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                    ),),
                )
            ],
          )
        ),
              ),
      ),
    );
  }
 Future<void> signIn() async{
    final formstate = _formKey.currentState;
    if(formstate.validate())
    {
      formstate.save();
      try{

         FirebaseUser user =  (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        // var firestoreDb =await Firestore.instance.collection("/user").document(user.uid).snapshots();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DashboardPage(user:user.uid)));
                  
      }catch(e){
        print(e);
      }
    }
  }
}