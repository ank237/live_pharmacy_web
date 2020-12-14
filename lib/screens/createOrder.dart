import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class CreateOrder extends StatefulWidget {
  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  bool repeating = false;

  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _orderDetails = TextEditingController();
  TextEditingController _billingAmount = TextEditingController(text: '0');
  TextEditingController _duesAmount = TextEditingController(text: '0');
  TextEditingController _date = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 30),
      ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.text = selectedDate.day.toString() + '/' + selectedDate.month.toString() + '/' + selectedDate.year.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Live Pharmacy'+' ( '+Stores.dropdownValue+' )'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: orderProvider.isSaving,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(20),
            width: size.width,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name', style: kLargeBlueTextStyle),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _name,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Address', style: kLargeBlueTextStyle),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _address,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Phone Number', style: kLargeBlueTextStyle),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumber,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    onFieldSubmitted: (String value) async {
                      var res = await FirebaseFirestore.instance.collection('customers'+' '+Stores.dropdownValue).where('phone',isEqualTo: value).get();
                      if(!res.docs.isEmpty)
                      for (var d in res.docs) {
                        _name.text=d['name'];
                        _address.text=d['address'];

                      }
                      else{
                        _name.text='';
                        _address.text='';
                      }

                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                    ),


                  ),
                  SizedBox(height: 20),
                  Text('Order Details', style: kLargeBlueTextStyle),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _orderDetails,
                    minLines: 4,
                    maxLines: 5,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Dues', style: kLargeBlueTextStyle),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _duesAmount,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Billing Amount', style: kLargeBlueTextStyle),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _billingAmount,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Delivery Date', style: kLargeBlueTextStyle),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: TextFormField(
                      controller: _date,
                      enabled: false,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                        isDense: true,
                        hintText: 'Tap to pick date',
                        suffixIcon: Icon(FontAwesomeIcons.solidCalendarAlt, color: kPrimaryColor, size: 25),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Monthly repeating customer ?', style: kLargeBlueTextStyle),
                      CupertinoSwitch(
                        activeColor: kPrimaryColor,
                        value: repeating,
                        onChanged: (bool value) {
                          setState(() {
                            repeating = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: Container(
                      width: 150,
                      child: FlatButton(
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: kPrimaryColor,
                        onPressed: () async {
                          orderProvider.newOrder = OrderModel(
                            name: _name.value.text,
                            address: _address.value.text,
                            phoneNumber: _phoneNumber.value.text,
                            orderDetails: _orderDetails.value.text,
                            amount: _billingAmount.value.text,
                            dues : _duesAmount.value.text,
                            date: selectedDate,
                            isRepeating: repeating,
                            isDelivered: false,
                            deliveredBy: 'na',
                            deliveredOn: '',
                            modeOfPayment: '',
                            isPaid: false,
                            orderCreatedDate: DateTime.now(),
                            orderDocID: '',
                          );
                          if (repeating == true) {
                            await orderProvider.saveNewScheduledOrder();
                          }
                          await orderProvider.saveNewOrder();
                          Fluttertoast.showToast(msg: 'Order Created');
                          Navigator.pushNamed(context, 'home');
                        },
                        child: Text('SAVE', style: kLargeWhiteTextStyle),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}