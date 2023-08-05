import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lamusic/features/home/presentation/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../confg/cacheHelper.dart';
import '../../../../data/models/create_users.dart';

class MusicProvider with ChangeNotifier {



  SocialCreateUserModel? socialCreateUserModel;

  // Future signInWithGoogle() async {
  //   final GoogleSignInAccount? googleSignInAccount =
  //   await GoogleSignIn().signIn();
  //
  //   if (googleSignInAccount != null) {
  //     // executing our authentication
  //     try {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );
  //
  //       // signing to firebase user instance
  //       final User userDetails =
  //       (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  //
  //       // now save all values
  //       socialCreateUserModel=SocialCreateUserModel(
  //         email: userDetails.email,
  //         name:  userDetails.displayName,
  //         uid:  userDetails.uid, password: '',
  //       );
  //       notifyListeners();
  //     } on FirebaseAuthException catch (e) {
  //       switch (e.code) {
  //         case "account-exists-with-different-credential":
  //           _errorCode =
  //           "You already have an account with us. Use correct provider";
  //           _hasError = true;
  //           notifyListeners();
  //           break;
  //
  //         case "null":
  //           _errorCode = "Some unexpected error while trying to sign in";
  //           _hasError = true;
  //           notifyListeners();
  //           break;
  //         default:
  //           _errorCode = e.toString();
  //           _hasError = true;
  //           notifyListeners();
  //       }
  //     }
  //   } else {
  //     _hasError = true;
  //     notifyListeners();
  //   }
  // }
  // Future handleGoogleSignIn() async {
  //   final sp = context.read<SignInProvider>();
  //   final ip = context.read<InternetProvider>();
  //   await ip.checkInternetConnection();
  //
  //   if (ip.hasInternet == false) {
  //     openSnackbar(context, "Check your Internet connection", Colors.red);
  //     googleController.reset();
  //   } else {
  //     await sp.signInWithGoogle().then((value) {
  //       if (sp.hasError == true) {
  //         openSnackbar(context, sp.errorCode.toString(), Colors.red);
  //         googleController.reset();
  //       } else {
  //         // checking whether user exists or not
  //         sp.checkUserExists().then((value) async {
  //           if (value == true) {
  //             // user exists
  //             await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
  //                 .saveDataToSharedPreferences()
  //                 .then((value) => sp.setSignIn().then((value) {
  //               googleController.success();
  //               handleAfterSignIn();
  //             })));
  //           } else {
  //             // user does not exist
  //             sp.saveDataToFirestore().then((value) => sp
  //                 .then((value) => sp.setSignIn().then((value) {
  //               googleController.success();
  //               handleAfterSignIn();
  //             })));
  //           }
  //         });
  //       }
  //     });
  //   }
  // }
  //
  //



  void openSnackbar(context, snackMessage, color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        action: SnackBarAction(
          label: "OK",
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Text(
          snackMessage,
          style: const TextStyle(fontSize: 14),
        )));
  }


  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  //hasError, errorCode, provider,uid, email, name, imageUrl
  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;


  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;




  MusicProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance
        final User userDetails =
        (await firebaseAuth.signInWithCredential(credential)).user!;

        // now save all values
        _name = userDetails.displayName;
        _email = userDetails.email;
        _uid = userDetails.uid;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
            "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }


  // ENTRY FOR CLOUDFIRESTORE
  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
      _uid = snapshot['uid'],
      _name = snapshot['name'],
      _email = snapshot['email'],
    });
  }

  Future saveDataToFirestore() async {
    final DocumentReference r =
    FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    notifyListeners();
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _uid = s.getString('uid');
    notifyListeners();
  }

  // checkUser exists or not in cloudfirestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
    await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      print("EXISTING USER");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  void phoneNumberUser(User user, email, name) {
    _name = name;
    _email = email;
    _uid = user.phoneNumber;
    notifyListeners();
  }

























  void userLogin({
    required String email,
    required String password,
    context
  }){
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      CacheHelper.savedData(key: "token", value: true);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      notifyListeners();
    }).catchError((error){
      notifyListeners();
    });
  }




  void createUser({
    required String name,
    required String email,
    required String password,

    required String uid,
  }){
   socialCreateUserModel=SocialCreateUserModel(
      email: email,
      name: name,
      password: password,
      uid: uid,
    );

    FirebaseFirestore.instance.collection('users').doc(uid).set(
        socialCreateUserModel!.toMap()
    ).then((value) {
      notifyListeners();
    }).catchError((error){
      print(error.toString());
      notifyListeners();
    });



  }
  void userRegister({
    required String name,
    required String email,
    required String password,
    context
  })
  {
    notifyListeners();
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      createUser(
        email: email,
        uid: value.user!.uid,
        password: password,
        name: name,
      );
      CacheHelper.savedData(key: "token", value: true);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));

    }).catchError((error){
      print(error.toString());
      notifyListeners();
    });
  }



}







