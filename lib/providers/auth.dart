import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String? _token=null;
  late DateTime _expiryDate=DateTime.now();
  late String? _userId;
  late Timer? _authTimer;


  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDWpGpvjwuHo7wQWxBEY3p4yRIYTPqz_mc");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      // autoLogOut();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  String get userId {
    return _userId==null ? '' : _userId!;
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  void logout (){
    _expiryDate=DateTime.now().subtract(Duration(seconds: 30));
    _token=null;
    _userId=null;
    // if(_authTimer !=null){
    //   _authTimer!.cancel();
    //   _authTimer=null;
    // }

    notifyListeners();
  }

  void autoLogOut(){
    if(_authTimer != null)
    {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: 3),logout);
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
