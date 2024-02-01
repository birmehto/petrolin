// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:patrolin/Cloud_Services/ads_manger.dart';
import 'package:patrolin/Wigeds/mytextform.dart';

class SecondMeter extends StatefulWidget {
  const SecondMeter({super.key});

  @override
  State<SecondMeter> createState() => _HomepageState();
}

class _HomepageState extends State<SecondMeter> {
  final TextEditingController _opening = TextEditingController();
  final TextEditingController _closing = TextEditingController();
  final TextEditingController _opening2 = TextEditingController();
  final TextEditingController _closing2 = TextEditingController();
  final TextEditingController _pinlab = TextEditingController();
  final TextEditingController _onlinePayment = TextEditingController();
  final TextEditingController _depositCash = TextEditingController();

  double petrolUsed = 0.0;
  double cashAvailable = 0.0;
  double price = 96.45; // Initial petrol price

  // Create FocusNode instances for each TextField
  final FocusNode _openingFocusNode = FocusNode();
  final FocusNode _closingFocusNode = FocusNode();
  final FocusNode _opening2FocusNode = FocusNode();
  final FocusNode _closing2FocusNode = FocusNode();
  final FocusNode _pinlabFocusNode = FocusNode();
  final FocusNode _onlinePaymentFocusNode = FocusNode();
  final FocusNode _depositCashFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose of the FocusNode instances when the widget is disposed
    _openingFocusNode.dispose();
    _closingFocusNode.dispose();
    _opening2FocusNode.dispose();
    _closing2FocusNode.dispose();
    _pinlabFocusNode.dispose();
    _onlinePaymentFocusNode.dispose();
    _depositCashFocusNode.dispose();
    super.dispose();
  }

  void _calculatePetrolAndCash() {
    // Parse values from text controllers
    double openingMeter = double.tryParse(_opening.text) ?? 0;
    double closingMeter = double.tryParse(_closing.text) ?? 0;
    double opening2Meter = double.tryParse(_opening2.text) ?? 0;
    double closing2Meter = double.tryParse(_closing2.text) ?? 0;
    double pinlabValue = double.tryParse(_pinlab.text) ?? 0;
    double onlinePaymentValue = double.tryParse(_onlinePayment.text) ?? 0;

    double depositCashValue = double.tryParse(_depositCash.text) ?? 0;

    // Check for suspicious data
    if (openingMeter < 0 ||
        closingMeter < 0 ||
        opening2Meter < 0 ||
        closing2Meter < 0 ||
        pinlabValue < 0 ||
        onlinePaymentValue < 0 ||
        depositCashValue < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Please enter valid positive values',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    // Check if opening meter is less than closing meter
    if (openingMeter < closingMeter || opening2Meter < closing2Meter) {
      // Calculate petrol used
      petrolUsed = closingMeter - openingMeter + closing2Meter - opening2Meter;

      // Calculate cash available
      cashAvailable = (petrolUsed * price) -
          pinlabValue -
          onlinePaymentValue -
          depositCashValue;

      // Check for negative cash value
      if (cashAvailable < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Calculated cash cannot be negative',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
        return;
      }

      // Update UI
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Opening meter must be less than closing meter',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  void _updatePetrolPrice() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController newPriceController = TextEditingController();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Update Petrol Price',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: newPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'Enter new petrol price',
                  ),
                ),
                const SizedBox(height: 20.0), // Increase the height as needed
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Update petrol price from the dialog
                        price =
                            double.tryParse(newPriceController.text) ?? price;

                        // Clear the new petrol price text field
                        newPriceController.clear();

                        // Update UI
                        setState(() {});

                        // Close the dialog
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Center(
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/oil.png",
                  height: 30,
                ),
                const Text(
                  'Petrolin',
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
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
            title: const Text('One Meter Calculator',
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: Icon(Icons.opacity_outlined, color: Colors.green.shade400),
            title: const Text(
              'Two Meter Calculator',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SecondMeter()));
            },
          ),
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationIcon: Icon(
              Icons.local_gas_station,
              color: Colors.green.shade400,
            ),
            applicationName: 'Petrolin',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2024',
          )
        ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            MyBannerAdWidget(adSize: AdSize.banner), // Uncomment if needed
            const SizedBox(height: 15),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.water_drop,
                      color: Color.fromRGBO(253, 147, 70, 1),
                    ),
                    Text(
                      'Petrol : ${petrolUsed.toStringAsFixed(2)} ltr',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/img/dollar.png",
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text('Cash : ₹${cashAvailable.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Price :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _updatePetrolPrice,
                        child: Text(
                          '₹${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('1. Petrol Meter :-',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              controller: _opening,
                              hintText: 'Opening Meter',
                              keyboardType: TextInputType.number,
                              focusNode: _openingFocusNode,
                              nextFocusNode: _closingFocusNode,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(''),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              controller: _closing,
                              hintText: 'Closing Meter',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              focusNode: _closingFocusNode,
                              nextFocusNode: _pinlabFocusNode,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '2. Petrol Meter :-',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              controller: _opening2,
                              hintText: 'Opening Meter',
                              keyboardType: TextInputType.number,
                              focusNode: _opening2FocusNode,
                              nextFocusNode: _closing2FocusNode,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(''),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              controller: _closing2,
                              hintText: 'Closing Meter',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              focusNode: _closing2FocusNode,
                              nextFocusNode: _pinlabFocusNode,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Total Card Value :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: _pinlab,
                    hintText: 'Card Value',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    focusNode: _pinlabFocusNode,
                    nextFocusNode: _onlinePaymentFocusNode,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Online Payment :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: _onlinePayment,
                    hintText: 'Online Payment',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    focusNode: _onlinePaymentFocusNode,
                    nextFocusNode: _depositCashFocusNode,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Deposit Cash :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: _depositCash,
                    hintText: 'Deposit Cash',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    focusNode: _depositCashFocusNode,
                    onEditingComplete: _calculatePetrolAndCash,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _calculatePetrolAndCash,
                  child: const Text('Enter'),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    _opening.clear();
                    _closing.clear();
                    _opening2.clear();
                    _closing2.clear();
                    _pinlab.clear();
                    _onlinePayment.clear();
                    _depositCash.clear();
                    petrolUsed = 0.0;
                    cashAvailable = 0.0;
                    setState(() {});
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Made By : Bir Mehto",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Image.asset(
                  "assets/img/india.png",
                  height: 20,
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
