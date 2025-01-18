import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';

class ContactDetailsPage extends StatefulWidget {
  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipPostalController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();

  @override
  void dispose() {
    _countryController.dispose();
    _zipPostalController.dispose();
    _mobileNoController.dispose();
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
              const SizedBox(height: 10),
              const Text(
                "Contact Details",
                style: TextStyle(fontSize: 22, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Complete your Contact Details",
                style: TextStyle(fontSize: 16, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 20),
              // TODO : Replace the map icon, globe doesn't exist in Icons
              TextInputField(
                  label: "Country",
                  icon: Icons.map,
                  isPassword: false,
                  controller: _countryController),
              const SizedBox(height: 20),
              TextInputField(
                  label: "Zip/Postal Code",
                  icon: Icons.apartment,
                  isPassword: false,
                  controller: _zipPostalController),
              const SizedBox(height: 20),
              TextInputField(
                  label: "Mobile Number",
                  icon: Icons.phone,
                  isPassword: false,
                  controller: _countryController),
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
