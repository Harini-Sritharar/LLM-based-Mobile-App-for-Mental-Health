/// A singleton class that stores user information.
/// This class ensures that only one instance of the user data exists
/// throughout the application, and provides methods to manage user information.
class User_ {
  /// The user's first name.
  String firstname = '';

  /// The user's last name (surname).
  String surname = '';

  /// The user's date of birth in string format (e.g., "YYYY-MM-DD").
  String dob = '';

  /// The user's gender.
  String gender = '';

  /// The user's postal code or ZIP code.
  String zipcode = '';

  /// The user's country.
  String country = '';

  /// The user's phone number.
  String phoneNumber = '';

  /// The URL of the user's profile picture.
  String profilePictureUrl = '';

  /// The user's username.
  String username = '';

  /// Private constructor for the singleton pattern.
  /// This constructor ensures that the class can only be instantiated
  /// once throughout the application.
  User_._internal();

  /// The singleton instance of the [User_] class.
  static final User_ _instance = User_._internal();

  /// Factory constructor that returns the singleton instance of the [User_] class.
  ///
  /// This ensures that there is only one instance of the [User_] class throughout
  /// the application.
  factory User_() {
    return _instance;
  }

  /// Updates the user's first name.
  ///
  /// [name] - The new first name to be set for the user.
  void updateFirstName(String name) {
    firstname = name;
  }

  /// Updates the user's surname (last name).
  ///
  /// [name] - The new surname to be set for the user.
  void updateSurname(String name) {
    surname = name;
  }

  /// Updates the user's date of birth.
  ///
  /// [date] - The new date of birth to be set for the user (in string format).
  void updateDob(String date) {
    dob = date;
  }

  /// Updates the user's gender.
  ///
  /// [gender_] - The new gender to be set for the user.
  void updateGender(String gender_) {
    gender = gender_;
  }

  /// Updates the user's postal code (ZIP code).
  ///
  /// [code] - The new postal code to be set for the user.
  void updateZipcode(String code) {
    zipcode = code;
  }

  /// Updates the user's country.
  ///
  /// [country_] - The new country to be set for the user.
  void updateCountry(String country_) {
    country = country_;
  }

  /// Updates the user's phone number.
  ///
  /// [number] - The new phone number to be set for the user.
  void updatePhoneNumber(String number) {
    phoneNumber = number;
  }

  /// Updates the URL of the user's profile picture.
  ///
  /// [url] - The new URL to be set for the user's profile picture.
  void updateProfilePictureUrl(String url) {
    profilePictureUrl = url;
  }

  /// Updates the user's username.
  ///
  /// [name] - The new username to be set for the user.
  void updateUsername(String name) {
    username = name;
  }

  /// Checks if the user's personal information (first name, surname, date of birth, and gender) is complete.
  ///
  /// Returns `true` if all personal information fields are filled, otherwise returns `false`.
  bool isPersonalInfoComplete() {
    return firstname.isNotEmpty &&
        surname.isNotEmpty &&
        dob.isNotEmpty &&
        gender.isNotEmpty;
  }

  /// Checks if the user's contact details (country, ZIP code, and phone number) are complete.
  ///
  /// Returns `true` if all contact details fields are filled, otherwise returns `false`.
  bool isContactDetailsComplete() {
    return country.isNotEmpty && zipcode.isNotEmpty && phoneNumber.isNotEmpty;
  }

  /// Checks if the user's profile picture is complete.
  ///
  /// Returns `true` if the profile picture URL is not empty, otherwise returns `false`.
  bool isProfilePictureComplete() {
    return profilePictureUrl.isNotEmpty;
  }
}
