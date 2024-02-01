import 'package:flutter/material.dart';
import 'package:patrolin/Pages/first_page.dart';
import 'package:patrolin/Pages/second_page.dart';
import 'package:share_plus/share_plus.dart';

class MyDrower extends StatelessWidget {
  const MyDrower({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green.shade50,
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/img/drawer.jpg'),
              fit: BoxFit.cover,
            ),
            color: Colors.green.shade400,
          ),
          child: const Text(
            'Petrolin',
            style: TextStyle(color: Colors.white, fontSize: 35),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home, color: Colors.green.shade400),
          title: const Text('Petrol Calculator',
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Homepage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.opacity_outlined, color: Colors.green.shade400),
          title: const Text(
            'Petrol and Diesel Calculator',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SecondMeter()));
          },
        ),
        ListTile(
          leading: Icon(Icons.share, color: Colors.green.shade400),
          title: const Text('Share',
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Share.share(
                'https://play.google.com/store/apps/details?id=com.petrolin.petrolin',
                subject: 'Petrolin');
          },
        ),
        ListTile(
          leading: Icon(Icons.star, color: Colors.green.shade400),
          title: const Text('Rate Us',
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        AboutListTile(
          dense: true,
          icon: Icon(Icons.info, color: Colors.green.shade400),
          applicationIcon: Icon(
            Icons.local_gas_station,
            color: Colors.green.shade400,
          ),
          applicationName: 'Petrolin',
          applicationVersion: '1.0.2',
          applicationLegalese: '© 2024',
          child: const Text('About Petrolin',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}
