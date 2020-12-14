import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/models/agentModel.dart';
import 'package:live_pharmacy/models/orderModel.dart';
import 'package:live_pharmacy/models/store.dart';

class OrderProvider extends ChangeNotifier {
  OrderModel newOrder;
  OrderModel selectedForDelivery;
  OrderModel selectedOrder;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  bool isSaving = false;
  List<AgentModel> agentList = [];

  void toggleIsLoading() {
    isSaving = !isSaving;
    notifyListeners();
  }

  Future<void> markOrderDelivered(String payment, String userID, String imageUrl) async {
    toggleIsLoading();
    await _db.collection('orders'+' '+Stores.dropdownValue).doc(selectedForDelivery.orderDocID).update({
      'is_delivered': true,
      'delivered_on': DateTime.now(),
      'mode_of_payment': payment,
      'screenshot': imageUrl,
      'is_paid': true,
    });
    var res = await _db.collection('users').doc(userID).collection('deliveries').get();
    for (var r in res.docs) {
      if (r['order_id'] == selectedForDelivery.orderDocID) {
        await _db.collection('users').doc(userID).collection('deliveries').doc(r.id).update({
          'delivered': true,
        });
      }
    }
    toggleIsLoading();
    notifyListeners();
  }



  Future<void> cancelOrder(String orderId) async {
    toggleIsLoading();
    await _db.collection('orders'+' '+Stores.dropdownValue).doc(orderId).delete();
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> cancelScheduledOrder(String orderId) async {
    toggleIsLoading();
    await _db.collection('scheduled').doc(orderId).delete();
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> assignAgent(String orderId, String agentId, String agentName) async {
    toggleIsLoading();
    await _db.collection('orders'+' '+Stores.dropdownValue).doc(orderId).update(
      {
        'delivered_by': agentId,
        'agent_name': agentName,
      },
    );
    await _db.collection('users').doc(agentId).collection('deliveries').add({
      'order_id': orderId,
      'date': DateTime.now(),
      'delivered': false,
    });
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> assignAgentForScheduledOrder(String orderId, String agentId, String agentName, OrderModel orderVal) async {
    toggleIsLoading();
    var res = await _db.collection('orders'+' '+Stores.dropdownValue).add({
      'name': orderVal.name,
      'address': orderVal.address,
      'agent_name': agentName,
      'phone': orderVal.phoneNumber,
      'order_details': orderVal.orderDetails,
      'amount': orderVal.amount,
      'dues' : '',
      'delivery_date': orderVal.date,
      'is_repeating': orderVal.isRepeating,
      'is_delivered': orderVal.isDelivered,
      'delivered_by': orderVal.deliveredBy,
      'delivered_on': orderVal.deliveredOn,
      'mode_of_payment': orderVal.modeOfPayment,
      'is_paid': orderVal.isPaid,
      'order_created_date': orderVal.orderCreatedDate,
    });
    await _db.collection('scheduled'+' '+Stores.dropdownValue).doc(orderId).update({
      'delivery_date': orderVal.date,
    });
    await _db.collection('users').doc(agentId).collection('deliveries').add({
      'order_id': res.id,
      'date': DateTime.now(),
      'delivered': false,
    });
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> saveNewScheduledOrder() async {
    toggleIsLoading();
    await _db.collection('scheduled'+' '+Stores.dropdownValue).add({
      'name': newOrder.name,
      'address': newOrder.address,
      'phone': newOrder.phoneNumber,
      'order_details': newOrder.orderDetails,
      'amount': newOrder.amount,
      'dues' : '',
      'delivery_date': newOrder.date.add(Duration(days: 30)),
      'is_repeating': newOrder.isRepeating,
      'is_delivered': newOrder.isDelivered,
      'delivered_by': newOrder.deliveredBy,
      'delivered_on': newOrder.deliveredOn,
      'mode_of_payment': newOrder.modeOfPayment,
      'is_paid': newOrder.isPaid,
      'order_created_date': newOrder.orderCreatedDate,

    });
    await _db.collection('customers'+' '+Stores.dropdownValue).doc(newOrder.phoneNumber).update({
      'name': newOrder.name,
      'address': newOrder.address,
      'phone': newOrder.phoneNumber,
    });
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> saveNewOrder() async {
    toggleIsLoading();
    await _db.collection('orders'+' '+Stores.dropdownValue).add({
      'name': newOrder.name,
      'address': newOrder.address,
      'phone': newOrder.phoneNumber,
      'order_details': newOrder.orderDetails,
      'amount': newOrder.amount,
      'dues' : newOrder.dues,
      'delivery_date': newOrder.date,
      'is_repeating': newOrder.isRepeating,
      'is_delivered': newOrder.isDelivered,
      'delivered_by': newOrder.deliveredBy,
      'delivered_on': newOrder.deliveredOn,
      'mode_of_payment': newOrder.modeOfPayment,
      'is_paid': newOrder.isPaid,
      'order_created_date': newOrder.orderCreatedDate,
    });

    await _db.collection('customers'+' '+Stores.dropdownValue).doc(newOrder.phoneNumber).set({
      'name': newOrder.name,
      'address': newOrder.address,
      'phone': newOrder.phoneNumber,
    },SetOptions(merge: true));
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> getTotalOrderDeliveredByAgent(String id,String name,String phone) async {
    int price = 0,dues=0,count=0;
    int cash=0,gpay=0,paylater=0,paytm=0,card=0,phonepay=0;
    print("check"+ agentList.length.toString());

      var res = await _db.collection('orders' + ' ' + Stores.dropdownValue)
          .where('delivered_by', isEqualTo: id).where(
          'is_delivered', isEqualTo: true)
          .get();
      for (var d in res.docs) {
        //DateTime date = d['date'].toDate();
        count++;



          try {
            dues += int.parse(d['dues']);
          }
          catch(e){}
        switch (d['mode_of_payment']) {
          case 'Cash' :
            try {
              price += int.parse(d['amount']);
              cash += int.parse(d['amount']);
            }
            catch (e){}

            break;
          case 'GPay' :
            try {
              price += int.parse(d['amount']);
              gpay += int.parse(d['amount']);
            }
            catch (e){}

            break;
          case 'Card' :
            try {
              price += int.parse(d['amount']);
              card += int.parse(d['amount']);
            }
            catch (e){}

            break;
          case 'PayLater' :
            try {
//              price += int.parse(d['amount']);
              paylater += int.parse(d['amount']);
            }
            catch (e){}

            break;
          case 'Paytm' :
            try {
              price += int.parse(d['amount']);
              paytm += int.parse(d['amount']);
            }
            catch (e){}

            break;
          case 'PhonePe' :
            try {
              price += int.parse(d['amount']);
              phonepay += int.parse(d['amount']);
            }
            catch (e){}

            break;


        }


//      if (date.day == DateTime.now().day) {
//        price += int.parse(d['amount']);
//      }
      }
    agentList.add(
      AgentModel(
          name: name,
          phone: phone,
          docId: id,
          total: price,
          cash: cash,
          gpay: gpay,
        paylater: paylater,
        card: card,
        paytm: paytm,
        phonepay: phonepay,
        dues: dues,
        count: count
      ),
    );
    notifyListeners();



  }
  Future<void> fetchAgents() async {
    agentList.clear();
    var res = await _db.collection('users').get();
    for (var d in res.docs) {
      if (d['role'] == 'agent') {
        getTotalOrderDeliveredByAgent(d.id,d['name'],d['phone']);


      }
    }
    notifyListeners();
  }

  Future<int> getModePaymentByAgent(String agent,String mode) async {
    int price = 0;

    var res = await _db.collection('orders'+' '+Stores.dropdownValue).where('delivered_by',isEqualTo: agent).where('is_delivered',isEqualTo: true).where('mode_of_payment',isEqualTo: mode).get();
    for (var d in res.docs) {
      //DateTime date = d['date'].toDate();
      price += int.parse(d['amount']);

      print(mode + price.toString());

    }
    return price;
  }

  Future<void> fetchAgentsDateFilter(DateTime i_selectedDate, DateTime f_selectedDate) async {
    agentList.clear();
    var res = await _db.collection('users').get();
    for (var d in res.docs) {
      if (d['role'] == 'agent') {
        getTotalOrderDeliveredByAgentDateFilter(d.id,d['name'],d['phone'],i_selectedDate,f_selectedDate);


      }
    }
    notifyListeners();
  }

  Future<void> getTotalOrderDeliveredByAgentDateFilter(String id,String name,String phone,DateTime i_selectedDate, DateTime f_selectedDate) async {
    int price = 0,dues=0,count=0;
    int cash=0,gpay=0,paylater=0,paytm=0,card=0,phonepay=0;
    print("check"+ agentList.length.toString());

    var res = await _db.collection('orders' + ' ' + Stores.dropdownValue)
        .where('delivered_by', isEqualTo: id).where(
        'is_delivered', isEqualTo: true).where('delivered_on',isGreaterThanOrEqualTo: i_selectedDate).where('delivered_on',isLessThanOrEqualTo: f_selectedDate)
        .get();
    for (var d in res.docs) {
      //DateTime date = d['date'].toDate();
      count++;


      try {
        dues += int.parse(d['dues']);
      }
      catch(e){}
      switch (d['mode_of_payment']) {
        case 'Cash' :
          try {
            price += int.parse(d['amount']);
            cash += int.parse(d['amount']);
          }
          catch (e){}

          break;
        case 'GPay' :
          try {
            price += int.parse(d['amount']);
            gpay += int.parse(d['amount']);
          }
          catch (e){}

          break;
        case 'Card' :
          try {
            price += int.parse(d['amount']);
            card += int.parse(d['amount']);
          }
          catch (e){}

          break;
        case 'PayLater' :
          try {
//            price += int.parse(d['amount']);
            paylater += int.parse(d['amount']);
          }
          catch (e){}

          break;
        case 'Paytm' :
          try {
            price += int.parse(d['amount']);
            paytm += int.parse(d['amount']);
          }
          catch (e){}

          break;
        case 'PhonePe' :
          try {
            price += int.parse(d['amount']);
            phonepay += int.parse(d['amount']);
          }
          catch (e){}

          break;


      }


//      if (date.day == DateTime.now().day) {
//        price += int.parse(d['amount']);
//      }
    }
    agentList.add(
      AgentModel(
          name: name,
          phone: phone,
          docId: id,
          total: price,
          cash: cash,
          gpay: gpay,
          paylater: paylater,
          card: card,
          paytm: paytm,
          phonepay: phonepay,
          dues: dues,
          count: count
      ),
    );
    notifyListeners();



  }








}