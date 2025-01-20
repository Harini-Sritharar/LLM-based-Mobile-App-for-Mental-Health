import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llm_based_sat_app/models/user_data_interface.dart';
import 'package:llm_based_sat_app/screens/personal_profile_page.dart';
import 'package:llm_based_sat_app/screens/upload_profile_picture_page.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _countryController =
      TextEditingController(text: "United Kingdom");
  final TextEditingController _zipPostalController = TextEditingController();
  final User_ user = User_();
  String?
      selectedCountryCode; // Stores the selected country's code -> can be used to convert to obtain the country's dial code
  String? mobileNumber; // Stores the mobile number input

  @override
  void dispose() {
    _countryController.dispose();
    mobileNumber = null;
    _zipPostalController.dispose();
    super.dispose();
  }

  void _saveContactDetails() {
    if (_formKey.currentState!.validate()) {
      user.updateCountry(_countryController.text);
      user.updateZipcode(_zipPostalController.text);
      user.updatePhoneNumber(mobileNumber!);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PersonalProfilePage()));
    }
  }

  // TO DO : Add validation for Zip/Postal Code
  // Not sure how to do this as of yet, Regex or API call??
  String? _validateZipPostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zip/Postal Code cannot be empty';
    }
    return null;
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
              Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    const Text(
                      "Contact Details",
                      style: TextStyle(
                          fontSize: 22,
                          color: AppColours.brandBluePlusTwo),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Complete your Contact Details",
                      style: TextStyle(
                          fontSize: 16, color: AppColours.neutralGreyMinusOne),
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
                          fillColor: AppColours.brandBlueMinusFour,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        initialCountryCode: "GB",
                        onCountryChanged: (country) {
                          setState(() {
                            _countryController.text =
                                country.name; // Country name
                            selectedCountryCode =
                                country.code; // ISO Code (e.g., US, IN)
                          });
                        },
                        onChanged: (phone) {
                          setState(() {
                            mobileNumber =
                                phone.number; // Store the phone number
                          });
                        },
                        keyboardType:
                            TextInputType.phone, // Ensures phone keyboard
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Numeric input only
                        ]),
                    const SizedBox(height: 10),
                    TextInputField(
                      label: "Zip/Postal Code",
                      icon: Icons.apartment,
                      isPassword: false,
                      controller: _zipPostalController,
                      validator: _validateZipPostalCode,
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 40),
                    CustomButton(
                        buttonText: "Save", onPress: _saveContactDetails)
                  ])))
            ],
          ),
        ),
      ),
    );
  }
}
