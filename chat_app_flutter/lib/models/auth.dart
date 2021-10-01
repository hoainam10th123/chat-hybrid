import 'dart:convert';
import 'package:chat_app_flutter/helper/globals.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'UserResponse.dart';
import 'package:http/http.dart' as http;

class AuthASP {
  AuthASP();

  Future<UserResponse> signIn(String userName, String password) async {
    UserResponse resp = new UserResponse();

    Map<String, dynamic> param = Map<String, dynamic>();
    param["userName"] = userName;
    param["password"] = password;

    try {
      final response = await http.post(URL_BASE + "api/Account/login",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(param));
      
      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));
        Globals.user = user;

        resp.error = '200';
        resp.user = user;
      } else {
        resp.error = response.statusCode.toString() + ' ' + response.body;
        return resp;
      }
    } catch (e) {
      resp.error = e.message;
    }
    return resp;
  }

  /*Future<UserResponse> register(UserRegister user) async {
    UserResponse resp = new UserResponse();
    user.Role = 2; //student

    Map<String, dynamic> param = Map<String, dynamic>();
    param["Email"] = user.Email;
    param["DisplayName"] = user.DisplayName;
    param["Password"] = user.Password;
    param["ConfirmPassword"] = user.ConfirmPassword;
    param["Role"] = user.Role;
    param["SchoolId"] = user.SchoolId;
    param["ClassRoomId"] = user.ClassRoomId;
    try {
      var response = await http.post(URL_BASE + "/api/Account/Register",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(param));
      if (response.statusCode == 200) {
        resp.error = '200';
      } else {
        resp.error = response.statusCode.toString() + ' ' + response.body;
      }
    } catch (e) {
      resp.error = e.message;
    }
    return resp;
  }*/
}
