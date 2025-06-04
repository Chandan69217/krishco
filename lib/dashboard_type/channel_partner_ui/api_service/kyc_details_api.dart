import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/channel_partner_kyc_screen.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';

class KYCDetailsAPI {
  final BuildContext context;
  KYCDetailsAPI._({required this.context});
  factory KYCDetailsAPI({required BuildContext context}) =>
      KYCDetailsAPI._(context: context);

  Future<Map<String, dynamic>?> getKYCDetails() async {
    final userToken = Pref.instance.getString(Consts.user_token);
    try {
      final url = Uri.https(Urls.base_url, '/api/edit-kyc-details/');

      final response = await get(
        url,
        headers: {'Authorization': 'Bearer ${userToken}'},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final status = body['isScuss'];
        if (status) {
          return body['data'];
        }
      } else {
        print(
          'response body: ${response.body},Status Code: ${response.statusCode}',
        );
        handleHttpResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateOrCreateKYC({
    required List<ProofModel> idProofs,
    required List<ProofModel> addressProofs,
    required Map<String, dynamic> bankDetails,
  }) async {
    final userToken = Pref.instance.getString(Consts.user_token);


    try {
      final url = Uri.https(Urls.base_url, '/api/edit-kyc-details/');
      final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $userToken';

      if (idProofs.isNotEmpty) {
        idProofs.forEach((p) async {
          switch (p.type) {
            case 'Pan Card':
              request.fields['id_pan'] = p.idNumber;
              if(p.frontImage != null) request.files.add(
                await http.MultipartFile.fromPath(
                  'id_pan_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                'id_pan_back',
                p.backImage!.path
              ));
              break;
            case 'Aadhaar Card':
              request.fields['id_aadhar'] = p.idNumber;
              if(p.frontImage != null) request.files.add(
                await http.MultipartFile.fromPath(
                  'id_aadhar_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                  'id_aadhar_back',
                  p.backImage!.path
              ));
              break;
            case 'Passport':
              request.fields['id_pass'] = p.idNumber;
              if(p.frontImage != null) request.files.add(
                await http.MultipartFile.fromPath(
                  'id_pass_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                  'id_pass_back',
                  p.backImage!.path
              ));
              break;
            case 'Voter ID':
              request.fields['id_voter'] = p.idNumber;
              if(p.frontImage != null)  request.files.add(
                await http.MultipartFile.fromPath(
                  'id_voter_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                  'id_voter_back',
                  p.backImage!.path
              ));
              break;
            case 'Driving License':
              request.fields['id_dl'] = p.idNumber;
              if(p.frontImage != null) request.files.add(
                await http.MultipartFile.fromPath(
                  'id_dl_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                  'id_dl_back',
                  p.backImage!.path
              ));
              break;
          }
        });
      }

      if(addressProofs.isNotEmpty){
        addressProofs.forEach((p)async{
          switch(p.type){
            case 'Aadhaar Card':
              request.fields['add_aadhar'] = p.idNumber;
              if(p.frontImage != null) request.files.add(
                await http.MultipartFile.fromPath(
                  'add_aadhar_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                  'add_aadhar_back',
                  p.backImage!.path
              ));
              break;
            case 'Bank Passbook':
              request.fields['add_pass'] = p.idNumber;
              if(p.frontImage != null) request.files.add(
                await http.MultipartFile.fromPath(
                  'add_pass_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                  'add_pass_back',
                  p.backImage!.path
              ));
              break;
            case 'Gas Bill':
              request.fields['add_gas'] = p.idNumber;
              if(p.frontImage != null) request.files.add(
                await http.MultipartFile.fromPath(
                  'add_gas_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                  'add_gas_back',
                  p.backImage!.path
              ));
              break;
            case 'Electricity Bill':
              request.fields['add_electricity'] = p.idNumber;
              if(p.frontImage != null) request.files.add(
                await http.MultipartFile.fromPath(
                  'add_electricity_front',
                  p.frontImage!.path,
                ),
              );
              if(p.backImage != null) request.files.add(await http.MultipartFile.fromPath(
                  'add_electricity_back',
                  p.backImage!.path
              ));
              break;
          }
        });
      }

      bankDetails.forEach((key,value)async{
        if(value != null){
          request.fields[key] = value;
        }
      });

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      if(response.statusCode == 200 || response.statusCode == 201){
       return json.decode(response.body) as Map<String,dynamic>;
      }else{
        print(' Response: ${response.body} with status code: ${response.statusCode}');
        handleHttpResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: $exception , Trace: $trace');
    }
    return null;
  }
}
