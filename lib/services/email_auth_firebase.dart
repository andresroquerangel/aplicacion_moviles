import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthFirebase {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> signUpUser(
      {required String name,
      required String password,
      required String email}) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        userCredential.user!.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInUser(
      {required String password, required String email}) async {
    var flag = false;
    final userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      if (userCredential.user!.emailVerified) {
        flag = true;
      }
    }
    return flag;
  }
}
