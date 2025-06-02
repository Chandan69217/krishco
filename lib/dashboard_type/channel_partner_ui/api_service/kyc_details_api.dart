import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';

class KYCDetailsAPI {
  final BuildContext context;
  KYCDetailsAPI._({required this.context});
  factory KYCDetailsAPI({required BuildContext context}) =>
      KYCDetailsAPI._(context: context);

  Future<Map<String, dynamic>?> getKYCDetails() async {
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,'/api/edit-kyc-details/');

      final response = await get(url,headers: {
        'Authorization' : 'Bearer ${userToken}'
      });

      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body['data'];
        }
      }else{
        print('response body: ${response.body},Status Code: ${response.statusCode}');
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }
}
