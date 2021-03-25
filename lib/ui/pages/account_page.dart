import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/utils/Constants.dart';

import '../../bloc/account_page_bloc/account_page_bloc.dart';
import '../../model/get_user_response.dart';
import '../../model/message_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:krushapp/utils/zoomImage.dart';
import 'package:krushapp/utils/hero_dialog_route.dart';

import 'dart:io' as file;

import 'edit_account_details.dart';

class AccountPage extends StatefulWidget {
  Map args;
  AccountPage(this.args);

  @override
  _AccountPageState createState() => _AccountPageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _AccountPageState extends State<AccountPage>
    with TickerProviderStateMixin {
  Function wp;
  String token;
  String mobileNumber;
  file.File imageFile;
  AppState appstate;
  bool _loading_photo = false;
  DateTime _dateTime;
  static String selectedCountryName = "United States";

  final TextEditingController _emaiControl = new TextEditingController();
  final TextEditingController _lastnameControl = new TextEditingController();
  final TextEditingController _displayNameControl = new TextEditingController();
  final TextEditingController countryControl = new TextEditingController();
  final TextEditingController stateControl = new TextEditingController();
  final TextEditingController _cityControl = new TextEditingController();
  final TextEditingController zipcodeControl = new TextEditingController();

  // AccountPageBloc accountPageBloc = AccountPageBloc();

  static Country selectedCountry;

  AnimationController _imageController;
  Animation _imageAnimation;

  AnimationController _cardController;
  Animation _cardAnimation;

  String profileImageUrl = " ";
  String displayName;
  String email;
  String country;
  String _state;
  String city;
  String zipcode;
  DateTime dateOfBirth;

  UserResponse userResponse;
  getPhoneNumber() async {
    mobileNumber = await UserSettingsManager.getUserPhone();
    displayName = await UserSettingsManager.getUserName();

    setState(() {
      mobileNumber = mobileNumber;
      displayName = displayName;
    });

    context.bloc<AccountPageBloc>().add(GetAllInfo());
  }

  @override
  void initState() {
    this.userResponse = widget.args['userResponse'];

    appstate = AppState.free;

    _imageController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _imageAnimation =
        CurvedAnimation(parent: _imageController, curve: Curves.easeOutBack);

    _cardController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _cardAnimation =
        CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack);

    // getAllInfo();
    // accountPageBloc.add(GetAllInfo());

    Future.delayed(Duration(milliseconds: 500), () {
      _imageController.forward();
      Future.delayed(Duration(milliseconds: 500), () {
        _cardController.forward();
      });
    });

    getPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return BlocBuilder(
        cubit: context.bloc<AccountPageBloc>(),
        builder: (BuildContext context, AccountPageState state) {
          if (state is AllInfoLoaded) {
            profileImageUrl = state.userResponse.data.profile.profilePic ??
                Constants.defaultProfileImage;
            displayName = state.userResponse.data.profile.displayName;
            email = state.userResponse.data.user.email;
            country = state.userResponse.data.profile.country;
            _state = state.userResponse.data.profile.state;
            city = state.userResponse.data.profile.city;
            zipcode = state.userResponse.data.profile.zipcode;
            dateOfBirth = state.userResponse.data.profile.dateOfBirth;
            userResponse = state.userResponse;
          } else if (state is ProfileImageUpdated) {
            profileImageUrl = state.imageUrl ??
                Constants.defaultProfileImage;
          } else if (state is ProfileInfoUpdated) {
            profileImageUrl = state.userResponse.data.profile.profilePic ??
                Constants.defaultProfileImage;
            displayName = state.userResponse.data.profile.displayName;
            email = state.userResponse.data.user.email;
            country = state.userResponse.data.profile.country;
            _state = state.userResponse.data.profile.state;
            city = state.userResponse.data.profile.city;
            zipcode = state.userResponse.data.profile.zipcode;
            dateOfBirth = state.userResponse.data.profile.dateOfBirth;
            userResponse = state.userResponse;
          }

          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(100.0), // here the desired height
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFfe4a49),
                          Color(0xFFfe4a49),
                          Color(0xFFff6060),
                          Color(0xFFff6060),
                        ]),
                  ),
                  child: Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 30),
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.8,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 28.0,
                                height: 28.0,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_outlined,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Account Details",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .apply(color: Colors.white),
                                )
                              ],
                            ))
                          ],
                        )),
                  ),
                )),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.7, 0.9],
                colors: [
                  Color(0xFFff6060),
                  Color(0xFFff6060),
                  Color(0xFFfe4a49),
                  Color(0xFFfe4a49),
                ],
              )),
              child: state is AllInfoLoading || state is ProfileInfoLoading
                  ? Center(child: Text("Loading..."))
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: wp(2)),
                      child: Container(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ScaleTransition(
                                  scale: _imageAnimation,
                                  child: Stack(
                                    children: <Widget>[
                                      InkWell(onTap: () async {
                                            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeroPhotoViewRouteWrapper(
                  imageProvider: CachedNetworkImageProvider(
                                        profileImageUrl,
                                      ),
                  tag: "imageTag",
                  title: 'Profile Photo',
                  type: "ownPhoto",
                ),
              ),
            );

                                      },
                                      child: Hero(tag: "imageTag",
                                      child: CachedNetworkImage(
                                        imageUrl: profileImageUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          // width: 80.0,
                                          // height: 80.0,
                                          child: state is ProfileImageLoading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                )
                                              : Container(),
                                          decoration: BoxDecoration(
                                            // shape: BoxShape.circle,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      
                                      ) 
                                      ),
                                      
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: () {
                                              if (appstate == AppState.free)
                                                _pickImage();
                                              else if (appstate ==
                                                  AppState.picked)
                                                _cropImage();
                                              else if (appstate ==
                                                  AppState.cropped)
                                                _clearImage();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(15.0),
                                              child: Icon(Icons.edit),
                                            ),
                                          )),
                                    ],
                                  )),
                            ),
                            Positioned(
                                bottom: 16,
                                right: 16,
                                left: 16,
                                child: ScaleTransition(
                                  scale: _cardAnimation,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            displayName == null
                                                ? Text("")
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: AutoSizeText(
                                                        displayName,
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.5,
                                                        ),
                                                        maxLines: 1,
                                                      ),) ,
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      // Icon(
                                                      //   Icons.check_circle,
                                                      //   color: Colors.blue,
                                                      // )
                                                    ],
                                                  ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    '/EditAccountDetails',
                                                    arguments: {
                                                      'userResponse':
                                                          this.userResponse
                                                    });
                                                //                         Navigator.push(
                                                // context,
                                                // MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         EditAccountDetails(this.userResponse, context.bloc<AccountPageBloc>())));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(10.0),
                                                child: Icon(Icons.edit),
                                              ),
                                            )
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              mobileNumber ?? "",
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              email == null
                                                  ? 'Add Email'
                                                  : email,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              dateOfBirth == null
                                                  ? 'Add Date of birth'
                                                  : dateOfBirth.day.toString() +
                                                      "-" +
                                                      dateOfBirth.month
                                                          .toString() +
                                                      "-" +
                                                      dateOfBirth.year
                                                          .toString(),
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              city == null ? 'Add city' : city,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              _state == null
                                                  ? 'Add state'
                                                  : _state,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              country == null
                                                  ? 'Add Country'
                                                  : country,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5),
                                            ),
                                          ],
                                        )),
                                  ),
                                ))
                          ],
                        ),
                      )),
            ),
          );
        });
  }

  String getAvatarImage(String senderAvatar) {
    String imagUrl = "";

    int j = aviators.indexWhere((note) => note.name.contains(senderAvatar));
    imagUrl = aviators[j].imageUrl;
    return imagUrl;
  }

  _verticalDivider() => Container(
        padding: EdgeInsets.only(top: 10),
      );

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 3.0, right: 0.0, top: 0.0, bottom: 0.0),
      );

  Future<Null> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = file.File(pickedFile.path);
          appstate = AppState.picked;
        });

        _cropImage();
      }
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Photo Access Denied'),
              content: Text(
                  'Krushin requires photos access to set a profile picture.'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      AppSettings.openAppSettings();
                      Navigator.of(context).pop();
                    },
                    child: Text('Open Settings'))
              ],
            );
          },
        );
      }
    }
  }

  Future<Null> _cropImage() async {
    file.File croppedFile = (await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Theme.of(context).platform == TargetPlatform.android
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ))) as file.File;
    if (croppedFile != null) {
      imageFile = croppedFile;

      setState(() {
        appstate = AppState.cropped;
        _loading_photo = true;
      });

      _clearImage();

      setState(() {
        _loading_photo = false;
        // updateAvatar(croppedFile);
        context
            .bloc<AccountPageBloc>()
            .add(UpdateProfileImage(imageFile: croppedFile));
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      appstate = AppState.free;
    });
  }
}
