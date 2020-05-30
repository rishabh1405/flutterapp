import 'package:firebase_auth/firebase_auth.dart';

class Firebase_methods{
  Future <FirebaseUser> getCurrentUser()async{
    FirebaseUser currentUser;
    currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

 

  Future<void> signOut() async{
    try{
     FirebaseUser user =  await FirebaseAuth.instance.signOut() as FirebaseUser;
    }
    catch(e)
    {
      print(e.toString());
    }
  }
}