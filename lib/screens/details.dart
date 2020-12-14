import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:js' as js;

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderProvider = Provider.of<OrderProvider>(context);
    print(orderProvider.selectedOrder.name);
    print(orderProvider.selectedOrder.agentName);
    //print(orderProvider.selectedOrder.deliveredBy);


    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Container(
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
                        Text(orderProvider.selectedOrder.name, style: kOrderCardTextStyle),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: kPrimaryColor),
                        SizedBox(width: 10),
                        Text(orderProvider.selectedOrder.address, style: kOrderCardTextStyle),
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
                            Text(orderProvider.selectedOrder.phoneNumber, style: kOrderCardTextStyle),
                          ],
                        ),
                        Container(
                          width: 100,
                          child: FlatButton(
                            onPressed: () async {
                              String url = 'tel:${orderProvider.selectedOrder.phoneNumber}';
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
                        Text(orderProvider.selectedOrder.orderDetails, style: kOrderCardTextStyle),
                      ],
                    ),
                    SizedBox(height: 5),
                    (orderProvider.selectedOrder.dues != "" && orderProvider.selectedOrder.dues != '0' )?
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.rupeeSign, color: kPrimaryColor),
                        SizedBox(width: 10),
                        Text('${orderProvider.selectedOrder.amount} ( + dues : ${orderProvider.selectedOrder.dues} )', style: kOrderCardTextStyle),
                      ],
                    ):
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.rupeeSign, color: kPrimaryColor),
                        SizedBox(width: 10),
                        Text('${orderProvider.selectedOrder.amount}', style: kOrderCardTextStyle),
                      ],
                    )
                    ,
                    SizedBox(height: 5),
                    orderProvider.selectedOrder.agentName !=null ?
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.truck, color: kPrimaryColor),
                        SizedBox(width: 10),
                        Text('${orderProvider.selectedOrder.agentName}', style: kOrderCardTextStyle),
                      ],
                    ) :
                    SizedBox(height: 5),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            orderProvider.selectedOrder.screenshot != null
                ? orderProvider.selectedOrder.screenshot.contains('https')
                    ? GestureDetector(
//              onTap: (){js.context.callMethod('open',[orderProvider.selectedOrder.screenshot]);
//              },
                      child: Image(
                          width: size.width * 0.5,
                          fit: BoxFit.fill,
                          height: size.width * 0.25,
                          image: NetworkImage(orderProvider.selectedOrder.screenshot),
                        ),
                    )
                    : Container()
                : Container(),
          ],
        ),
      ),
    );
  }
}