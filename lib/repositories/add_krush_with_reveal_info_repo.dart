import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:krushapp/app/api.dart';
// import 'package:http/http.dart';
import '../utils/Constants.dart';

import '../model/register.dart';

class AddKrushWithRevealInfoRepo {
  String token;
  int free_requests;

  Future<Register> registerUserWithKrush(
      String krushNumberController,
      String krushName,
      String chatNameController,
      String krushCommentController,
      String userDisplayNameController,
      String genderController,
      String dobController,
      String avatarName,
      String token) async {
    return ApiClient.apiClient.registerUserWithKrush( krushNumberController,
       krushName,
       chatNameController,
       krushCommentController,
       userDisplayNameController,
       genderController,
       dobController,
       avatarName,
       );

  }
}
