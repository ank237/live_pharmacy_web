import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  String _phoneNumber;
  String _verificationId;
  String _smsCode;
  String _message;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get phoneNumber1 => _phoneNumber;
  String get verificationId => _verificationId;
  String get smsCode => _smsCode;
  String get message => _message;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    print(phoneNumber);
    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      print('User Auto Logged In');
      // UserCredential _userCredential =
      //     await _auth.signInWithCredential(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) async {
      print('Auth Exception Occured');
      // throw Exception(authException.message);
      // _message =
      //     'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
    };

    PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      print('SMS Sent');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) async {
      print('SMS Auto Retrieval Timeout');
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    final User user = (await _auth.signInWithCredential(credential)).user;
  }
}
