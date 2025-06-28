import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:krishco/dashboard_type/dashboard_types.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/models/kyc_proof_related/kyc_proof_model.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:http_parser/http_parser.dart';
import 'package:krishco/api_services/handle_https_response.dart';




class APIService{
  static APIService? _instance;
  final BuildContext context;

  late final _ProductDetails productDetails;
  late final _TaggedEnterprise taggedEnterprise;
  late final _GroupDetails groupDetails;
  late final _OrderRelated orderRelated;
  late final _InvoiceClaim invoiceClaim;
  late final _ChangePassword changePassword;
  late final _TransportationRelated transportationDetails;
  late final _EditDetails editDetails;
  late final _GetUserDetails getUserDetails;
  late final _KYCDetailsAPI kycDetailsAPI;
  late final _WarrantyRelated warrantyRelated;
  late final _ConsumersGroup consumersGroup;
  late final _ProductCatalogues productCatalogues;

  APIService._internal({required this.context}){
    productDetails = _ProductDetails(context: context);
    taggedEnterprise = _TaggedEnterprise(context: context);
    groupDetails = _GroupDetails(context: context);
    orderRelated = _OrderRelated(context: context);
    invoiceClaim = _InvoiceClaim(context: context);
    changePassword = _ChangePassword(context: context);
    transportationDetails = _TransportationRelated(context: context);
    editDetails = _EditDetails(context: context);
    getUserDetails = _GetUserDetails(context: context);
    kycDetailsAPI = _KYCDetailsAPI(context: context);
    warrantyRelated = _WarrantyRelated(context:context);
    consumersGroup = _ConsumersGroup(context:context);
    productCatalogues = _ProductCatalogues(context: context);
  }

  static APIService getInstance(BuildContext context){
    _instance ??= APIService._internal(context: context);
    return _instance!;
  }

  static void resetInstance(){
    _instance = null;
  }


}



class _ProductDetails{
  final BuildContext context;
  _ProductDetails({required this.context});

  Future<Map<String,dynamic>?> getProductCategory() async {
    String token = Pref.instance.getString(Consts.user_token) ?? '';

    try {
      var uri = Uri.https(Urls.base_url,Urls.product_catagory);

      var response = await get(uri, headers: {
        'authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var rawData = json.decode(response.body);
        bool isSuccess = rawData['isScuss'] ?? false;
        if (isSuccess) {
           return rawData;
        } else {
          print('API error: ${rawData['messages']}');
        }
      } else{
        handleHttpResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: $exception, Trace: $trace');
    }
    return null;
  }

  Future<Map<String,dynamic>?> getProdDetailsByProductID(String productId,)async{
    final userToken = Pref.instance.getString(Consts.user_token);

    try {
      final uri = Uri.https(Urls.base_url, "${Urls.product_details_by_id}/$productId/");
      final response = await get(uri, headers: {
        'Authorization': 'Bearer $userToken',
      });
      if (response.statusCode == 200){
        final body = jsonDecode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      } else {
        handleHttpResponse(context, response);
        print("error while fetching product details: Status Code: ${response.statusCode} , Reason: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

}

class _TaggedEnterprise{
  final BuildContext context;
  _TaggedEnterprise({required this.context});

  Future<Map<String,dynamic>?> getTaggedEnterpriseOfLoginCustomer()async{
    final userToken = Pref.instance.getString(Consts.user_token);

    try{
      final url = Uri.https(Urls.base_url,Urls.tagged_enterprise_of_login_customer);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer ${userToken}'
      });

      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        return body;
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String,dynamic>?> getTaggedEnterprisedByNumber(String number)async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,Urls.tagged_enterprise_of_login_customer);
      final response = await post(url,headers: {
        'Authorization' : 'Bearer ${userToken}',
        'content-type':'Application/json'
      },body: json.encode(
          {
            "number": number
          }
      ));
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        return body;
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }

}

class _GroupDetails{
  final BuildContext context;

  _GroupDetails({
    required this.context
  });

  Future<Map<String,dynamic>?> getCustomerDetailsByNumber(String number)async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.get_customer_details_by_number,);
    final response = await post(url,headers: {
      'Authorization':'Bearer ${userToken}'
    },body: json.encode({
      "number": number
    }));

    if(response.statusCode == 200){
      final body = response.body as Map<String,dynamic>;
      return body;
    }else{
      handleHttpResponse(context, response);
    }
    return null;
  }

  Future<Map<String,dynamic>?> getGroupCategory()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.get_customer_details_by_number,);
    final response = await get(url,headers: {
      'Authorization' : 'Bearer ${userToken}'
    });
    if(response.statusCode == 200){
      final body = response.body as Map<String,dynamic>;
      return body;
    }else{
      handleHttpResponse(context, response);
    }
    return null;
  }

