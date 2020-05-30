import 'package:BoardApp/boardapp/login_page.dart';
import 'package:BoardApp/boardapp/util/firebasemethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AdminPage extends StatefulWidget {
  // const AdminPage({Key key,this.user}) : super(key : key);
  // final FirebaseUser user;
  const AdminPage({Key key,this.user}) : super(key : key);
  final String user;
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var firestoreDb = Firestore.instance.collection("class").snapshots();
  
  TextEditingController classInputController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classInputController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Admin page ${widget.user}"),
        actions: [
          FlatButton.icon(
            onPressed: (){
              Firebase_methods().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
            }, 
            icon: Icon(Icons.exit_to_app), label: Text("Logout")
            )
        ],
      ),
       
       floatingActionButton: FloatingActionButton(onPressed: ()
      {
        _showDialog(context);
      },
      child: Icon(Icons.add),
      ),
      backgroundColor: Colors.grey.shade400,

      body:StreamBuilder(
        stream: firestoreDb,
        builder: (context,snapshot){
          if(!snapshot.hasData)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(snapshot.data.documents[index]['class']),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ChapterScreen(classname : snapshot.data.documents[index]['class'] ) ));
                        },
                      ),
                      
                    ],
                  ),
                ),
              );
            });
        }) ,
      
    );
  }
  _showDialog(BuildContext context) async{
    await showDialog(context: context,
    child:AlertDialog(
      contentPadding: EdgeInsets.all(10),
      content: Column(
        children: [
          Text("please enter class number (i.e class11)"),
          Expanded(
            child:TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                labelText: "your name"
              ),
              controller: classInputController,
            ) 
          )
        ],
      ),
      actions: [
        FlatButton(
          onPressed: (){
            classInputController.clear();
            Navigator.pop(context);
          }, 
          child: Text("cancle"),
          ),
          FlatButton(
            onPressed: (){
              if(classInputController.text.isNotEmpty)
              {
                Firestore.instance.collection("class")
                .add({
                  "class":classInputController.text
                }).then((value) =>{
                  print(value.documentID),
                  Navigator.pop(context),
                  classInputController.clear()
                }
                ).catchError((error)=>{
                  print(error)
                });
              }
            }, 
            child:Text("save") 
            ),
      ],
    ) 
    );
  }  
}

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({Key key,this.classname}) : super(key : key);
  final String classname;
  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select ${widget.classname}"),
        actions: [
          FlatButton.icon(
            onPressed: (){
              Firebase_methods().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
            }, 
            icon: Icon(Icons.exit_to_app), label: Text("Logout")
            )
        ],
      ),
      backgroundColor: Colors.grey.shade400,
      body: StreamBuilder(
       stream: Firestore.instance.collection("${widget.classname}subject").snapshots(),

        builder: (context,snapshot){
          if(!snapshot.hasData)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index)
            {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(snapshot.data.documents[index]['subject']),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> SubjectScreen(subjectname : snapshot.data.documents[index]['subject'],classname: widget.classname ) ));
                        },
                      )
                    ],
                  ),
                ),
              );
            });
        }),
    );
  }
}

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key key,this.subjectname,this.classname}) : super(key : key);
  final String subjectname;
  final String classname;
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  TextEditingController chapterInputController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chapterInputController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.classname}${widget.subjectname}"),
        actions: [
          FlatButton.icon(
            onPressed: (){
              Firebase_methods().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
            }, 
            icon: Icon(Icons.exit_to_app), label: Text("Logout")
            )
        ]
      ),
      backgroundColor: Colors.grey.shade400,
      floatingActionButton: FloatingActionButton(onPressed: ()
      {
        _showDialog(context);
      },
      child: Icon(Icons.add),
      ),
      body:StreamBuilder(
        stream: Firestore.instance.collection("${widget.classname}${widget.subjectname}").snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(snapshot.data.documents[index]['chapter']),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> TopicScreen(subjectname : widget.subjectname,classname: widget.classname,chapter:snapshot.data.documents[index]['chapter'] , ) ));
                        },
                      )
                    ],
                  ),
                ),
              ); 
            });

        }) ,
    );
  }
  _showDialog(BuildContext context) async{
    await showDialog(context: context,
    child:AlertDialog(
      contentPadding: EdgeInsets.all(10),
      content: Column(
        children: [
          Text("please enter chapter number (i.e chapter1)"),
          Expanded(
            child:TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                labelText: "chapterNumber"
              ),
              controller: chapterInputController,
            ) 
          )
        ],
      ),
      actions: [
        FlatButton(
          onPressed: (){
            chapterInputController.clear();
            Navigator.pop(context);
          }, 
          child: Text("cancle"),
          ),
          FlatButton(
            onPressed: (){
              if(chapterInputController.text.isNotEmpty)
              {
                Firestore.instance.collection("${widget.classname}${widget.subjectname}")
                .add({
                  "chapter":chapterInputController.text.trim()
                }).then((value) =>{
                  print(value.documentID),
                  Navigator.pop(context),
                  chapterInputController.clear()
                }
                ).catchError((error)=>{
                  print(error)
                });
              }
            }, 
            child:Text("save") 
            ),
      ],
    ) 
    );
  }
}

