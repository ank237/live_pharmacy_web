import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Deliveries extends StatefulWidget {
  @override
  _DeliveriesState createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  int count = 0;
  var prefs;


  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      int ans = await Provider.of<UserProvider>(context, listen: false).getTotalOrderDelivered();
      setState(() async {
        count = ans;
        prefs = await SharedPreferences.getInstance();
        Stores.dropdownValue = prefs.getString('counter') ?? 'Select Store';

      });
    });
    super.initState();
  }

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
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'profile');
              },
              child: Icon(FontAwesomeIcons.solidUserCircle)),
          title: Text('Delivery'),
          actions: [
            Center(
              child: InkWell(
                child: DropdownButton<String>(
                  value: Stores.dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconEnabledColor: Colors.red,
                  iconSize: 22,
                  elevation: 10,
                  style: TextStyle(color: Colors.red, fontSize: 16,fontWeight: FontWeight.bold),
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
            ),
            SizedBox(width: 10),
            InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'pastdeliveries');
                  },
                  child: Center(
                      child: Text('$count Completed', style: kLargeWhiteTextStyle))
            ),
            SizedBox(width: 15),
          ],
        ),
        body: Container(
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _db.collection('orders'+' '+Stores.dropdownValue).orderBy('order_created_date', descending: false).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator(
                          backgroundColor: kPrimaryColor,
                        );
                      }
                      final orders = snapshot.data.docs;
                      List<Widget> orderWidget = [];
                      for (var order in orders) {
                        if (order['delivered_by'] == userProvider.loggedInUser.docID && order['is_delivered'] == false) {
                          orderWidget.add(
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
                                        Text(order['name'], style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(order['address'], style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(order['phone'], style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.pills, color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(order['order_details'], style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Expanded(child: Container()),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              orderProvider.selectedOrder = OrderModel(
                                                name: order['name'],
                                                address: order['address'],
                                                phoneNumber: order['phone'],
                                                orderDetails: order['order_details'],
                                                amount: order['amount'],
                                                orderDocID: order.id,
                                                  agentName: order['agent_name'],
                                                dues: order['dues'],
                                              );
                                              Navigator.pushNamed(context, 'details');
                                            },
                                            child: Text(
                                              'Order details',
                                              style: kWhiteButtonTextStyle,
                                              maxLines: 1,
                                            ),
                                            color: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 200),
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              orderProvider.selectedForDelivery = OrderModel(
                                                name: order['name'],
                                                address: order['address'],
                                                phoneNumber: order['phone'],
                                                orderDetails: order['order_details'],
                                                amount: order['amount'],
                                                orderDocID: order.id,
                                                dues: order['dues'],
                                              );
                                              Navigator.pushNamed(context, 'orderDetails');
                                            },
                                            child: Text(
                                              'Start',
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
                        children: orderWidget,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
