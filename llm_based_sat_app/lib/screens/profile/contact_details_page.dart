import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llm_based_sat_app/firebase/firebase_profile.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ContactDetailsPage extends StatefulWidget {
  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index
  final VoidCallback onCompletion;

  const ContactDetailsPage(
      {Key? key,
      required this.onItemTapped,
      required this.selectedIndex,
      required this.onCompletion})
      : super(key: key);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _countryController =
      TextEditingController(text: "United Kingdom");
  final TextEditingController _zipPostalController = TextEditingController();
  String?
      selectedCountryCode; // Stores the selected country's code -> can be used to convert to obtain the country's dial code
  String? mobileNumber; // Stores the mobile number input

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Profile')
          .doc(user.uid)
          .get();
      if (!mounted) return;

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _countryController.text = data['country'] ?? 'United Kingdom';
          _zipPostalController.text = data['zipcode'] ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    _countryController.dispose();
    mobileNumber = null;
    _zipPostalController.dispose();
    super.dispose();
  }

  void _saveContactDetails() {
    print("In Save Contact Details");
    if (!_formKey.currentState!.validate() ||
        mobileNumber == null ||
        mobileNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields before saving."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    updateContactDetails(
        _countryController.text, _zipPostalController.text, mobileNumber!);
    widget.onCompletion();
    Navigator.pop(context);
  }

  // TO DO : Add validation for Zip/Postal Code
  // Not sure how to do this as of yet, Regex or API call??
  String? _validateZipPostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zip/Postal Code cannot be empty';
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number cannot be empty';
    }
    if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
      return 'Mobile number must contain 7-15 digits only';
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
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text(
                          "Contact Details",
                          style: TextStyle(
                              fontSize: 28, color: AppColours.brandBluePlusTwo),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Complete your Contact Details",
                          style: TextStyle(
                              fontSize: 15,
                              color: AppColours.neutralGreyMinusOne),
                        ),
                        const SizedBox(height: 40),
                        // TODO : Replace the map icon, globe doesn't exist in Icons
                        TextInputField(
                          label: "Country",
                          icon: Icons.map,
                          isPassword: false,
                          controller: _countryController,
                          enabled: false,
                        ),
                        const SizedBox(height: 10),
                        TextInputField(
                          label: "Zip/Postal Code",
                          icon: Icons.apartment,
                          isPassword: false,
                          controller: _zipPostalController,
                          validator: _validateZipPostalCode,
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
                            validator: (value) =>
                                _validateMobileNumber(value?.number),
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Numeric input only
                            ]),
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
