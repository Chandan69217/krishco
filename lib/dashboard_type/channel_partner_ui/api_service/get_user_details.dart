import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/models/login_details_data.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:http/http.dart' as http;


class GetUserDetails{
  GetUserDetails._();
  static Future<Map<String,dynamic>?> getUserLoginData(BuildContext context) async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,'/api/edit-details/');
      final request = http.MultipartRequest('GET', url)
      ..headers['Authorization'] = 'Bearer ${userToken}';
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        print('https Response: ${response.body}');
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }
  static Future<UserDetailsData?> getUserLoginDataInModel(BuildContext context) async{
    final dataFromAPI = await getUserLoginData(context);
    if(dataFromAPI != null){
      return LoginDetailsData.fromJson(dataFromAPI).data;
    }
    return null;
  }
}