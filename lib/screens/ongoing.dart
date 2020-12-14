import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:provider/provider.dart';

class OngoingOrders extends StatefulWidget {
  @override
  _OngoingOrdersState createState() => _OngoingOrdersState();
}

class _OngoingOrdersState extends State<OngoingOrders> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> _onCancelPressed(String docID) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
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
            'Do you want to cancel this order ?',
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
              onPressed: () async {
                orderProvider.cancelOrder(docID);
                Navigator.of(context).pop(false);
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
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing deliveries'+' ( '+Stores.dropdownValue+' )'),
      ),
      body: Container(
        width: size.width,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db.collection('orders'+' '+Stores.dropdownValue).orderBy('order_created_date', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      );
                    }
                    final orders = snapshot.data.docs;
                    List<Widget> orderWidget = [];
                    for (var order in orders) {
                      if (order['delivered_by'] != 'na' && order['is_delivered'] == false) {
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
                                      Text(order['address'], style: kOrderCardTextStyle),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {
                                            _onCancelPressed(order.id);
                                          },
                                          child: Text('Cancel Order', style: kWhiteButtonTextStyle),
                                          color: kCancelButtonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 200),
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
                                        child: Row(
                                          children: [
                                            Icon(Icons.person_pin, color: kPrimaryColor),
                                            SizedBox(width: 5),
                                            Text(order['agent_name'], style: kAppbarButtonTextStyle),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ],
        ),
      ),
    );
  }
}