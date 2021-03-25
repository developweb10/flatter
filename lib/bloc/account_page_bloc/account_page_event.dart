
part of 'account_page_bloc.dart';

@immutable
abstract class AccountPageEvent {}

class UpdateInfo extends AccountPageEvent {
  
  String displayName;
  String email;
  String dateTime;
  String selectedCountryName;
  String state;
  String city;
  String zipcodeControl;

  UpdateInfo(
      this.displayName,
      this.email,
      this.dateTime,
      this.selectedCountryName,
      this.state,
      this.city,
      this.zipcodeControl);
}

class UpdateProfileImage extends AccountPageEvent {
  final file.File imageFile;
  UpdateProfileImage({
    this.imageFile
  });
}

// class GetInfo extends AccountPageEvent {
//   String token;
//   String displayName;
//   String email;
//   String dateTime;
//   String selectedCountryName;
//   String state;
//   String city;
//   String zipcodeControl;

//   GetInfo(
//       {this.token,
//       this.displayName,
//       this.email,
//       this.dateTime,
//       this.selectedCountryName,
//       this.state,
//       this.city,
//       this.zipcodeControl});
// }

class GetAllInfo extends AccountPageEvent {


  GetAllInfo();


// class UpdateProfileLoaded extends AccountPageEvent {
//   final String imageFile;
//   UpdateProfileLoaded({
//     this.imageFile,
//   });
}