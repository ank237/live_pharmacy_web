import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person_pin),
        title: Text('Live Pharmacy'),
        actions: [
          Center(
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                child: Text(
                  '+   NEW',
                  style: kAppbarButtonTextStyle,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }
}
