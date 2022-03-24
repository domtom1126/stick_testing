import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  // * This contains all stuff about current user. Name, etc.
  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _currentUser = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    notifyListeners();
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
