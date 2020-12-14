import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:provider/provider.dart';

class LatestOrders extends StatefulWidget {
  @override
  _LatestOrdersState createState() => _LatestOrdersState();
}

class _LatestOrdersState extends State<LatestOrders> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      orderProvider.fetchAgents();
    });
    super.initState();
  }

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
        title: Text('Latest'+' ( '+Stores.dropdownValue+' )'),
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
                      if (order['delivered_by'] == 'na' && order['is_delivered'] == false) {
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
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    height: size.height * 0.25,
                                                    child: ListView.builder(
                                                      itemCount: orderProvider.agentList.length,
                                                      itemBuilder: (context, index) {
                                                        var agent = orderProvider.agentList[index];
                                                        return ListTile(
                                                          title: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(agent.name),
                                                              Text(agent.phone),
                                                            ],
                                                          ),
                                                          trailing: FlatButton(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            color: kPrimaryColor,
                                                            child: Text('Assign', style: kWhiteButtonTextStyle),
                                                            onPressed: () {
                                                              orderProvider.assignAgent(order.id, agent.docId, agent.name);
                                                              Navigator.pop(context);
                                                              Fluttertoast.showToast(msg: '${agent.name} assigned for this order');
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Text('Assign agent', style: kWhiteButtonTextStyle),
                                          color: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      )
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