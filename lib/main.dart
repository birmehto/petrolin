import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:patrolin/Pages/first_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const Petrolin());
}

class Petrolin extends StatelessWidget {
  const Petrolin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petrolin',
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
      theme: ThemeData(
        hintColor: Colors.green,
        primarySwatch: Colors.green,
        useMaterial3: false,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
