import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _firebaseAuth;
  String _verificationCode = "";
  int forceResendingToken;

  LoginService() : _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> getUser() async {
    var user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<bool> isSignedIn() async {
    final firebaseUser = await _firebaseAuth.currentUser();
    return firebaseUser != null;
  }

  Future<void> sendOtp(
      String phoneNumber,
      Function(AuthCredential) onVerificationCompleted,
      Function(AuthException) onVerificationFailed) async {
    await _firebaseAuth
        .verifyPhoneNumber(
            phoneNumber: "+1" + phoneNumber,
            timeout: Duration(seconds: 60),
            verificationCompleted: (authCredential) =>
                onVerificationCompleted(authCredential),
            verificationFailed: onVerificationFailed,
            codeAutoRetrievalTimeout: (verificationId) =>
                _codeAutoRetrievalTimeout(verificationId),
            codeSent: (verificationId, [code]) =>
                _smsCodeSent(verificationId, [code]))
        .catchError((error) {
      throw error;
    });
  }

  Future<void> resendOtp(
      String phoneNumber,
      Function(AuthCredential) onVerificationCompleted,
      Function(AuthException) onVerificationFailed) async {
    await _firebaseAuth
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            forceResendingToken: forceResendingToken,
            timeout: Duration(seconds: 30),
            verificationCompleted: (authCredential) =>
                onVerificationCompleted(authCredential),
            verificationFailed: onVerificationFailed,
            codeAutoRetrievalTimeout: (verificationId) =>
                _codeAutoRetrievalTimeout(verificationId),
            codeSent: (verificationId, [code]) =>
                _smsCodeSent(verificationId, [code]))
        .catchError((error) {
      throw error;
    });
  }

  void _smsCodeSent(String verificationCode, List<int> code) {
    this._verificationCode = verificationCode;
    forceResendingToken = code[0];
  }

  void _codeAutoRetrievalTimeout(String verificationCode) {
    this._verificationCode = verificationCode;
  }

  Future<FirebaseUser> signInWithSmsCode(String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          smsCode: smsCode, verificationId: _verificationCode);

      var authResult = await _firebaseAuth.signInWithCredential(credential);
      return authResult.user;
    } catch (error) {
      throw error;
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
