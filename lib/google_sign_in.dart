import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
GoogleSignInAccount googleSignInAccount;
GoogleSignInAuthentication googleSignInAuthentication;

Future<String> signInWithGoogle() async {
  try {
    googleSignInAccount = await googleSignIn.signIn();
  } catch (error) {
    print("ERROR CAUGHT $error");
  }
  if (googleSignInAccount != null)
    googleSignInAuthentication = await googleSignInAccount.authentication;
  else {
    print("CANCELLED");
    return "cancelled";
  }

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult user = (await _auth.signInWithCredential(credential));
  print(
      "Details ARE HERE $user ${user.user.getIdToken()} ${user.user.email} ${user.user.displayName}");

  assert(!user.user.isAnonymous);
  assert(await user.user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.user.uid == currentUser.uid);

  return 'success';
}

void signOutGoogle(BuildContext context) async {
  await googleSignIn.signOut();
  await _auth.signOut();
  Navigator.popUntil(context, ModalRoute.withName('/'));
  print("User Sign Out");
}
