import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  var prefs;


  Future<void> checkLogin() async {
    if (_auth.currentUser != null) {
      setState(() {
        _isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.getCurrentUser(_auth.currentUser.phoneNumber);
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
    setState(() {
      _isLoading = false;
    });

  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      checkLogin();
      prefs = await SharedPreferences.getInstance();

      Stores.dropdownValue = prefs.getString('counter') ?? 'Select Store';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Pharmacy'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: _isLoading
            ? Container()
            : Container(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login as', style: kLargeBlueTextStyle),
              SizedBox(height: 30),
              Center(
                child: DropdownButton<String>(
                  value: Stores.dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  iconEnabledColor: Colors.red,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.red,
                  ),
                  onChanged: (String data) {
                    setState(() {
                      Stores.dropdownValue = data;

                      prefs.setString('counter', data);
                    });
                  },
                  items: Stores.spinnerItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: size.width/4,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: FlatButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    if(Stores.dropdownValue!='Select Store') {
                      Provider
                          .of<UserProvider>(context, listen: false)
                          .selectedRole = 'admin';
                      Navigator.pushNamed(context, 'login');
                    }

                  },
                  child: Text('ADMIN', style: kLargeWhiteTextStyle),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: size.width/4,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: FlatButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    if(Stores.dropdownValue!='Select Store') {
                      Provider
                          .of<UserProvider>(context, listen: false)
                          .selectedRole = 'manager';
                      Navigator.pushNamed(context, 'login');
                    }
                  },
                  child: Text('MANAGER', style: kLargeWhiteTextStyle),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: size.width/4,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: FlatButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    if(Stores.dropdownValue!='Select Store') {
                      Provider
                          .of<UserProvider>(context, listen: false)
                          .selectedRole = 'agent';
                      Navigator.pushNamed(context, 'login');
                    }
                  },
                  child: Text('DELIVERY AGENT', style: kLargeWhiteTextStyle),
                ),
              ),
              SizedBox(height: 15),
              Text('Version : 5.0.0', style: kLargeBlueTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}