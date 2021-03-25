import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:krushapp/app/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';
import '../model/get_user_response.dart';
import '../utils/Constants.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:image/image.dart' as Image;


class AccountRepository {

Future<String> submitSubscription({File file,String filename,String token})async{
    ///MultiPart request
    var request = http.MultipartRequest(
        'POST', Uri.parse("${ApiClient.apiClient.baseUrl}/update_user_profile_pic"),

    );
    Map<String,String> headers={
      "Authorization":"Bearer $token",
      "Content-type": "multipart/form-data"
    };
    request.files.add(
        http.MultipartFile(
           'profilePic',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: filename,
        ),
    );
    request.headers.addAll(headers);
    
    print("request: "+request.toString());
    var res = await request.send();
    print("This is response:"+res.toString());

    if (res.statusCode == 401){
      String newToken = await ApiClient.apiClient.getRefreshToken();
      return submitSubscription(file:file,  filename: filename, token: newToken);
    }
    return await res.stream.transform(utf8.decoder).join();
  }




  Future<String> updateProfileImage(File imageFile, String token) async {
    try {

      Dio dio = new Dio();

      dio.options.headers["Authorization"] = "Bearer " + token;
      dio.options.contentType = 'multipart/form-data';
      dio.options.baseUrl = '${ApiClient.apiClient.baseUrl}';

      if (imageFile != null) {
   
   
        Image.Image image = Image.decodeImage(imageFile.readAsBytesSync());
        Image.Image resizedImage;
       
       
        if (image.width > image.height) {
          resizedImage = Image.copyResize(image, height: 480);
        } else {
          resizedImage = Image.copyResize(image, width: 480);
        }
        var cacheDir = await getTemporaryDirectory();

        String filePath = path.join(cacheDir.path,
            '${path.basenameWithoutExtension(imageFile.path)}.jpg');
        
        
        File resizedImageFile =
            await File(filePath).writeAsBytes(Image.encodeJpg(resizedImage));

        // FormData formData = FormData.fromMap({
        //   "profilePic": await MultipartFile.fromFile(resizedImageFile.path),
        // });

        // response = await dio.post("/update_user_profile_pic", data: formData);
        String response =  await submitSubscription(file:resizedImageFile,  filename: path.basenameWithoutExtension(imageFile.path), token: token);
        
        return json.decode(response)['data']['path'].toString();
      }
    } catch (e) {
      print('upadte profile image error $e');
    }
  }

  Future<UserResponse> updateInfo(
      String displayName,
      String email,
      String dateTime,
      String selectedCountryName,
      String state,
      String city,
      String zipcodeControl) async {
    UserResponse snapshot = await ApiClient.apiClient.updateUser( displayName, email,
            dateTime, selectedCountryName, state, city, zipcodeControl);
      
      
        if (snapshot.status) {
          return snapshot;
        } else {
          return null;
        }
      }
    
      Future<UserResponse> getAllInfo() async {
        UserResponse userResponse =
            await ApiClient.apiClient.getUser();
        // setState(() {
        //   profileImageUrl = userResponse.data.profile.profilePic ?? "https://ramcotubular.com/wp-content/uploads/default-avatar.jpg";
        //   displayName = userResponse.data.profile.displayName;
        //   email = userResponse.data.user.email;
        //   country = userResponse.data.profile.country;
        //   _state = userResponse.data.profile.state;
        //   city = userResponse.data.profile.city;
        //   zipcode = userResponse.data.profile.zipcode;
        //   dateOfBirth = userResponse.data.profile.dateOfBirth;
    
        //   UserSettingsManager.setUserName(displayName ?? null);
        //   UserSettingsManager.setEmail(email ?? null);
        //   UserSettingsManager.setUserImage(profileImageUrl ?? null);
        //   UserSettingsManager.setUserDOB(dateOfBirth.toString() ?? null);
        // });
        return userResponse;
      }
    
    
    
    
    
    
    
    
    
    
}
