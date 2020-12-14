import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Live Pharmacy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          width: size.width,
          child: Column(
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter your name', style: kLargeBlueTextStyle),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                        isDense: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Enter your phone number', style: kLargeBlueTextStyle),
                    SizedBox(height: 10),
                    TextFormField(
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
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          onPressed: () {},
                          child: Text('Send OTP', style: kLargeWhiteTextStyle),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text('Enter OTP', style: kLargeBlueTextStyle),
                    SizedBox(height: 10),
                    TextFormField(
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
                          onPressed: () {},
                          child: Text('Verify', style: kLargeWhiteTextStyle),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
