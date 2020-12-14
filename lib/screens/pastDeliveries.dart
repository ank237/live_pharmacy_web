import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';

class PastDeliveries extends StatefulWidget {
  @override
  _PastDeliveriesState createState() => _PastDeliveriesState();
}

class _PastDeliveriesState extends State<PastDeliveries> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Deliveries'),
      ),
      body: Container(
        width: size.width,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db.collection('orders'+' '+Stores.dropdownValue).orderBy('delivered_on', descending: true).where('delivered_on',isGreaterThanOrEqualTo: new DateTime.now().subtract(Duration(days: 2))).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      );
                    }
                    final orders = snapshot.data.docs;
                    List<Widget> orderWidget = [];
                    for (var order in orders) {
                      try {
                        DateTime date = order['delivered_on'].toDate();
                        if (order['delivered_by'] ==
                            userProvider.loggedInUser.docID &&
                            order['is_delivered'] == true &&
                            date.day == DateTime
                                .now()
                                .day) {
                          orderWidget.add(
                            Card(
                              margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: size.width * 0.9,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                            Icons.person, color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(order['name'],
                                            style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(order['address'],
                                            style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(order['phone'],
                                            style: kOrderCardTextStyle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.pills,
                                            color: kPrimaryColor),
                                        SizedBox(width: 10),
                                        Text(order['order_details'],
                                            style: kOrderCardTextStyle),
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
                                              orderProvider.selectedOrder =
                                                  OrderModel(
                                                    name: order['name'],
                                                    address: order['address'],
                                                    phoneNumber: order['phone'],
                                                    orderDetails: order['order_details'],
                                                    amount: order['amount'],
                                                    orderDocID: order.id,
                                                    agentName: order['agent_name'],
                                                    dues: order['dues'],
                                                  );
                                              Navigator.pushNamed(
                                                  context, 'details');
                                            },
                                            child: Text(
                                              'Order details',
                                              style: kWhiteButtonTextStyle,
                                              maxLines: 1,
                                            ),
                                            color: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 200),
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              orderProvider
                                                  .selectedForDelivery =
                                                  OrderModel(
                                                    name: order['name'],
                                                    address: order['address'],
                                                    phoneNumber: order['phone'],
                                                    orderDetails: order['order_details'],
                                                    amount: order['amount'],
                                                    orderDocID: order.id,
                                                    screenshot: order['screenshot'],
                                                    dues: order['dues'],
                                                  );
                                              Navigator.pushNamed(
                                                  context, 'editOrder');
                                            },
                                            child: Text(
                                              'Edit',
                                              style: kWhiteButtonTextStyle,
                                              maxLines: 1,
                                            ),
                                            color: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10),
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
                      catch(e){}
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
    );
  }
}