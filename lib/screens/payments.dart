import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:provider/provider.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  String dropDownValue = 'All Methods';
  FirebaseFirestore _db = FirebaseFirestore.instance;
  DateTime i_selectedDate = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  TextEditingController i_date = TextEditingController();
  DateTime f_selectedDate = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
  TextEditingController f_date = TextEditingController();

  Future<void> initial_selectDate(BuildContext context) async {
    final DateTime i_picked = await showDatePicker(
      context: context,
      initialDate: i_selectedDate,
      firstDate: DateTime.now().subtract(
        Duration(days: 180),
      ),
      lastDate: DateTime.now().add(
        Duration(days: 180),
      ),
    );
    if (i_picked != null ) {
      setState(() {
        i_selectedDate = i_picked;
        i_date.text = i_selectedDate.day.toString() + '/' + i_selectedDate.month.toString() + '/' + i_selectedDate.year.toString();
      });
    }
  }

  Future<void> final_selectDate(BuildContext context) async {
    final DateTime f_picked = await showDatePicker(
      context: context,
      initialDate: f_selectedDate,
      firstDate: i_selectedDate,
      lastDate: DateTime.now().add(
        Duration(days: 150),
      ),
    );
    if (f_picked != null) {
      setState(() {
        f_selectedDate = f_picked;
        f_date.text = f_selectedDate.day.toString() + '/' + f_selectedDate.month.toString() + '/' + f_selectedDate.year.toString();
        if(f_date.text!='' && i_date.text!=''){
//          final orderProvider = Provider.of<OrderProvider>(context, listen: false);
//          orderProvider.fetchAgentsDateFilter(i_selectedDate,f_selectedDate.add(Duration(minutes: 1430),));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'+' ( '+Stores.dropdownValue+' )'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: size.width,
        child: Column(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () {
                    initial_selectDate(context);
                  },
                  child: TextFormField(
                    controller: i_date,
                    enabled: false,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                      hintText: 'Tap to pick initial date',
                      suffixIcon: Icon(FontAwesomeIcons.solidCalendarAlt, color: kPrimaryColor, size: 25),

                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    final_selectDate(context);
                  },
                  child: TextFormField(
                    controller: f_date,
                    enabled: false,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                      hintText: 'Tap to pick final date',
                      suffixIcon: Icon(FontAwesomeIcons.solidCalendarAlt, color: kPrimaryColor, size: 25),

                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            Row(
              children: [
                Text('Show', style: kBlueTextStyle),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                    ),
                    value: dropDownValue,
                    items: ['All Methods', 'GPay', 'PhonePe', 'Paytm', 'Cash', 'PayLater', 'Card']
                        .map((label) => DropdownMenuItem(
                              child: Text(label.toString()),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream:_db.collection('orders'+' '+Stores.dropdownValue).orderBy('delivered_on', descending: true).where('delivered_on',isGreaterThanOrEqualTo: i_selectedDate).where('delivered_on',isLessThanOrEqualTo: f_selectedDate.add(Duration(minutes: 1430))).snapshots(),
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
                        if (dropDownValue != 'All Methods') {
                          if (order['is_delivered'] == true &&
                              order['mode_of_payment'] == dropDownValue) {
                            DateTime date = order['delivered_on'].toDate();
                            orderWidget.add(
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(date.day.toString() + '/' +
                                        date.month.toString() + '/' +
                                        date.year.toString(),
                                        style: kAppbarButtonTextStyle),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.person,
                                                color: kPrimaryColor),
                                            SizedBox(width: 5),
                                            Text(order['name'],
                                                style: kOrderCardTextStyle),
                                          ],
                                        ),
                                        Container(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/${order['mode_of_payment']}.png'),
                                          ),
                                        ),
                                        Text('Rs ' + order['amount'],
                                            style: kBlueTextStyle),
                                        SizedBox(width: 10),
                                        Container(
                                          child: FlatButton(
                                            onPressed: () {
                                              String imageUrl = 'image';
                                              try {
                                                imageUrl = order['screenshot'];
                                              } catch (e) {
                                                print(e);
                                              }
                                              orderProvider.selectedOrder =
                                                  OrderModel(
                                                      name: order['name'],
                                                      address: order['address'],
                                                      phoneNumber: order['phone'],
                                                      orderDetails: order['order_details'],
                                                      amount: order['amount'],
                                                      orderDocID: order.id,
                                                      screenshot: imageUrl,
                                                      agentName: order['agent_name']

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
                                          width: 100,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          if (order['is_delivered'] == true) {
                            DateTime date = order['delivered_on'].toDate();
                            orderWidget.add(
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(date.day.toString() + '/' +
                                        date.month.toString() + '/' +
                                        date.year.toString(),
                                        style: kAppbarButtonTextStyle),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.person,
                                                color: kPrimaryColor),
                                            SizedBox(width: 5),
                                            Text(order['name'],
                                                style: kOrderCardTextStyle),
                                          ],
                                        ),
                                        Container(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/${order['mode_of_payment']}.png'),
                                          ),
                                        ),
                                        (order['dues'].toString() != "" &&
                                            order['dues'].toString() != '0') ?
                                        Text('Rs ' + order['amount'].toString() +
                                            ' ( + dues: ' + order['dues'].toString() +
                                            ' )', style: kBlueTextStyle)
                                            : Text('Rs ' + order['amount'].toString(),
                                            style: kBlueTextStyle),
                                        SizedBox(width: 10),
                                        Container(
                                          child: FlatButton(
                                            onPressed: () {
                                              String imageUrl = 'image';
                                              try {
                                                imageUrl = order['screenshot'];
                                              } catch (e) {
                                                print(e);
                                              }
                                              orderProvider.selectedOrder =
                                                  OrderModel(
                                                    name: order['name'],
                                                    address: order['address'],
                                                    phoneNumber: order['phone'],
                                                    orderDetails: order['order_details'],
                                                    amount: order['amount'],
                                                    orderDocID: order.id,
                                                    screenshot: imageUrl,
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
                                          width: 100,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                      }
                      catch(e){
                        print(e);
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