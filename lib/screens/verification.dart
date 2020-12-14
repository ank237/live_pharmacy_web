import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              content: Text(
                'Do you want to exit the app',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('YES'),
                  onPressed: () {
                    Navigator.pushNamed(context, 'initial');
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'profile');
            },
            child: Icon(FontAwesomeIcons.solidUserCircle),
          ),
          title: Text('Live Pharmacy'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Text(
                  'You are not verified yet! Please try again later',
                  style: kLargeBlueTextStyle,
                ),
                SizedBox(height: 50,),
                Text(
                  'Verified ?? Reload',
                  style: kLargeBlueTextStyle,
                ),
                SizedBox(height: 10,),
                FlatButton(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  onPressed: () {
                    Navigator.pushNamed(context, 'initial');
                  },
                  child: Text('Reload', style: kLargeWhiteTextStyle),
                ),

              ],
            ),

          ),
        ),
      ),
    );
  }
}