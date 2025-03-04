import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llm_based_sat_app/firebase/firebase_profile.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

/// A page where users can input and save their contact details, including
/// country, zip/postal code, and mobile number. The page retrieves the user's
/// existing data from Firebase and allows them to edit and save the information.
class ContactDetailsPage extends StatefulWidget {
  final Function(int)
      onItemTapped; // Callback function to update the navbar index
  final int selectedIndex; // Tracks the selected index of the navbar
  final VoidCallback onCompletion; // Callback function to indicate completion

  const ContactDetailsPage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.onCompletion,
  }) : super(key: key);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final _formKey = GlobalKey<FormState>(); // Key to manage form validation
  Key phoneFieldKey = UniqueKey(); // Unique key for the phone field widget
  final TextEditingController _countryController = TextEditingController(
      text: "United Kingdom"); // Controller for country input
  final TextEditingController _zipPostalController =
      TextEditingController(); // Controller for Zip/Postal Code input
  final TextEditingController _mobileController =
      TextEditingController(); // Controller for mobile number input
  String mobileNumber = ''; // Stores the mobile number input by the user
  String dialCode = '44'; // Default dial code for the UK
  String selectedCountryISO = 'GB'; // Default ISO country code for the UK

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Loads existing user data from Firebase when the page is initialized
  }

  /// Loads the user's existing contact details from Firestore.
  /// If the user has a stored phone number, country, and zipcode, they are populated in the form fields.
  void _loadUserData() async {
    User? user =
        FirebaseAuth.instance.currentUser; // Get the current Firebase user
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(
              'Profile') // Fetch the user's profile document from Firestore
          .doc(user.uid)
          .get();
      if (!mounted) return;

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Extract phone number and dial code from the stored data
        String fullPhone = data['phoneNumber'] ?? '';
        if (fullPhone.isNotEmpty) {
          mobileNumber = fullPhone.substring(
              fullPhone.indexOf(' ') + 1); // Extract the phone number
          dialCode = fullPhone.split(' ')[0]; // Extract the dial code
        }

        String storedCountry = data['country'] ?? 'United Kingdom';

        // Get the ISO code for the country from the country name
        String? countryISO = _getISOCodeFromCountryName(storedCountry);
        print("Country ISO: $countryISO");

        if (!mounted) return;
        setState(() {
          _countryController.text =
              storedCountry; // Set the country in the controller
          _zipPostalController.text = data['zipcode'] ?? ''; // Set the zipcode
          _mobileController.text = mobileNumber; // Set the mobile number
          selectedCountryISO = _getISOCodeFromCountryName(storedCountry) ??
              'GB'; // Set the ISO code
          phoneFieldKey =
              UniqueKey(); // Generate a new unique key for phone field to reset its state
        });
      }
    }
  }

  /// Converts the country name to its corresponding ISO 2-letter code.
  /// This is used for setting the initial country selection in the phone input field.
  String? _getISOCodeFromCountryName(String countryName) {
    for (var country in CountryCodes.countryCodes()) {
      if (country.localizedName?.toLowerCase() == countryName.toLowerCase()) {
        return country.alpha2Code; // Returns ISO 2-letter code (e.g., "GB")
      }
    }
    return null; // Return null if the country name is not found
  }

  @override
  void dispose() {
    // Clean up the controllers when the page is disposed
    _countryController.dispose();
    mobileNumber = '';
    dialCode = '';
    _zipPostalController.dispose();
    super.dispose();
  }

  /// Saves the user's contact details, including the country, zip code, and mobile number.
  /// This function validates the form and updates the Firestore profile document with the new data.
  void _saveContactDetails() {
    print("In Save Contact Details");

    // Check if the form is valid and the mobile number is not empty
    if (!_formKey.currentState!.validate() || mobileNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields before saving."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String fullPhoneNumber =
        "$dialCode $mobileNumber"; // Concatenate dial code and mobile number
    updateContactDetails(
        _countryController.text, _zipPostalController.text, fullPhoneNumber);
    widget
        .onCompletion(); // Call the completion callback to notify parent widget
    Navigator.pop(context); // Close the contact details page
  }

  /// Validator for Zip/Postal code field.
  /// This is a placeholder for future zip/postal code validation.
  String? _validateZipPostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zip/Postal Code cannot be empty'; // Return error if empty
    }
    return null; // Return null if valid
  }

  /// Validator for mobile number field.
  /// Checks if the number is empty or doesn't match the required format (7-15 digits).
  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number cannot be empty'; // Return error if empty
    }
    if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
      return 'Mobile number must contain 7-15 digits only'; // Return error for invalid format
    }
    return null; // Return null if valid
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
                  title:
                      "Personal Profile", // Custom app bar with title and navbar functionality
                  onItemTapped: widget.onItemTapped,
                  selectedIndex: widget.selectedIndex),
              const SizedBox(height: 120),
              Form(
                key: _formKey, // Form key to manage form validation
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Contact Details",
                        style: TextStyle(
                          fontSize: 28,
                          color: AppColours.brandBluePlusTwo,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Complete your Contact Details",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColours.neutralGreyMinusOne,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Text input field for the country (read-only)
                      TextInputField(
                        label: "Country",
                        icon: Icons.map, // Placeholder for the country icon
                        isPassword: false,
                        controller: _countryController,
                        enabled: false, // Disabled as country is pre-selected
                      ),
                      const SizedBox(height: 10),
                      // Text input field for Zip/Postal Code
                      TextInputField(
                        label: "Zip/Postal Code",
                        icon: Icons.apartment,
                        isPassword: false,
                        controller: _zipPostalController,
                        validator: _validateZipPostalCode,
                      ),
                      const SizedBox(height: 10),
                      // Phone input field with international phone number support
                      IntlPhoneField(
                        key: phoneFieldKey,
                        controller: _mobileController,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          filled: true,
                          fillColor: AppColours.brandBlueMinusFour,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        initialCountryCode: selectedCountryISO,
                        initialValue:
                            mobileNumber.replaceFirst(dialCode, '').trim(),
                        onCountryChanged: (country) {
                          setState(() {
                            _countryController.text =
                                country.name; // Update country
                            dialCode = country.dialCode; // Update dial code
                          });
                        },
                        onChanged: (phone) {
                          setState(() {
                            mobileNumber = phone.number; // Update mobile number
                          });
                        },
                        keyboardType:
                            TextInputType.phone, // Phone number keyboard
                        validator: (value) =>
                            _validateMobileNumber(value?.number),
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Only allow digits
                        ],
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 40),
                      // Custom save button to save the contact details
                      CustomButton(
                        buttonText: "Save",
                        onPress:
                            _saveContactDetails, // Save action when pressed
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
