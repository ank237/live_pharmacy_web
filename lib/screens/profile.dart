import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context).loggedInUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user.name, style: kLargeBlueTextStyle),
                SizedBox(height: 10),
                Text(user.phone, style: kLargeBlueTextStyle),
                SizedBox(height: 10),
                Text(user.role, style: kLargeBlueTextStyle),
                SizedBox(height: 20),
                Container(
                  width: size.width,
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child:
                  FlatButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: kPrimaryColor,
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.pushNamed(context, 'initial');
                    },
                    child: Text('LOGOUT', style: kLargeWhiteTextStyle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}