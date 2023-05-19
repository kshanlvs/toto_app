import 'package:shared_preferences/shared_preferences.dart';

class TokenService  {
  static Future<void> storeToken(String token) async {
  final pref = await SharedPreferences.getInstance();
  await pref.setString('token', token);


}

static Future<String?> getToken() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getString('token');
}

static Future<String?> deleteToken() async {
  final pref = await SharedPreferences.getInstance();
  pref.remove("token");
 
}

}