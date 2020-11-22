import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_dairy/services/database.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user;
      return user;
    } catch (e) {
      authProblems errorType;
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = authProblems.UserNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = authProblems.PasswordNotValid;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = authProblems.NetworkError;
          break;
        // ...
        default:
          print('Case ${e.message} is not yet implemented');
      }
    }
  }

  Future createAcountEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user;
      await DatabaseServices().updateUser(user.uid, "Unnamed", user.email);
      return user;
    } catch (e) {
      authProblems errorType;
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = authProblems.UserNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = authProblems.PasswordNotValid;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = authProblems.NetworkError;
          break;
        // ...
        default:
          print('Case ${e.message} is not yet implemented');
      }
    }
  }

  Future signOut() async => await _auth.signOut();

  Stream<User> get user => _auth.authStateChanges();
}
