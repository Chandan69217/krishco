import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';


class EditDetails {
  EditDetails._();

  // static Future<Map<String, dynamic>?> updateDetails(
  //     BuildContext context, {
  //       File? profile,
  //       required String first_name,
  //       required String t_id,
  //       required String gst_no,
  //       String last_name = '',
  //       required String contact_no,
  //       String alt_contact_no = '',
  //       String email = '',
  //       required String dob,
  //       required String gender,
  //       required String marital_status,
  //       String anni_date = '',
  //       required String country,
  //       required String state,
  //       required String district,
  //       required String city,
  //       required String pincode,
  //       required String address,
  //       required List<Map<String, dynamic>> emergency_details,
  //     }) async {
  //   final userToken = Pref.instance.getString(Consts.user_token);
  //   try {
  //     final url = Uri.https(Urls.base_url, '/api/edit-details/');
  //
  //     final request = http.MultipartRequest('POST', url)
  //       ..headers['Authorization'] = 'Bearer $userToken'
  //       ..fields['fname'] = first_name
  //       ..fields['lname'] = last_name
  //       ..fields['alt_cont_no'] = alt_contact_no
  //       ..fields['contact_no'] = contact_no
  //       ..fields['dob'] = dob
  //       ..fields['gender'] = gender
  //       ..fields['mar_status'] = marital_status
  //       ..fields['ann_date'] = anni_date
  //       ..fields['email'] = email
  //       ..fields['address'] = address
  //       ..fields['city'] = city
  //       ..fields['state'] = state
  //       ..fields['pin'] = pincode
  //       ..fields['country'] = country
  //       ..fields['dist'] = district
  //       ..fields['t_id'] = t_id
  //       ..fields['gst_no'] = gst_no
  //       ..fields['emergency_contact_details'] = jsonEncode(emergency_details);
  //
  //     if (profile != null) {
  //       final mimeType = profile.path.toLowerCase().endsWith('.png')
  //           ? MediaType('image', 'png')
  //           : MediaType('image', 'jpeg');
  //
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'profile', // ✅ corrected field name
  //           profile.path,
  //           contentType: mimeType,
  //         ),
  //       );
  //     }
  //
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return jsonDecode(response.body) as Map<String, dynamic>;
  //     } else {
  //       print('Request failed: ${response.statusCode} -> ${response.body}');
  //       handleHttpResponse(context, response);
  //     }
  //   } catch (exception, trace) {
  //     print('Exception: $exception, Trace: $trace');
  //   }
  //   return null;
  // }

  static Future<Map<String, dynamic>?> updateDetails(
      BuildContext context, {
        File? profile,
        File? gst_copy,
        required String first_name,
        required List<String> t_id,
        String? gst_no,
        String? last_name,
        required String contact_no,
        String? alt_contact_no,
        String? email,
        required String dob,
        required String gender,
        required String marital_status,
        String? anni_date,
        required String country,
        required String state,
        required String district,
        required String city,
        required String pincode,
        String? address,
        required List<Map<String, dynamic>> emergency_details,
      }) async {
    final userToken = Pref.instance.getString(Consts.user_token);
    try {
      final url = Uri.https(Urls.base_url, '/api/edit-details/');

      String? base64Profile;
      if (profile != null) {
        final extension = profile.path.split('.').last.toLowerCase();
        if(['png', 'jpg', 'jpeg'].contains(extension)){
          final bytes = await profile.readAsBytes();
          final mediaType = extension == 'png' ? 'image/png' : 'image/jpeg';
          base64Profile = 'data:$mediaType;base64,${base64Encode(bytes)}';
        }else{
          print('Invalid Profile Picture');
        }
        print('Profile Base64:${base64Profile} ');
      }

      String? base64GSTCopy;
      if(gst_copy != null){
        final bytes = await gst_copy.readAsBytes();
        base64GSTCopy = base64Encode(bytes);
      }

      final body = {
        'fname': first_name,
        'lname': last_name,
        'alt_cont_no': alt_contact_no,
        'contact_no': contact_no,
        'dob': dob,
        'gender': gender,
        'mar_status': marital_status,
        'ann_date': anni_date,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'pin': pincode,
        'country': country,
        'dist': district,
        't_id': t_id,
        'gst_no': gst_no,
        'gst_copy':base64GSTCopy,
        'emergency_contact_details': emergency_details,
        'photo': base64Profile,
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Request failed: ${response.statusCode} -> ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Request failed: ${response.statusCode} -> ${response.body}');
        handleHttpResponse(context, response);
      }
    } catch (e, s) {
      print('Exception: $e\n$s');
    }

    return null;
  }

  // static Future<Map<String, dynamic>?> updateDetails(
  //     BuildContext context, {
  //       File? profile,
  //       required String first_name,
  //       required String t_id,
  //       required String gst_no,
  //       String last_name = '',
  //       required String contact_no,
  //       String alt_contact_no = '',
  //       String email = '',
  //       required String dob,
  //       required String gender,
  //       required String marital_status,
  //       String anni_date = '',
  //       required String country,
  //       required String state,
  //       required String district,
  //       required String city,
  //       required String pincode,
  //       required String address,
  //       required List<Map<String, dynamic>> emergency_details,
  //     }) async {
  //   final userToken = Pref.instance.getString(Consts.user_token);
  //
  //   try {
  //     final url = Uri.https(Urls.base_url, '/api/edit-details/');
  //
  //     final request = http.MultipartRequest('POST', url);
  //     request.headers['Authorization'] = 'Bearer $userToken';
  //
  //     // Add text fields
  //     request.fields.addAll({
  //       'fname': first_name,
  //       'lname': last_name,
  //       'alt_cont_no': alt_contact_no,
  //       'contact_no': contact_no,
  //       'dob': dob,
  //       'gender': gender,
  //       'mar_status': marital_status,
  //       'ann_date': anni_date,
  //       'email': email,
  //       'address': address,
  //       'city': city,
  //       'state': state,
  //       'pin': pincode,
  //       'country': country,
  //       'dist': district,
  //       'gst_no': gst_no,
  //     });
  //
  //     // t_id and emergency_details should be sent as JSON strings
  //     request.fields['t_id'] = jsonEncode([t_id]);
  //     request.fields['emergency_contact_details'] = jsonEncode(emergency_details);
  //
  //     // Attach file if available
  //     if (profile != null) {
  //       final mimeType = lookupMimeType(profile.path) ?? 'image/jpeg';
  //       final fileStream = http.ByteStream(profile.openRead());
  //       final fileLength = await profile.length();
  //
  //       request.files.add(http.MultipartFile(
  //         'photo', // ✅ field name expected by backend
  //         fileStream,
  //         fileLength,
  //         filename: profile.path.split('/').last,
  //         contentType: MediaType.parse(mimeType),
  //       ));
  //     }
  //
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //
  //     print('Status Code: ${response.statusCode}');
  //     print('Response Body: ${response.body}');
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return jsonDecode(response.body) as Map<String, dynamic>;
  //     } else {
  //       handleHttpResponse(context, response);
  //     }
  //   } catch (e, s) {
  //     print('Exception in updateDetails: $e');
  //     print('Stack trace: $s');
  //   }
  //
  //   return null;
  // }


}
