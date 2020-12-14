import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map<String, bool> options = {
    'Cash': false,
    'GPay': false,
    'Card': false,
    'PhonePe': false,
    'Paytm': false,
    'PayLater': false,
  };
  String paymentMethod = '';
  File _image;
  final picker = ImagePicker();
  String imageUrl = 'image url';

  Future getImage() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.toggleIsLoading();
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 10);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Reference reference = FirebaseStorage.instance.ref().child("Screenshots/" + userProvider.loggedInUser.name + DateTime.now().toString());
      UploadTask uploadTask = reference.putFile(_image);
      String url = 'some url';
      await uploadTask.whenComplete(() async {
        url = await reference.getDownloadURL();
      });
      setState(() {
        imageUrl = url;
      });
    }
    print(imageUrl);
    orderProvider.toggleIsLoading();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: orderProvider.isSaving,
        child: Container(
          width: size.width,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: kPrimaryColor),
                          SizedBox(width: 10),
                          Text(orderProvider.selectedForDelivery.name, style: kOrderCardTextStyle),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: kPrimaryColor),
                          SizedBox(width: 10),
                          Text(orderProvider.selectedForDelivery.address, style: kOrderCardTextStyle),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.phone, color: kPrimaryColor),
                              SizedBox(width: 10),
                              Text(orderProvider.selectedForDelivery.phoneNumber, style: kOrderCardTextStyle),
                            ],
                          ),
                          Container(
                            width: 100,
                            child: FlatButton(
                              onPressed: () async {
                                String url = 'tel:${orderProvider.selectedForDelivery.phoneNumber}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Text(
                                'Call',
                                style: kWhiteButtonTextStyle,
                                maxLines: 1,
                              ),
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.pills, color: kPrimaryColor),
                          SizedBox(width: 10),
                          Text(orderProvider.selectedForDelivery.orderDetails, style: kOrderCardTextStyle),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('PAID VIA : ', style: kOrderCardTextStyle),
                      Container(
                        child: Column(
                          children: options.keys.map((String key) {
                            return Container(
                              child: Row(
                                children: [
                                  SizedBox(width: 20),
                                  Checkbox(
                                    activeColor: kPrimaryColor,
                                    value: options[key],
                                    onChanged: (value) {
                                      options.forEach((key, value) {
                                        options[key] = false;
                                      });
                                      setState(() {
                                        options[key] = value;
                                        paymentMethod = key;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Image(
                                    image: AssetImage('assets/$key.png'),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          (orderProvider.selectedForDelivery.dues != "" && orderProvider.selectedForDelivery.dues != '0' )?
                          Text('${orderProvider.selectedForDelivery.amount} ( + dues : ${orderProvider.selectedForDelivery.dues} )', style: kLargeBlueTextStyle)
                              :Text('Rs ${orderProvider.selectedForDelivery.amount}', style: kLargeBlueTextStyle),
                          Container(
                            width: 100,
                            child: FlatButton(
                              onPressed: () async {
                                await orderProvider.markOrderDelivered(paymentMethod, userProvider.loggedInUser.docID, imageUrl);
                                Fluttertoast.showToast(msg: 'Order marked delivered');
                                Navigator.pushNamed(context, 'deliveries');
                              },
                              child: Text(
                                'Done',
                                style: kWhiteButtonTextStyle,
                                maxLines: 1,
                              ),
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              imageUrl.contains('https') ? Text('Image Uploaded', style: kLargeBlueTextStyle) : Container(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}