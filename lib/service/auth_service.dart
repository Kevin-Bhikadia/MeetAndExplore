import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//  Login
  Future loginWithEmailAndPassword (String email, String password) async {

    try {

      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if (user != null) {
        return true;
      }

    } on FirebaseAuthException catch(e) {
      return e.message;
    }

  }


//  Register
  Future registerUserWithEmailAndPassword (String fullname, String email, String password) async {

    try {
      User user =   (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
      .user!;

      if (user != null) {
        // call DB service to update the user data
        await DatabaseService(uid: user.uid).savingUserData(fullname, email);
        return true;
      }

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


//  Sign out
  Future signOut () async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");

      await firebaseAuth.signOut();

    } catch (e) {
      return null;
    }
  }
}