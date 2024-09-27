import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(AgendaApp());
}

class AgendaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Telefônica',
      theme: ThemeData(
        primaryColor: Color(0xFF32404B),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF32404B),
          secondary: Color(0xFF0087F5),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0, color: Color(0xFF2B2F33)),
          titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0xFF3570A0)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF32404B),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF32404B),
        ),
        cardColor: Color(0xFF3B5B75),
      ),
      home: HomePage(),
    );
  }
}
