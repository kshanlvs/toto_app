import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toto_app/auth/models/user_model.dart';
import 'package:toto_app/auth/services/token_service.dart';

import '../../widgets/loder.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  UserModel userModel = UserModel();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const [
      'email', // request email address
    ],
  );

  ValueNotifier<bool> isUserLoggedIn = ValueNotifier(false);

  void isUserSignedIn() {
    isUserLoggedIn.value = _googleSignIn.currentUser != null;
  }

  Future<String?> handleGoogleLogin() async {
  
    try {
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      userModel = UserModel(
          name: googleUser.displayName,
          email: googleUser.email,
          token: googleAuth.idToken);
      await db.collection("users").add(userModel.toJson());
      await TokenService.storeToken(googleAuth.idToken!);
      return  googleUser.email;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<bool> signOutFromGoogle() async {
    
  await _googleSignIn.signOut();
 await  TokenService.deleteToken();
  return true;
  
}
}