  Future<Map<String,dynamic>?> getGroupByCategoryId()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.get_group_by_category_id,);
    final response = await get(url,headers: {
      'Authorization' : 'Bearer ${userToken}'
    });
    if(response.statusCode == 200){
      final body = response.body as Map<String,dynamic>;
      return body;
    }else{
      handleHttpResponse(context, response);
    }
    return null;
  }

}

class _OrderRelated{
  final BuildContext context;
  _OrderRelated({required this.context});

  Future<Map<String,dynamic>?> getOrderList()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.order_list);

    try{
      final response = await get(url,headers: {
        'Authorization':'Bearer ${userToken}'
      });
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        handleHttpResponse(context, response );
      }
    }catch(exception,trace){
      print('Exception: ${exception} Trace: ${trace}');
    }
    return null;

  }


  // Future<Map<String, dynamic>?> orderForSelf({
  //   String? orderForm,
  //   Map<String, dynamic>? orderFromOther,
  //   List<File>? orderBill,
  //   List<Map<String, dynamic>>? productDetails,
  // }) async {
  //   final userToken = Pref.instance.getString(Consts.user_token);
  //
  //   print('Printing all receive data');
  //   print('OrderFormOther:${json.encode(orderFromOther)}');
  //   print('Order Bill: ${orderBill!.length}');
  //   print('OrderFrom: ${orderForm}');
  //   print('Product Details: ${json.encode(productDetails)}');
  //   try {
  //     final url = Uri.https(Urls.base_url, Urls.order_entry_for_self);
  //     final request = http.MultipartRequest('POST', url)
  //       ..headers['Authorization'] = 'Bearer $userToken'
  //       ..fields['order_type'] = 'self'
  //       ..fields['app_name'] = 'mobile'
  //
  //       ..fields['order_from'] = orderForm??'null'
  //       ..fields['order_form_others'] = orderFromOther != null ? json.encode(orderFromOther) : 'null'
  //       ..fields['product_details'] = (productDetails != null && productDetails.isNotEmpty) ? json.encode(productDetails) : 'null';
  //
  //     if (orderBill != null && orderBill.isNotEmpty) {
  //       for (File file in orderBill) {
  //         final mimeType = file.path.endsWith('.png')
  //             ? MediaType('image', 'png')
  //             : MediaType('image', 'jpeg');
  //
  //         request.files.add(await http.MultipartFile.fromPath(
  //           'order_bill',
  //           file.path,
  //           contentType: mimeType,
  //         ));
  //       }
  //     }else{
  //       request.fields['order_bill'] = 'null';
  //     }
  //
  //     print('Sending request with:');
  //     print('  order_form_others: ${request.fields['order_form_others']}');
  //     print('  product_details: ${request.fields['product_details']}');
  //     print('  order_from: ${request.fields['order_from']}');
  //     print('  app_name: ${request.fields['app_name']}');
  //     print('  order_bill: ${request.fields['order_bill']}');
  //     print('  order_type: ${request.fields['order_type']}');
  //
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('Request failed: ${response.statusCode} -> ${response.body}');
  //       return jsonDecode(response.body) as Map<String, dynamic>;
  //     } else {
  //       print('Request failed: ${response.statusCode} -> ${response.body}');
  //       handleHttpResponse(context, response);
  //     }
  //   } catch (e, trace) {
  //     print('Exception: $e\nTrace: $trace');
  //   }
  //
  //   return null;
  // }

  Future<Map<String, dynamic>?> orderForSelf({
    String? orderForm,
    Map<String, dynamic>? orderFromOther,
    List<File>? orderBill,
    List<Map<String, dynamic>>? productDetails,
  }) async {
    final userToken = Pref.instance.getString(Consts.user_token);
    final isCompany = Pref.instance.getBool('order_from_company');
    try{
      final url = Uri.https(Urls.base_url, Urls.order_entry_for_self);
      final headers = {
        'Authorization' : 'Bearer ${userToken}',
        'Content-Type': 'application/json'
      };
      final Map<String,dynamic> value = {};

      value['order_type'] = 'self';
      value['order_from'] = orderForm;
      value['order_from_others'] = orderFromOther;
      value['app_name'] = 'mobile';
      value['is_company'] = isCompany;
      value['product_details'] = productDetails;

      if (orderBill != null && orderBill.isNotEmpty) {
        List<String> encodedList = [];

        for (File file in orderBill) {
          final extension = file.path.split('.').last.toLowerCase();

          if (['png', 'jpg', 'jpeg'].contains(extension)) {
            final bytes = await file.readAsBytes();
            final mediaType = extension == 'png' ? 'image/png' : 'image/jpeg';
            final base64String = 'data:$mediaType;base64,${base64Encode(bytes)}';
            encodedList.add(base64String);
          } else {
            print('Unsupported file type: $extension');
          }
        }

        value['order_bill'] = encodedList;
      } else {
        value['order_bill'] = null;
      }


      final body = json.encode(value);

      final response = await post(url,headers: headers,body: body);
      print('Get Response ${response.body}');
      if(response.statusCode == 200 || response.statusCode == 201){
        final data = json.decode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }

    return null;
  }




  Future<Map<String,dynamic>?> viewOrderById()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.order_view_by_id);
    return null;
  }

  Future<Map<String,dynamic>?> getOrderReportingList()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.order_reporting_list);
    try{
      final response = await get(url,headers: {
        'Authorization' : 'Bearer ${userToken}'
      });
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception} Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String,dynamic>?> searchOrderReportingList()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.order_reporting_list_search);
    return null;
  }

  Future<Map<String,dynamic>?> searchOrderList()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.order_list_search);
    return null;
  }

  Future<Map<String, dynamic>?> orderForOthers({
    String? orderForm,
    Map<String, dynamic>? orderFromOther,
    Map<String, dynamic>? orderForDetails,
    List<File>? orderBill,
    List<Map<String, dynamic>>? productDetails,
  }) async {
    final userToken = Pref.instance.getString(Consts.user_token);
    final isCompany = Pref.instance.getBool('order_from_company');
    try{
      final url = Uri.https(Urls.base_url, Urls.order_entry_for_self);
      final headers = {
        'Authorization' : 'Bearer ${userToken}',
        'Content-Type': 'application/json'
      };
      final Map<String,dynamic> value = {};

      value['order_type'] = 'others';
      value['order_for'] = orderForDetails;
      value['order_from'] = orderForm;
      value['order_from_others'] = orderFromOther;
      value['app_name'] = 'mobile';
      value['is_company'] = isCompany;
      value['product_details'] = productDetails;

      if (orderBill != null && orderBill.isNotEmpty) {
        List<String> encodedList = [];

        for (File file in orderBill) {
          final extension = file.path.split('.').last.toLowerCase();

          if (['png', 'jpg', 'jpeg'].contains(extension)) {
            final bytes = await file.readAsBytes();
            final mediaType = extension == 'png' ? 'image/png' : 'image/jpeg';
            final base64String = 'data:$mediaType;base64,${base64Encode(bytes)}';
            encodedList.add(base64String);
          } else {
            print('Unsupported file type: $extension');
          }
        }

        value['order_bill'] = encodedList;
      } else {
        value['order_bill'] = null;
      }


      final body = json.encode(value);

      final response = await post(url,headers: headers,body: body);
      print('Get Response ${response.body}');
      if(response.statusCode == 200 || response.statusCode == 201){
        final data = json.decode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }

    return null;
  }

}

