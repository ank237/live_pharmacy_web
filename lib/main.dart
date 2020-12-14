import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/userProvider.dart';
import 'package:live_pharmacy/screens/home.dart';
import 'package:live_pharmacy/screens/initial.dart';
import 'package:live_pharmacy/screens/login.dart';
import 'package:provider/provider.dart';

void main() {
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
      ],
      child: MaterialApp(
        home: InitialScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primaryColor: kPrimaryColor,
        ),
        routes: {
          'home': (context) => Home(),
          'login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
