import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swd301/api/user_api_service.dart';
import 'package:swd301/models/login_model.dart';
import 'package:swd301/models/user_model.dart';

class LoginUtils {
  static Future<UserModel> signInWithGmail(
      GoogleSignIn googleSignIn, FirebaseAuth firebaseAuth) async {
    UserModel result;
    try {
      final GoogleSignInAccount account = await googleSignIn.signIn();
      if (account != null) {
        AuthResult res = await firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: (await account.authentication).idToken,
                accessToken: (await account.authentication).accessToken));
        if (res.user != null) {
          String uid = res.user.uid;
          String gmail = res.user.email;
          var displayName = res.user.displayName.split(' ');

          String firstName = displayName[0];
          String lastName = displayName[1];
          final myService = UserApiService.create();
          final response = await myService.login(
              LoginModel(
                  email: gmail,
                  tokenGmail: uid,
                  firstName: firstName,
                  lastName: lastName),
              true);
          result = response.body;
        }
      } else {
        result = null;
      }
    } catch (e) {
      print('Error login with Google');
    }
    return result;
  }
}
