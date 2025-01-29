/// This file defines the `PaymentOptionPage` widget, which displays a user interface
/// for managing and updating payment methods. It uses a `CustomAppBar` and includes
/// fields for entering card details, as well as a button to update the payment method.

import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

import '../theme/app_colours.dart';
import '../widgets/custom_app_bar.dart';

/// A stateless widget that represents the Payment Option page.
/// This page allows users to view their current payment method and update card details.
class PaymentOptionPage extends StatelessWidget {
  // Callback function to handle navigation when items in the app bar are tapped.
  final Function(int) onItemTapped;

  // The currently selected index in the navigation bar.
  final int selectedIndex;

  /// Constructor for `PaymentOptionPage`.
  ///
  /// Requires:
  /// - [onItemTapped]: A function to handle navigation item taps.
  /// - [selectedIndex]: The index of the currently selected item in the navigation bar.
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
            // Custom app bar for the page.
            CustomAppBar(
              title: "Payment Option",
              onItemTapped: onItemTapped,
              selectedIndex: selectedIndex,
            ),
            // Section displaying the current payment method.
            const Text(
              "Current Payment Method",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColours.neutralGreyMinusOne),
            ),
            const SizedBox(height: 10),
            _buildCardWidget(), // Displays the current card details.
            const SizedBox(height: 20),
            // Section for updating the payment method.
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
            // Input fields for card details.
            _buildTextField("Card Name"),
            _buildTextField("Card Number [**** **** **** ****]"),
            _buildTextField("Expiry Date [MM/YY]"),
            _buildTextField("CVV [*3 digits]"),
            const SizedBox(height: 20),
            _buildUpdateButton(), // Button to submit the updated card details.
          ],
        ),
      ),
    );
  }

  /// Builds the widget displaying the current card details.
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
          // Placeholder card number.
          Text(
            "1234 5678 8765 0876",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          // Placeholder card validity.
          Text(
            "VALID THRU 12/28",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 10),
          // Placeholder cardholder name.
          Text(
            "TIMMY C. HERNANDEZ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a text field with the provided hint text.
  ///
  /// [hintText]: The placeholder text displayed in the field.
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

  /// Builds the update button that allows the user to submit their updated card details.
  Widget _buildUpdateButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // Placeholder for update action.
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColours.brandBlueMain,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            "Update Card",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
