import 'package:BoardApp/boardapp/login_page.dart';
import 'package:BoardApp/boardapp/util/firebasemethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key key,this.user}) : super(key : key);
  final String user;
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("user page ${widget.user}"),
         backgroundColor: Colors.deepPurpleAccent,
        elevation: 50.0,
        leading: Icon(Icons.person),
        brightness: Brightness.light,
        // actions: [
        //   IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
        //       Firebase_methods().signOut();
              
        //   },
        //   ),
        // ],
        actions: [
          FlatButton.icon(
            onPressed: (){
              Firebase_methods().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
            }, 
            icon: Icon(Icons.exit_to_app,color: Colors.white,), label: Text("Logout",style: TextStyle(color:Colors.white),)
            )
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      body: StreamBuilder(
        stream: Firestore.instance.collection("${widget.user}subject").snapshots(),
        builder: (context,snapshot)
        {
          if(!snapshot.hasData)
          {
            return Center(
              child: CircularProgressIndicator(),
            );

          }
          else{
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(snapshot.data.documents[index]['subject'],style: TextStyle(color:Colors.black),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentChapter(subject:snapshot.data.documents[index]['subject'],user:widget.user)));
                        },
                      ),
                    ],
                  ),
                );
                
              });
          }
        }),
    );
  }
}

class StudentChapter extends StatefulWidget {
  const StudentChapter({Key key,this.subject,this.user}) : super(key : key);
  final String subject;
  final String user;
  @override
  _StudentChapterState createState() => _StudentChapterState();
}

class _StudentChapterState extends State<StudentChapter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("subject ${widget.subject}${widget.user}"),
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
        stream: Firestore.instance.collection("${widget.user}${widget.subject}").snapshots(),
        builder: (context,snapshot)
        {
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
                child: Column(
                  children: [
                    ListTile(
                      title: Text(snapshot.data.documents[index]['chapter']),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentSubject(chapter:snapshot.data.documents[index]['chapter'],user:widget.user,subject:widget.subject)));
                      },
                    )
                  ],
                ),
              );
            });
        
        }),
    );
  }
}

class StudentSubject extends StatefulWidget {
  const StudentSubject({Key key,this.chapter,this.user,this.subject}): super(key : key);
  final String chapter;
  final String user;
  final String subject;
  @override
  _StudentSubjectState createState() => _StudentSubjectState();
}

class _StudentSubjectState extends State<StudentSubject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user}${widget.chapter}"),
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
        stream: Firestore.instance.collection("${widget.user}${widget.subject}chaptertopic").where('chapter', isEqualTo: "${widget.chapter}").snapshots(),
        builder: (context,snapshot)
        {
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
                child: Column(
                  children: [
                    ListTile(
                      title: Text(snapshot.data.documents[index]['topic']),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentVideoScreen(url:snapshot.data.documents[index].data['url'],)));
                      },
                    )
                  ],
                ),
              );
            });
        }),
    );
  }
}

class StudentVideoScreen extends StatefulWidget {
  const StudentVideoScreen({this.url});
  final String url;
  @override
  _StudentVideoScreenState createState() => _StudentVideoScreenState();
}

class _StudentVideoScreenState extends State<StudentVideoScreen> {
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
        elevation: 50.0,
        leading: Icon(Icons.menu),
        brightness: Brightness.dark,
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