import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// --- Events ---
abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class SignInWithGooglePressed extends AuthEvent {}

class SignOutPressed extends AuthEvent {}

// --- States ---
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

// --- BLoC Implementation ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance; // v7.0.0+ Singleton
  AuthBloc() : super(AuthInitial()) {
    // 1. Initial login check
    on<AuthCheckRequested>((event, emit) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
    // 2. Google Sign-In handler
    on<SignInWithGooglePressed>((event, emit) async {
      emit(AuthLoading());
      try {
        // Trigger OS Google sign-in prompt
        final GoogleSignInAccount googleUser = await _googleSignIn
            .authenticate();
        // Retrieve credentials (synchronous in google_sign_in v7.0.0+)
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;
        // Create Firebase credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        // Sign into Firebase
        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);

        if (userCredential.user != null) {
          emit(Authenticated(userCredential.user!));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
    // 3. Logout handler
    on<SignOutPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        await _googleSignIn.signOut();
        await _firebaseAuth.signOut();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
