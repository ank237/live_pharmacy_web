import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  List<BoxModel> boxValues = [
    BoxModel(onTapFunc: 'latest', image: 'latest', name: 'Latest'),
    BoxModel(onTapFunc: 'ongoing', image: 'ongoing', name: 'Ongoing Deliveries'),
    BoxModel(onTapFunc: 'scheduled', image: 'schedule', name: 'Scheduled deliveries'),
    BoxModel(onTapFunc: 'past', image: 'past', name: 'Past Deliveries'),
    BoxModel(onTapFunc: 'payments', image: 'payments', name: 'Payments'),
    BoxModel(onTapFunc: 'summary', image: 'summary', name: 'Summary'),
    BoxModel(onTapFunc: 'notes', image: 'notes', name: 'Notes'),
  ];
  var prefs;

  Future<bool> _onBackPressed() {
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
            'Do you want to exit the app',
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
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            )
          ],
        );
      },
    ) ??
        false;
  }
  Future<void> checkLogin() async {
    if (_auth.currentUser == null) {
      Navigator.pushReplacementNamed(context, 'initial');
    }


  }
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await checkLogin();

      prefs = await SharedPreferences.getInstance();

      Stores.dropdownValue = prefs.getString('counter') ?? 'Select Store';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'profile');
              },
              child: Icon(FontAwesomeIcons.solidUserCircle)),
          title: Text('Live Pharmacy'),
          actions: [
            Center(
              child: InkWell(
                child: DropdownButton<String>(
                  value: Stores.dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconEnabledColor: Colors.red,
                  iconSize: 22,
                  elevation: 10,
                  style: TextStyle(color: Colors.red, fontSize: 16,fontWeight: FontWeight.bold),
                  underline: Container(
                    height: 2,
                    color: Colors.red,
                  ),
                  onChanged: (String data) {
                    setState(() {
                      Stores.dropdownValue = data;
                      prefs.setString('counter', data);
                    });
                  },
                  items: Stores.spinnerItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

              ),
            ),
            SizedBox(width: 10),
            if(Stores.dropdownValue!='Select Store')
            InkWell(
              child: Icon(FontAwesomeIcons.solidBell),
              onTap: () {
                Navigator.pushNamed(context, 'upcomingReminders');
              },
            ),
            SizedBox(width: 10),
            if(Stores.dropdownValue!='Select Store')
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'create');
                },
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: GridView.builder(
                  itemCount: boxValues.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                  itemBuilder: (BuildContext context, int index) {
                    if(Stores.dropdownValue!='Select Store')
                    return HomePageBox(
                      name: boxValues[index].name,
                      image: boxValues[index].image,
                      onTapFunc: boxValues[index].onTapFunc,
                    ) ;
                    else
                    return Container();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.2,
                  child: FlatButton(
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    onPressed: () {
                      Navigator.pushNamed(context, 'verifyUsers');
                    },
                    child: Text('Verify Users', style: kLargeWhiteTextStyle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxModel {
  String name;
  String image;
  String onTapFunc;

  BoxModel({
    this.onTapFunc,
    this.image,
    this.name,
  });
}

class HomePageBox extends StatelessWidget {
  final String name;
  final String image;
  final String onTapFunc;

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
        onTap: () {
          Navigator.pushNamed(context, onTapFunc);
        },
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