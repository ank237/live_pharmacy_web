import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Pharmacy'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login as', style: kLargeBlueTextStyle),
            SizedBox(height: 30),
            Container(
              width: size.width,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false).selectedRole = 'admin';
                  Navigator.pushNamed(context, 'login');
                },
                child: Text('ADMIN', style: kLargeWhiteTextStyle),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: size.width,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false).selectedRole = 'manager';
                  Navigator.pushNamed(context, 'login');
                },
                child: Text('MANAGER', style: kLargeWhiteTextStyle),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: size.width,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false).selectedRole = 'agent';
                  Navigator.pushNamed(context, 'login');
                },
                child: Text('DELIVERY AGENT', style: kLargeWhiteTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
