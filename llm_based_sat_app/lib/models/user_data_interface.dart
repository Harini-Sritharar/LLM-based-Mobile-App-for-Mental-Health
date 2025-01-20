class User_ {
  late String firstname; // first name
  late String surname; // last name
  late String dob; // date of birth
  late String gender;
  late String zipcode;
  late String country;
  late String phoneNumber;
  late String profilePictureUrl;
  late String username;

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
}