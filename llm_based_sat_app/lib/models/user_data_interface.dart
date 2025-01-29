class User_ {
  String firstname = ''; // first name
  String surname = ''; // last name
  String dob = ''; // date of birth
  String gender = '';
  String zipcode = '';
  String country = '';
  String phoneNumber = '';
  String profilePictureUrl = '';
  String username = '';

  // Private constructor
  User_._internal();

  // Singleton instance
  static final User_ _instance = User_._internal();

  factory User_() {
    return _instance;
  }

  // Add methods to set or get user data
  void updateFirstName(String name) {
    firstname = name;
  }

  void updateSurname(String name) {
    surname = name;
  }

  void updateDob(String date) {
    dob = date;
  }

  void updateGender(String gender_) {
    gender = gender_;
  }

  void updateZipcode(String code) {
    zipcode = code;
  }

  void updateCountry(String country_) {
    country = country_;
  }

  void updatePhoneNumber(String number) {
    phoneNumber = number;
  }

  void updateProfilePictureUrl(String url) {
    profilePictureUrl = url;
  }

  void updateUsername(String name) {
    username = name;
  }

  bool isPersonalInfoComplete() {
    return firstname.isNotEmpty &&
        surname.isNotEmpty &&
        dob.isNotEmpty &&
        gender.isNotEmpty;
  }

  bool isContactDetailsComplete() {
    return country.isNotEmpty && zipcode.isNotEmpty && phoneNumber.isNotEmpty;
  }

  bool isProfilePictureComplete() {
    return profilePictureUrl.isNotEmpty;
  }
}
