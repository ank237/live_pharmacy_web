import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BoxModel> boxValues = [
    BoxModel(onTapFunc: () {}, image: 'latest', name: 'Latest'),
    BoxModel(onTapFunc: () {}, image: 'ongoing', name: 'Ongoing Deliveries'),
    BoxModel(onTapFunc: () {}, image: 'schedule', name: 'Scheduled deliveries'),
    BoxModel(onTapFunc: () {}, image: 'past', name: 'Past Deliveries'),
    BoxModel(onTapFunc: () {}, image: 'payments', name: 'Payments'),
    BoxModel(onTapFunc: () {}, image: 'notes', name: 'Notes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(FontAwesomeIcons.solidUserCircle),
        title: Text('Live Pharmacy'),
        actions: [
          Center(
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                child: Text(
                  '+   NEW',
                  style: kAppbarButtonTextStyle,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Container(
        child: GridView.builder(
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return HomePageBox(
              name: boxValues[index].name,
              image: boxValues[index].image,
              onTapFunc: boxValues[index].onTapFunc,
            );
          },
        ),
      ),
    );
  }
}

class BoxModel {
  String name;
  String image;
  Function onTapFunc;

  BoxModel({
    this.onTapFunc,
    this.image,
    this.name,
  });
}

class HomePageBox extends StatelessWidget {
  final String name;
  final String image;
  final Function onTapFunc;

  HomePageBox({
    @required this.name,
    @required this.image,
    @required this.onTapFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: InkWell(
        onTap: onTapFunc,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(name, style: kHomePageCardHeadingTextStyle),
              Image(
                image: AssetImage('assets/$image.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
