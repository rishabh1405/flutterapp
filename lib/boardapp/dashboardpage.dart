import 'package:BoardApp/boardapp/AdminPage.dart';
import 'package:BoardApp/boardapp/userpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key,this.user}) : super(key : key);
 //final FirebaseUser user;
 final String user;
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection("user").document("${widget.user}").snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError)
          {
            return Text("error : ${snapshot.error}");
          }
          else
          {
            return checkrole(snapshot.data);
          }
        }),
    );
  }
 Widget checkrole(DocumentSnapshot snapshot)
  {
    if(snapshot.data['role'] == 'admin')
    {
      return AdminPage(user:snapshot.data['role']);
    }
    else{
      return UserPage(user:snapshot.data['role']);
    }
  }
}