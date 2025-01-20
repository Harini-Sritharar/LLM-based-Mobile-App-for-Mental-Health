import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

import '../widgets/custom_app_bar.dart';

class PaymentOptionPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const PaymentOptionPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: "Payment Option", onItemTapped: onItemTapped, selectedIndex: selectedIndex),
            const Text(
              "Current Payment Method",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColours.neutralGreyMinusOne),
            ),
            const SizedBox(height: 10),
            _buildCardWidget(),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text("Update Payment Method",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColours.brandBluePlusTwo)),
                SizedBox(width: 5),
                Icon(Icons.info_outline, color: AppColours.brandBluePlusTwo),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField("Card Name"),
            _buildTextField("Card Number [**** **** **** ****]"),
            _buildTextField("Expiry Date [MM/YY]"),
            _buildTextField("CVV [*3 digits]"),
            const SizedBox(height: 20),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColours.brandBluePlusTwo,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "1234 5678 8765 0876",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text("VALID THRU 12/28",
              style: TextStyle(fontSize: 14, color: Colors.white)),
          SizedBox(height: 10),
          Text("TIMMY C. HERNANDEZ",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColours.brandBlueMain,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text("Update Card",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
