class OrderModel {
  String name;
  String address;
  String phoneNumber;
  String orderDetails;
  String amount,dues;
  DateTime date;
  bool isRepeating;
  bool isDelivered;
  String deliveredBy;
  String deliveredOn;
  String modeOfPayment;
  bool isPaid;
  DateTime orderCreatedDate;
  String orderDocID;
  String screenshot;
  // ignore: non_constant_identifier_names
  String agentName;



  OrderModel({
    this.name,
    this.agentName,
    this.screenshot,
    this.phoneNumber,
    this.date,
    this.amount,
    this.address,
    this.deliveredBy,
    this.deliveredOn,
    this.isDelivered,
    this.isPaid,
    this.isRepeating,
    this.modeOfPayment,
    this.orderCreatedDate,
    this.orderDetails,
    this.orderDocID,
    this.dues,
  });

}