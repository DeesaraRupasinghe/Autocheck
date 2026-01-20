import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

/// Authentication service for Firebase Auth with Google Sign-In
class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Sign in with Google OAuth2
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResult.cancelled();
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return AuthResult.error('Failed to sign in with Google');
      }

      // Check if user exists in Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // New user - needs registration
        return AuthResult.newUser(user);
      }

      // Existing user - update last login
      await _firestore.collection('users').doc(user.uid).update({
        'lastLoginAt': DateTime.now().toIso8601String(),
      });

      final firestoreUser = FirestoreUser.fromFirestore(userDoc.data()!);
      return AuthResult.success(user, firestoreUser);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('An unexpected error occurred: $e');
    }
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return AuthResult.error('Failed to sign in');
      }

      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return AuthResult.error('User profile not found');
      }

      // Update last login
      await _firestore.collection('users').doc(user.uid).update({
        'lastLoginAt': DateTime.now().toIso8601String(),
      });

      final firestoreUser = FirestoreUser.fromFirestore(userDoc.data()!);
      return AuthResult.success(user, firestoreUser);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('An unexpected error occurred: $e');
    }
  }

  /// Create account with email and password
  Future<AuthResult> createAccountWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return AuthResult.error('Failed to create account');
      }

      return AuthResult.newUser(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('An unexpected error occurred: $e');
    }
  }

  /// Complete user registration (normal user)
  Future<AuthResult> completeUserRegistration({
    required String uid,
    required String displayName,
    required String email,
    required String phoneNumber,
    required String preferredLanguage,
  }) async {
    try {
      final user = FirestoreUser(
        uid: uid,
        displayName: displayName,
        email: email,
        phoneNumber: phoneNumber,
        role: UserRole.normalUser,
        preferredLanguage: preferredLanguage,
        isEmailVerified: _auth.currentUser?.emailVerified ?? false,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(user.toFirestore());

      return AuthResult.success(_auth.currentUser!, user);
    } catch (e) {
      return AuthResult.error('Failed to complete registration: $e');
    }
  }

  /// Complete inspector registration
  Future<AuthResult> completeInspectorRegistration({
    required String uid,
    required String displayName,
    required String email,
    required InspectorProfile inspectorProfile,
    required String preferredLanguage,
  }) async {
    try {
      // Create user document
      final user = FirestoreUser(
        uid: uid,
        displayName: displayName,
        email: email,
        phoneNumber: inspectorProfile.phoneNumber,
        role: UserRole.inspectionService,
        preferredLanguage: preferredLanguage,
        isEmailVerified: _auth.currentUser?.emailVerified ?? false,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Create user and inspector profile in transaction
      await _firestore.runTransaction((transaction) async {
        transaction.set(
          _firestore.collection('users').doc(uid),
          user.toFirestore(),
        );
        transaction.set(
          _firestore.collection('inspectors').doc(inspectorProfile.id),
          inspectorProfile.toFirestore(),
        );
      });

      return AuthResult.success(_auth.currentUser!, user);
    } catch (e) {
      return AuthResult.error('Failed to complete registration: $e');
    }
  }

  /// Get user data from Firestore
  Future<FirestoreUser?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return FirestoreUser.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get inspector profile
  Future<InspectorProfile?> getInspectorProfile(String userId) async {
    try {
      final query = await _firestore
          .collection('inspectors')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return InspectorProfile.fromFirestore(query.docs.first.data());
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.passwordResetSent();
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Failed to send password reset email');
    }
  }

  /// Get friendly error message
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'An error occurred. Please try again';
    }
  }
}

/// Result of authentication operations
class AuthResult {
  final AuthStatus status;
  final User? user;
  final FirestoreUser? firestoreUser;
  final String? errorMessage;

  const AuthResult._({
    required this.status,
    this.user,
    this.firestoreUser,
    this.errorMessage,
  });

  factory AuthResult.success(User user, FirestoreUser firestoreUser) {
    return AuthResult._(
      status: AuthStatus.success,
      user: user,
      firestoreUser: firestoreUser,
    );
  }

  factory AuthResult.newUser(User user) {
    return AuthResult._(
      status: AuthStatus.newUser,
      user: user,
    );
  }

  factory AuthResult.cancelled() {
    return const AuthResult._(status: AuthStatus.cancelled);
  }

  factory AuthResult.error(String message) {
    return AuthResult._(
      status: AuthStatus.error,
      errorMessage: message,
    );
  }

  factory AuthResult.passwordResetSent() {
    return const AuthResult._(status: AuthStatus.passwordResetSent);
  }

  bool get isSuccess => status == AuthStatus.success;
  bool get isNewUser => status == AuthStatus.newUser;
  bool get isError => status == AuthStatus.error;
  bool get isCancelled => status == AuthStatus.cancelled;
}

enum AuthStatus {
  success,
  newUser,
  cancelled,
  error,
  passwordResetSent,
}