class TopicScreen extends StatefulWidget {
  const TopicScreen({Key key,this.subjectname,this.classname,this.chapter}) : super(key : key);
  final String subjectname;
  final String classname;
  final String chapter;
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  TextEditingController topicInputController;
  TextEditingController urlInputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topicInputController = TextEditingController();
    urlInputController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topic ${widget.subjectname}${widget.classname}${widget.chapter} "),
        actions: [
          FlatButton.icon(
            onPressed: (){
              Firebase_methods().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
            }, 
            icon: Icon(Icons.exit_to_app), label: Text("Logout")
            )
        ],
      ),
      backgroundColor: Colors.grey.shade400,
       floatingActionButton: FloatingActionButton(onPressed: ()
      {
        _showDialog(context);
      },
      child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("${widget.classname}${widget.subjectname}chaptertopic").where('chapter', isEqualTo: "${widget.chapter}" ).snapshots(),
        builder: (context,snapshot)
        {
          if(!snapshot.hasData)
          {
            return Center(
              child:  CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index)
            {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(snapshot.data.documents[index]['topic'] ) ,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoScreen(url:snapshot.data.documents[index].data['url'] , ) ));
                        },
                      ),
                      IconButton(icon: Icon(Icons.delete,size: 15,color: Colors.red),
                       onPressed: ()async{
                          await Firestore.instance.collection("${widget.classname}${widget.subjectname}chaptertopic")
                          .document(snapshot.data.documents[index].documentID)
                          .delete();
                       }
                       ),
                    ],
                  ),
                ),
              );
            });
        }),
    );
  }
  _showDialog(BuildContext context) async{
    await showDialog(context: context,
    child:AlertDialog(
      contentPadding: EdgeInsets.all(10),
      content: Column(
        children: [
          Text("please enter Topic (i.e Plantation)"),
          Expanded(
            child:TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                labelText: "Topic name"
              ),
              controller: topicInputController,
            ) 
          ),
          Text("please enter url (i.e www.url.com)"),
          Expanded(
            child:TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                labelText: "Video url"
              ),
              controller: urlInputController,
            ) 
          )
        ],
      ),
      actions: [
        FlatButton(
          onPressed: (){
            topicInputController.clear();
            urlInputController.clear();
            Navigator.pop(context);
          }, 
          child: Text("cancle"),
          ),
          FlatButton(
            onPressed: (){
              if(topicInputController.text.isNotEmpty && urlInputController.text.isNotEmpty)
              {
                Firestore.instance.collection("${widget.classname}${widget.subjectname}chaptertopic")
                .add({
                  "chapter":"${widget.chapter}",
                  "topic":topicInputController.text.trim(),
                  "url":urlInputController.text.trim()
                }).then((value) =>{
                  print(value.documentID),
                  Navigator.pop(context),
                  topicInputController.clear(),
                  urlInputController.clear(),
                }
                ).catchError((error)=>{
                  print(error)
                });
              }
            }, 
            child:Text("save") 
            ),
      ],
    ) 
    );
  }
}


class VideoScreen extends StatefulWidget {
  const VideoScreen({this.url});
  final String url;
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;


  String geturl_id(String url){
    String videoIdd = YoutubePlayer.convertUrlToId(url);
    print(url);
    print(videoIdd);
    return videoIdd;
  }

  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: geturl_id(widget.url),
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
//        forceHideAnnotation: true,
        forceHD: false,
        enableCaption: true,
      ),

    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("url ${widget.url}"),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 00.0,
        actions: [
          FlatButton.icon(
            onPressed: (){
              Firebase_methods().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
            }, 
            icon: Icon(Icons.exit_to_app), label: Text("Logout")
            )
        ]
      ),
      backgroundColor: Colors.grey.shade400,
      body: ListView(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            onReady: () {
              _isPlayerReady = true;
            },
          ),
        ],
      ),
    );
  }
  


}