import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';

class Summary extends StatefulWidget {
  @override
  _SummaryState createState() => _SummaryState();



}

class _SummaryState extends State<Summary> {
  int count =0;
//  var agent;





  List<DataRow> _rowList = [
    DataRow(cells: <DataCell>[
      DataCell(Text('AAAAAA')),
      DataCell(Text('1')),
      DataCell(Text('Actor')),
      DataCell(Text('Actor')),
      DataCell(Text('Actor')),
      DataCell(Text('Actor')),
      DataCell(Text('Actor')),
    ]),
  ];


  @override
  void initState() {
    Future.delayed(Duration.zero, () async {

//      int ans = await Provider.of<OrderProvider>(context, listen: false).getTotalOrderDeliveredByAgent('qrbqS9mPYW0FXDya0glh');
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      DateTime now=new DateTime.now();

//      var agent = await Provider.of<OrderProvider>(context).agentList;
//      print(agent.length);

      setState(() {

//        count = ans;
        orderProvider.fetchAgentsDateFilter(new DateTime(now.year, now.month, now.day, 0, 0, 0),new DateTime(now.year, now.month, now.day, 23, 59, 59));




      });
    });
    super.initState();
  }
  DateTime i_selectedDate = DateTime.now();
  TextEditingController i_date = TextEditingController();
  DateTime f_selectedDate = DateTime.now();
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
        if(f_date.text!='' && i_date.text!=''){
          final orderProvider = Provider.of<OrderProvider>(context, listen: false);
          orderProvider.fetchAgentsDateFilter(i_selectedDate,f_selectedDate.add(Duration(minutes: 1430),));
        }
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
          final orderProvider = Provider.of<OrderProvider>(context, listen: false);
          orderProvider.fetchAgentsDateFilter(i_selectedDate,f_selectedDate.add(Duration(minutes: 1430),));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context)  {
    final size = MediaQuery.of(context).size;
    final orderProvider = Provider.of<OrderProvider>(context);
    print(orderProvider.agentList.length);


    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'+' ( '+Stores.dropdownValue+' )'),
      ),
      body:ListView(children: <Widget>[
        Column(
          children: [
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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


        Center(
            child: Text(
              'SUMMARY',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
        DataTable(
          columns: [
            DataColumn(label: Text(
                'AGENT NAME',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(
                'CASH',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(
                'PAYTM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(
                'GOOGLE PAY',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(
                'PHONE PAY',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(
                'CARD',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(
                'PAY LATER',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(
                'COUNT',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(
                'TOTAL',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.green)
            )),
          ],
          rows:   List<DataRow>.generate(
              orderProvider.agentList.length,
                  (index) => DataRow(cells: [
                    DataCell(Text(orderProvider.agentList[index].name)),
                DataCell(Text(orderProvider.agentList[index].cash.toString())),
                DataCell(Text(orderProvider.agentList[index].paytm.toString())),
                    DataCell(Text(orderProvider.agentList[index].gpay.toString())),
                    DataCell(Text(orderProvider.agentList[index].phonepay.toString())),
                    DataCell(Text(orderProvider.agentList[index].card.toString())),
                    DataCell(Text(orderProvider.agentList[index].paylater.toString(),style:  TextStyle(color: Colors.orange))),
                    DataCell(Text(orderProvider.agentList[index].count.toString())),
                    DataCell(Text(orderProvider.agentList[index].total.toString() + '( + '+orderProvider.agentList[index].dues.toString()+' )',style:  TextStyle(color: Colors.green))),

              ])),
        ),

      ]),

    );

  }



}