class _InvoiceClaim{
  final BuildContext context;
  _InvoiceClaim({required this.context});

  Future<Map<String,dynamic>?> getClaimList()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.invoice_claim_list);
    try{
      final response = await get(url,headers: {
        'Authorization':'Bearer ${userToken}'
      });
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String,dynamic>?> getClaimReportingList()async{
    final userToken = Pref.instance.getString(Consts.user_token);

    try{
      final url = Uri.https(Urls.base_url,Urls.invoice_claim_reporting_list);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer ${userToken}'
      });
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exeption,trace){
      print('Exception: ${exeption}, Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String, dynamic>?> createInvoiceClaim({
    String? invoiceNo,
    required String invoiceData,
    String? claimFrom,
    required String amount,
    required String claimCopy,
    Map<String, dynamic>? claimFromOthers,
    String? claimedBy
  }) async {
    final userToken = Pref.instance.getString(Consts.user_token);

    try {
      final url = Uri.https(Urls.base_url, Urls.invoice_claim_entry);

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $userToken'
        ..fields['invoice_id'] = invoiceNo ?? ''
        ..fields['claimed_from'] = claimFrom ?? ''
        ..fields['invoice_date'] = invoiceData
        ..fields['claim_amount'] = amount
        ..fields['app_name'] = 'mobile'
        ..fields['claimed_from_others'] = jsonEncode(claimFromOthers);

      if(GroupRoles.dashboardType == DashboardTypes.User && claimedBy != null){
        request.fields['claimed_by'] = claimedBy;
      }
      final mimeType = claimCopy.endsWith('.png')
          ? MediaType('image', 'png')
          : MediaType('image', 'jpeg');

      request.files.add(await http.MultipartFile.fromPath(
        'claim_copy',
        claimCopy,
        contentType: mimeType,
      ));

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);
      print('Failed: ${response.statusCode} -> ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }else if(response.statusCode == 201){
        return jsonDecode(response.body) as Map<String,dynamic>;
      } else {
        handleHttpResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: $exception\nTrace: $trace');
    }

    return null;
  }

  Future<Map<String,dynamic>?> cancelClaim({
    required int claimID,
    required String claimStatus,
    required String remakrs,
})async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,'${Urls.invoice_claim_drop_out}${claimID}/drop-out/');
      final response = await post(url,headers: {
        'Authorization':'Bearer ${userToken}'
      },body: json.encode({
        'claim_status':'${claimStatus}',
        'claim_remarks' : '${remakrs}'
      }));
      if(response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String,dynamic>?> claimRecall({
    required int claimID,
    required int finalClaimAmount,
    required String status,
    String? remarks
})async{

    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,'${Urls.invoice_claim_recall}${claimID}/recall/');
      final response = await post(url,headers: {
        'Authorization' : 'Bearer ${userToken}'
      },
        body: json.encode({
          'claim_status' : status,
          'claim_remarks' : remarks,
          'final_claim_amount': '${finalClaimAmount}'
        })
      );

      if(response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception}, trace: ${trace}');
    }
    return null;
  }


}

