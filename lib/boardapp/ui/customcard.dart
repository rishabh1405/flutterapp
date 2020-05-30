

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  const CustomCard({Key key,this.snapshot,this.index}) :super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var docId = snapshot.documents[index].documentID;
    var snapshotData = snapshot.documents[index].data;
  TextEditingController nameInputController = TextEditingController(text: snapshotData["name"]);
   TextEditingController titleInputController = TextEditingController(text: snapshotData["title"]);
  TextEditingController descriptionInputController = TextEditingController(text:snapshotData["description"]);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 250,
            child: Card(
              elevation: 10,
                child: ListTile(
                title: Text(snapshot.documents[index].data["title"]),
                subtitle: Text(snapshot.documents[index].data["description"]),
                leading: CircleAvatar(
                  radius: 34,
                  child: Text(snapshot.documents[index].data["title"][0]),
                ),
              ),
              
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(icon: Icon(Icons.edit,size: 15,), onPressed: ()async{
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
          ),
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
         FlatButton(onPressed: (){
           Firestore.instance.collection("board")
           .document(docId)
           .updateData({
             "name":nameInputController.text,
                 "title":titleInputController.text,
                 "description":descriptionInputController.text,
                 "timestamp":new DateTime.now()
           }).then((response) =>{ 
                 Navigator.pop(context),
                 nameInputController.clear(),
                 titleInputController.clear(),
                 descriptionInputController.clear(),

               }
               ).catchError((error)=>{
                 print(error)
               });
         }, 
         child: Text("update"))
              ],
                ) 
                );

              }),
              IconButton(icon: Icon(Icons.delete,size: 15,), onPressed: ()async{
                print(docId);
               await Firestore.instance.collection("board")
                .document(docId)
                .delete();
              })
            ],
          )
        ],
      ),

    );
  }
}