class User_ {
  String firstname; // first name
  String surname; // last name
  String dob; // date of birth
  String gender;
  String zipcode;
  String country;
  String phoneNumber;
  String profilePictureUrl;

  User_({
    // uid will be the same as the user's id in firebase
    this.firstname = '',
    this.surname = '',
    this.dob = '',
    this.country = '',
    this.gender = '',
    this.zipcode = '',
    this.phoneNumber = '',
    this.profilePictureUrl = '',
  });
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
}
