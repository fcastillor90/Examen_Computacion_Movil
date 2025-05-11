import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  final String uid;
  final String email;
  final String? displayName;

  User({
    required this.uid,
    required this.email,
    this.displayName,
  });

  factory User.fromFirebase(firebase_auth.User user) {
    return User(
      uid: user.uid,
      email: user.email ?? '', //
      displayName: user.displayName,
    );
  }
}