import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ContactDetailsPage extends StatefulWidget {
  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index
  const ContactDetailsPage(
      {Key? key, required this.onItemTapped, required this.selectedIndex})
      : super(key: key);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipPostalController = TextEditingController();

  String? selectedCountryCode; // Stores the selected country's code
  String? mobileNumber; // Stores the mobile number input

  @override
  void dispose() {
    _countryController.dispose();
    _zipPostalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                  title: "Personal Profile",
                  onItemTapped: widget.onItemTapped,
                  selectedIndex: widget.selectedIndex),
              const SizedBox(height: 120),
              const Text(
                "Contact Details",
                style: TextStyle(
                    fontSize: 22, color: AppColours.secondaryBlueTextColor),
              ),
              const SizedBox(height: 8),
              const Text(
                "Complete your Contact Details",
                style: TextStyle(
                    fontSize: 16, color: AppColours.primaryGreyTextColor),
              ),
              const SizedBox(height: 20),
              // TODO : Replace the map icon, globe doesn't exist in Icons
              TextInputField(
                label: "Country",
                icon: Icons.map,
                isPassword: false,
                controller: _countryController,
                enabled: false,
              ),
              const SizedBox(height: 10),
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  filled: true,
                  fillColor: AppColours.textFieldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                initialCountryCode: 'UK', // Default country
                onCountryChanged: (country) {
                  setState(() {
                    _countryController.text = country.name; // Country name
                    selectedCountryCode =
                        country.code; // ISO Code (e.g., US, IN)
                  });
                },
                onChanged: (phone) {
                  setState(() {
                    mobileNumber = phone.number; // Store the phone number
                  });
                },
              ),
              const SizedBox(height: 10),
              TextInputField(
                  label: "Zip/Postal Code",
                  icon: Icons.apartment,
                  isPassword: false,
                  controller: _zipPostalController),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              CustomButton(
                  buttonText: "Save",
                  onPress: () => {
                        // Link to upload_profile_page
                      })
            ],
          ),
        ),
      ),
    );
  }
}
