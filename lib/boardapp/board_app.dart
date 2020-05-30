import 'package:BoardApp/boardapp/ui/customcard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardApp extends StatefulWidget {
  const BoardApp({Key key,this.user}) : super(key : key);
  final FirebaseUser user;
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firestoreDb =Firestore.instance.collection("board").snapshots();
  TextEditingController nameInputController;
  TextEditingController titleInputController;
  TextEditingController descriptionInputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("community app ${widget.user.email}"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()
      {
        _showDialog(context);
      },
      child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: firestoreDb,
        builder: (context,snapshot){
          if(!snapshot.hasData)
          {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,int index){
              return CustomCard(snapshot:snapshot.data, index:index);
             // return Text(snapshot.data.documents[index]['title']);
            }
            );
        }
        ),
    );
  }
  _showDialog(BuildContext context) async{
    await showDialog(context: context,
    child:AlertDialog(
      contentPadding: EdgeInsets.all(10),
      content: Column(
        children: [
          Text("please fill out the form"),
          Expanded(
            child:TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                labelText: "your name*"
              ),
              controller: nameInputController,
            ) 
          ),
          Expanded(
            child:TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                labelText: "your title*"
              ),
              controller: titleInputController,
            ) 
          ),
          Expanded(
            child:TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                labelText: "description*"
              ),
              controller: descriptionInputController,
            ) 
          )
        ],
      ),
      actions: [
        FlatButton(
         onPressed: (){
           nameInputController.clear();
           titleInputController.clear();
           descriptionInputController.clear();
           Navigator.pop(context);
         },
         child: Text("cancle")
         ),
         FlatButton(
         onPressed: (){
           if(nameInputController.text.isNotEmpty &&
             titleInputController.text.isNotEmpty &&
             descriptionInputController.text.isNotEmpty)
             {
               Firestore.instance.collection("board")
               .add({
                 "name":nameInputController.text,
                 "title":titleInputController.text,
                 "description":descriptionInputController.text,
                 "timestamp":new DateTime.now()
               }).then((response) =>{ 
                 print(response.documentID),
                 Navigator.pop(context),
                 nameInputController.clear(),
                 titleInputController.clear(),
                 descriptionInputController.clear(),

               }
               ).catchError((error)=>{
                 print(error)
               });
             }
         }, 
         child:Text("Save")
         ),
      ],
    )
    );
  }
}