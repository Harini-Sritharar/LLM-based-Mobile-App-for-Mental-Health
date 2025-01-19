class UserDataInterface {
  final String uid;
  final String firstname; // first name
  final String surname; // last name
  final String dob; // date of birth
  final String gender;
  final String zipcode;
  final String country;
  final String phoneNumber;
  final String profilePictureUrl;

  UserDataInterface({
    required this.uid,
    required this.firstname,
    required this.surname,
    required this.dob,
    required this.country,
    required this.gender,
    required this.zipcode,
    required this.phoneNumber,
    required this.profilePictureUrl,
  });
}
