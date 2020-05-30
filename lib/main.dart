import 'package:BoardApp/boardapp/board_app.dart';
import 'package:BoardApp/boardapp/util/firebasemethod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'boardapp/dashboardpage.dart';
import 'boardapp/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Myhome(),
    );
  }
}

class Myhome extends StatefulWidget {
  @override
  _MyhomeState createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase_methods().getCurrentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser>snapshot){
        if(snapshot.hasData)
        {
          return DashboardPage(user: snapshot.data.uid,);
        }
        else if(snapshot.hasError)
        {
         return Center(
           child: Text("Loading......"),
         );
        }
        else{
          return LoginPage();
        }
      }
      );
  }
}