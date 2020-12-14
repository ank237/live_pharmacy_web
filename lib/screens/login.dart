import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/userModel.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _otp = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _number = TextEditingController();
  String phoneNumber = '';
  final _form = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  int forceResendingTokenValue;
  String verificationIdValue;
  String pinEntered;
  bool _showVerify = false;
  bool _isSaving = false;
  ConfirmationResult confirmationResult ;




  Future<void> loginUser(String phone, BuildContext context) async {
    confirmationResult = await _auth.signInWithPhoneNumber(phone, RecaptchaVerifier(
      onSuccess: () => print('reCAPTCHA Completed!'),
      onError: (FirebaseAuthException error) => print(error),
      onExpired: () => print('reCAPTCHA Expired!'),
    )).whenComplete(() => {});
//    await _auth.verifyPhoneNumber(
//      phoneNumber: phone,
//      timeout: Duration(seconds: 60),
//      verificationCompleted: (AuthCredential credential) async {
//        await _auth.signInWithCredential(credential);
//        if (_auth.currentUser != null) {
//          //Navigator.pushNamed(context, "home");
//          registerNewUser();
//        } else {
//          print("Error occured");
//          Fluttertoast.showToast(msg: 'Something went wrong, Try again!');
//        }
//      },
//      verificationFailed: (FirebaseAuthException exception) {
//        print(exception.message);
//        print("verification failed");
//        Fluttertoast.showToast(msg: 'Invalid OTP');
//      },
//      codeSent: (String verificationID, [int forceResendingToken]) async {
//        setState(() {
//          forceResendingTokenValue = forceResendingToken;
//          verificationIdValue = verificationID;
//        });
//      },
//      codeAutoRetrievalTimeout: (String verificationId) {},
//    );
  }



  void codeSentFunction(String verificationID) async {
    final code = _otp.text.trim();
    UserCredential userCredential = await confirmationResult.confirm(code).whenComplete(() => {
    });
    await _auth.signInWithCredential(userCredential.credential).whenComplete(() => {
    if (_auth.currentUser != null) {
        registerNewUser()
    }
    else {
    print("Error")
    }
    });

//    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: code);


  }

  void registerNewUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_auth.currentUser != null) {
      userProvider.newUser = UserModel(
        name: _name.value.text,
        phone: phoneNumber,
        role: userProvider.selectedRole,
        isVerified: false,
      );
      await userProvider.registerNewUser();
    }
    if (userProvider.loggedInUser.isVerified) {
      if (userProvider.loggedInUser.role == 'agent') {
        Navigator.pushNamed(context, 'deliveries');
      } else {
        Navigator.pushNamed(context, 'home');
      }
    } else {
      Navigator.pushNamed(context, 'verify');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Live Pharmacy'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: userProvider.isSaving,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            width: size.width,
            child: Column(
              children: [
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter your name', style: kLargeBlueTextStyle),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                          isDense: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Enter your phone number', style: kLargeBlueTextStyle),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _number,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                          isDense: true,
                        ),
                        validator: (value) {
                          String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = new RegExp(pattern);
                          if (value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.trim().length != 10 || !regExp.hasMatch(value)) {
                            return 'Please enter a valid number';
                          } else {
                            setState(() {
                              phoneNumber = '+91$value';
                            });
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _showVerify
                          ? Container()
                          : Container(
                              width: size.width,
                              alignment: Alignment.center,
                              child: Container(
                                width: 175,
                                child: FlatButton(
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                  onPressed: () {
                                    setState(() {
                                      _showVerify = !_showVerify;
                                    });
                                    Fluttertoast.showToast(msg: 'OTP sent');
                                    FocusScope.of(context).unfocus();
                                    if (_form.currentState.validate()) {
                                      setState(() {
                                        phoneNumber = '+91' + _number.value.text.trim();
                                        print(phoneNumber);
                                        loginUser(phoneNumber, context);
                                      });
                                    }
                                  },
                                  child: Text('Send OTP', style: kLargeWhiteTextStyle),
                                ),
                              ),
                            ),
                      SizedBox(height: 40),
                      _showVerify
                          ? Column(
                              children: [
                                Text('Enter OTP', style: kLargeBlueTextStyle),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: _otp,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                                    isDense: true,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 175,
                                    child: FlatButton(
                                      color: kPrimaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                                      onPressed: () {
                                        codeSentFunction(verificationIdValue);
                                      },
                                      child: Text('Verify', style: kLargeWhiteTextStyle),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}