class _ChangePassword{
  final BuildContext context;
  _ChangePassword({required this.context});

  Future<Map<String, dynamic>?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final userToken = Pref.instance.getString(Consts.user_token);

    try {
      final url = Uri.https(Urls.base_url, Urls.change_password);

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $userToken'
        ..fields['old_password'] = currentPassword
        ..fields['new_password'] = newPassword;


      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }else {
        print('Failed: ${response.statusCode} -> ${response.body}');
      }
    } catch (exception, trace) {
      print('Exception: $exception\nTrace: $trace');
    }

    return null;
  }
}

class _TransportationRelated{
  final BuildContext context;
  _TransportationRelated({required this.context});
  
  Future<Map<String,dynamic>?> getTransportationList()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,Urls.get_transportation_details);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $userToken'
      });

      if(response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['isScuss'];
        if(status){
          return data;
        }
      }else{
        print('Response: body- ${response.body} with Status Code: ${response.statusCode}');
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception, Trace: $trace');
    }
    return null;
  }
}

class _EditDetails {
  final BuildContext context;
  _EditDetails({required this.context});

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

  Future<Map<String, dynamic>?> updateDetails(
      {
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
      }

      String? base64GSTCopy;
      if(gst_copy != null){
        final extension = gst_copy.path.split('.').last.toLowerCase();
        if(['png','jpg','jpeg'].contains(extension)){
          final bytes = await gst_copy.readAsBytes();
          final mediaType = extension == 'png' ? 'image/png':'image/jpeg';
          base64GSTCopy = 'data:$mediaType;base64,${base64Encode(bytes)}';
        }else{
          print('Invalid GST Copy File');
        }
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

      print('body: $body');
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

class _GetUserDetails{
  final BuildContext context;
  _GetUserDetails({required this.context});
  Future<Map<String,dynamic>?> getUserLoginData() async{
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
  Future<UserDetailsData?> getUserLoginDataInModel() async{
    final dataFromAPI = await getUserLoginData();
    if(dataFromAPI != null){
      return LoginDetailsData.fromJson(dataFromAPI).data;
    }
    return null;
  }
}

class _KYCDetailsAPI {
  final BuildContext context;
  _KYCDetailsAPI({required this.context});
  // factory _KYCDetailsAPI({required BuildContext context}) =>
  //     _KYCDetailsAPI._(context: context);

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
          if(value is File){
            request.files.add(await http.MultipartFile.fromPath(
                key,
                value.path
            ));
          }else{
            request.fields[key] = value;
          }
        }
      });

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      print(' Response: ${response.body} with status code: ${response.statusCode}');
      if(response.statusCode == 200 || response.statusCode == 201){
        return json.decode(response.body) as Map<String,dynamic>;
      }else{
        handleHttpResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: $exception , Trace: $trace');
    }
    return null;
  }
}

