import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase_profile.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

class PersonalInfoPage extends StatefulWidget {
  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index
  const PersonalInfoPage(
      {Key? key, required this.onItemTapped, required this.selectedIndex})
      : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _dobController.dispose();
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
              const SizedBox(height: 10),
              const Text(
                "Personal Info",
                style: TextStyle(fontSize: 22, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Complete your Personal Information",
                style: TextStyle(fontSize: 16, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 20),
              _buildTextField("Name", _nameController),
              const SizedBox(height: 20),
              _buildTextField("Surname", _surnameController),
              const SizedBox(height: 20),
              _buildDatePickerField(),
              const SizedBox(height: 20),
              _buildGenderDropdown(),
              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFD0E0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return TextField(
      controller: _dobController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Date of Birth",
        filled: true,
        fillColor: const Color(0xFFD0E0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                _dobController.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD0E0F0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        hint: const Text("Gender"),
        items: ["Male", "Female", "Other"]
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            updatePersonalInfo(_nameController.text, _surnameController.text,
                _dobController.text, _selectedGender!);
            // After info saved to database navigate back to personal profile page
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C548C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
