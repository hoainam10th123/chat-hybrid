import 'user.dart';


class UserResponse {
  User user;
  String error;

  UserResponse();
  UserResponse.mock(User user): user  = user,error = "";
}