class _WarrantyRelated{
  final BuildContext context;
  _WarrantyRelated({required this.context});
  
  Future<Map<String,dynamic>?> warrantyRegistration({
    required String warrantyType,
    required String warrantyNumber
})async{
    final userToken = Pref.instance.getString(Consts.user_token);
    
    try{
      final url = Uri.https(Urls.base_url,Urls.warranty_registration);
      final headers = {
        'Authorization' : 'Bearer ${userToken}',
        'Content-Type' : 'Application/json'
      };

      final body = jsonEncode({
        "warranty_type": warrantyType,
        "warranty_number": warrantyNumber
      });

      final response = await post(url,headers: headers,body: body);

      print('Response Code: ${response.statusCode}, body: ${response.body}');
      if(response.statusCode == 200 || response.statusCode == 201){
        final data = json.decode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception , Trace: $trace');
    }
    return null;
  }

  Future<Map<String,dynamic>?> getWarrantyRegistrationList()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,Urls.warranty_list);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $userToken'
      });
      print('response code: ${response.statusCode} , Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception trace: $trace',);
    }
    return null;
  }

}

class  _ConsumersGroup{
  final BuildContext context;
  _ConsumersGroup({required this.context});
  
  Future<Map<String,dynamic>?> getConsumerGroup()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,Urls.consumers_group);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $userToken'
      });
      print('response code: ${response.statusCode}, body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception, Trace: $trace');
    }
    return null;
  }
}

class _ProductCatalogues{
  final BuildContext context;
  _ProductCatalogues({required this.context});
  
  Future<Map<String,dynamic>?> getProductCatalogues()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,Urls.product_catalogues);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $userToken'
      });
      print('Response: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception, Trace: $trace');
    }
    return null;
  }

  Future<int> getProductCataloguesCount()async{
    var count = 0;
    final value = await getProductCatalogues();
    if(value != null){
      final data = value['data'] as List<dynamic>;
      return data.length;
    }
    return count;
  }
}