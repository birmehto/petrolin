import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:patroli/Wigeds/mytextform.dart';
import 'package:patroli/Cloud_Services/ads_manger.dart';
import 'package:patroli/Wigeds/drower.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondMeter extends StatefulWidget {
  const SecondMeter({super.key});

  @override
  State<SecondMeter> createState() => _HomepageState();
}

class _HomepageState extends State<SecondMeter> {
  final TextEditingController _opening = TextEditingController();
  final TextEditingController _closing = TextEditingController();
  final TextEditingController _deselopening = TextEditingController();
  final TextEditingController _deselclosing = TextEditingController();
  final TextEditingController _pinlab = TextEditingController();
  final TextEditingController _onlinePayment = TextEditingController();
  final TextEditingController _depositCash = TextEditingController();

  double petrolUsed = 0.0;
  double cashAvailable = 0.0;
  double price = 96.45;
  double desel = 92.45; // Initial petrol price

  // Create FocusNode instances for each TextField
  final FocusNode _openingFocusNode = FocusNode();
  final FocusNode _closingFocusNode = FocusNode();
  final FocusNode _deselopeningFocusNode = FocusNode();
  final FocusNode _deselclosingFocusNode = FocusNode();
  final FocusNode _pinlabFocusNode = FocusNode();
  final FocusNode _onlinePaymentFocusNode = FocusNode();
  final FocusNode _depositCashFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose of the FocusNode instances when the widget is disposed
    _openingFocusNode.dispose();
    _closingFocusNode.dispose();
    _deselopeningFocusNode.dispose();
    _deselclosingFocusNode.dispose();
    _pinlabFocusNode.dispose();
    _onlinePaymentFocusNode.dispose();
    _depositCashFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve petrol and diesel prices from SharedPreferences
      price = prefs.getDouble('petrol_price') ?? price;
      desel = prefs.getDouble('diesel_price') ?? desel;
    });
  }

  void _calculatePetrolAndCash() {
    // Parse values from text controllers
    double openingMeter = double.tryParse(_opening.text) ?? 0;
    double closingMeter = double.tryParse(_closing.text) ?? 0;
    double opening2Meter = double.tryParse(_deselopening.text) ?? 0;
    double closing2Meter = double.tryParse(_deselclosing.text) ?? 0;
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
    if (openingMeter < closingMeter && opening2Meter < closing2Meter) {
      // Calculate petrol used
      double petrolUsedValue = closingMeter - openingMeter;

      // Calculate diesel used
      double dieselUsed = closing2Meter - opening2Meter;
      // Total petrol used
      double totalPetrolUsed = petrolUsedValue + dieselUsed;

      // Calculate cash available
      double cashAvailableValue =
          (petrolUsedValue * price + dieselUsed * desel) -
              pinlabValue -
              onlinePaymentValue -
              depositCashValue;

      // Check for negative cash value
      if (cashAvailableValue < 0) {
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

      // Update state variables
      setState(() {
        petrolUsed = totalPetrolUsed;
        cashAvailable = cashAvailableValue;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Opening meter must be less than closing meter for both Petrol and Diesel',
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
                      borderRadius: BorderRadius.circular(10),
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
                      onPressed: () async {
                        // Update petrol price from the dialog
                        price =
                            double.tryParse(newPriceController.text) ?? price;

                        // Save the new petrol price to SharedPreferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setDouble('petrol_price', price);

                        // Clear the new petrol price text field
                        newPriceController.clear();

                        // Close the dialog
                        // ignore: use_build_context_synchronously
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

  void _updateDeselPrice() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController newdeselController = TextEditingController();

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
                  'Update Desel Price',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: newdeselController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter new Desel price',
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
                      onPressed: () async {
                        // Update diesel price from the dialog
                        desel =
                            double.tryParse(newdeselController.text) ?? desel;

                        // Save the new diesel price to SharedPreferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setDouble('diesel_price', desel);

                        // Clear the new diesel price text field
                        newdeselController.clear();

                        // Update UI
                        setState(() {});

                        // Close the dialog
                        // ignore: use_build_context_synchronously
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
      drawer: const MyDrower(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            MyBannerAdWidget(adSize: AdSize.banner),
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
                        'Petrol Price :',
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
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Desel Price :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _updateDeselPrice,
                        child: Text(
                          '₹${desel.toStringAsFixed(2)}',
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
                            const Text('Petrol Meter :-',
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
                              'Desel Meter :-',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              controller: _deselopening,
                              hintText: 'Opening Meter',
                              keyboardType: TextInputType.number,
                              focusNode: _deselopeningFocusNode,
                              nextFocusNode: _deselclosingFocusNode,
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
                              controller: _deselclosing,
                              hintText: 'Closing Meter',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              focusNode: _deselclosingFocusNode,
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
                    _deselopening.clear();
                    _deselclosing.clear();
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
