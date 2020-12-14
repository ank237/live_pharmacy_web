import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/notesProvider.dart';
import 'package:live_pharmacy/provider/orderProvider.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:live_pharmacy/screens/createOrder.dart';
import 'package:live_pharmacy/screens/deliveries.dart';
import 'package:live_pharmacy/screens/details.dart';
import 'package:live_pharmacy/screens/editOrder.dart';
import 'package:live_pharmacy/screens/home.dart';
import 'package:live_pharmacy/screens/initial.dart';
import 'package:live_pharmacy/screens/latest.dart';
import 'package:live_pharmacy/screens/login.dart';
import 'package:live_pharmacy/screens/notes.dart';
import 'package:live_pharmacy/screens/ongoing.dart';
import 'package:live_pharmacy/screens/orderDetails.dart';
import 'package:live_pharmacy/screens/past.dart';
import 'package:live_pharmacy/screens/pastDeliveries.dart';
import 'package:live_pharmacy/screens/payments.dart';
import 'package:live_pharmacy/screens/profile.dart';
import 'package:live_pharmacy/screens/scheduled.dart';
import 'package:live_pharmacy/screens/summary.dart';
import 'package:live_pharmacy/screens/upcomingReminders.dart';
import 'package:live_pharmacy/screens/verification.dart';
import 'package:live_pharmacy/screens/verifyUsers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotesProvider(),
        ),
      ],
      child: MaterialApp(
        home: InitialScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(),
          primaryColor: kPrimaryColor,
        ),
        routes: {
          'initial': (context) => InitialScreen(),
          'home': (context) => Home(),
          'login': (context) => LoginScreen(),
          'profile': (context) => Profile(),
          'create': (context) => CreateOrder(),
          'latest': (context) => LatestOrders(),
          'ongoing': (context) => OngoingOrders(),
          'deliveries': (context) => Deliveries(),
          'orderDetails': (context) => OrderDetails(),
          'past': (context) => PastOrder(),
          'payments': (context) => Payments(),
          'notes': (context) => Notes(),
          'upcomingReminders': (context) => UpcomingReminders(),
          'scheduled': (context) => ScheduledDeliveries(),
          'details': (context) => Details(),
          'verify': (context) => Verification(),
          'verifyUsers': (context) => VerifyUsers(),
          'pastdeliveries': (context) => PastDeliveries(),
          'editOrder': (context) => EditOrder(),
          'summary' : (context) => Summary(),
        },
      ),
    );
  }
}