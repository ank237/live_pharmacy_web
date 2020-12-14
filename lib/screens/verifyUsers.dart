import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class VerifyUsers extends StatefulWidget {
  @override
  _VerifyUsersState createState() => _VerifyUsersState();
}

class _VerifyUsersState extends State<VerifyUsers> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Users'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: userProvider.isSaving,
        child: Container(
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _db.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator(
                          backgroundColor: kPrimaryColor,
                        );
                      }
                      final users = snapshot.data.docs;
                      List<Widget> userWidget = [];
                      for (var user in users) {
                        if (user['isVerified'] == false) {
                          userWidget.add(
                            Card(
                              margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: size.width * 0.9,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(user['name'], style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(user['phone'], style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.watchmanMonitoring, color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(user['role'], style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              userProvider.rejectUser(user.id);
                                            },
                                            child: Text(
                                              'Reject',
                                              style: kWhiteButtonTextStyle,
                                              maxLines: 1,
                                            ),
                                            color: kCancelButtonColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 500),
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              userProvider.verifyUser(user.id);
                                            },
                                            child: Text(
                                              'Verify',
                                              style: kWhiteButtonTextStyle,
                                              maxLines: 1,
                                            ),
                                            color: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      return Column(
                        children: userWidget,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}