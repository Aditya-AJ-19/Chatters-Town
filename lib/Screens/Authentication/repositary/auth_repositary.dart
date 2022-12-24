import 'package:chatters_town/Models/user_model.dart';
import 'package:chatters_town/Screens/main_home_screen.dart';
import 'package:chatters_town/Utlis/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  String uid = '';

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  void signinWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => {
                if (auth.currentUser != null)
                  {
                    Navigator.pushNamed(context, MainHomeScreen.routeName),
                  },
              });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void creatNewUser(BuildContext context, String email, String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => {
                uid = auth.currentUser!.uid,
              });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserInfoToFireBase(BuildContext context, UserModel userinfo) async {
    try {
      await firestore
          .collection('Users')
          .doc(uid)
          .set(userinfo.toMap())
          .whenComplete(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainHomeScreen(),
          ),
          (route) => false,
        );
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<bool> usernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  Future readUser() {
    return firestore.collection('Users').doc(auth.currentUser!.uid).get();
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('Users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('Users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
