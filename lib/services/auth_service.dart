// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ultrafastsmm/services/firestore_service.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(FirebaseAuth.instance, ref),
);
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChange,
);

class AuthService {
  final FirebaseAuth _auth;
  final Ref _ref;

  AuthService(this._auth, this._ref);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('User signed in successfully.');
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');
      print('Message: ${e.message}');
      // You can return the error message to the UI here.
    } catch (e) {
      print('General Error: $e');
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String username,
  ) async {
    try {
      print('Attempting to create user with email: $email');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        print('Firebase user created: ${userCredential.user!.uid}');

        // This is the crucial part that was likely failing
        await _ref
            .read(firestoreServiceProvider)
            .createUser(userCredential.user!, username);
        print('Firestore user document created successfully.');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during sign-up: ${e.code}');
      print('Message: ${e.message}');
      // Return the error message to the UI
    } catch (e) {
      print('Firestore or other error during sign-up: $e');
      // This is where a Firestore permission error would be caught.
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
