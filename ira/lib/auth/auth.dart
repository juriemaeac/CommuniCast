import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ira/home.dart';
import 'package:ira/auth/login.dart';
import 'package:ira/auth/snackbar.dart';
import 'package:ira/database/database.dart';
import 'package:ira/navBar.dart';
import 'package:page_transition/page_transition.dart';

class FirebaseAuthMethods {
  final DateTime timestamp = DateTime.now();
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  //State
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  //EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 800),
          child: const LoginPage(),
        ),
      );
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.updateDisplayName(username);
      await sendEmailVerification(context);
      Map<String, dynamic> userInfoMap = {
        "userID": _auth.currentUser!.uid,
        "username": username,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "timestamp": timestamp,
      };

      if (UserCredential != null) {
        DatabaseMethods().addUserInfoToDB(_auth.currentUser!.uid, userInfoMap);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Navigator.pop(context, false);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.pop(context, false);
      } else if (e.code == 'invalid-email') {
        print('The email is invalid.');
        Navigator.pop(context, false);
      } else {}

      showSnackBar(context, e.message!);
      print(e);
    }
  }

  //EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!_auth.currentUser!.emailVerified) {
        _auth.currentUser!.sendEmailVerification();
        showSnackBar(
            context, 'Account is not verified. Email Verification Sent');
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 800),
                child: const LoginPage()));
      } else {
        showSnackBar(context, 'Account is verified. Login Successful');
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 800),
                child: NavBar()));
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      print(e);
    }
  }

  //EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email Verification Sent');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      print(e);
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      showSnackBar(context, 'Successfully Signed Out');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackBar(context, 'Password Reset Email Sent');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }
}
