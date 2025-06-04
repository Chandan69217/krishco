import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:http_parser/http_parser.dart';
import 'package:krishco/api_services/handle_https_response.dart';



class APIService{
  final BuildContext context;
  late final _ProductDetails productDetails;
  late final _TaggedEnterprise taggedEnterprise;
  late final _GroupDetails groupDetails;
  late final _OrderRelated orderRelated;
  late final _InvoiceClaim invoiceClaim;
  late final _ChangePassword changePassword;
  late final _TransportationRelated transportationDetails;
  APIService({required this.context}){
    productDetails = _ProductDetails(context: context);
    taggedEnterprise = _TaggedEnterprise(context: context);
    groupDetails = _GroupDetails(context: context);
    orderRelated = _OrderRelated(context: context);
    invoiceClaim = _InvoiceClaim(context: context);
    changePassword = _ChangePassword(context: context);
    transportationDetails = _TransportationRelated(context: context);
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
        'Authorization' : 'Bearer ${userToken}'
      },body: json.encode(
          {
            "number": number
          }
      ));

      if(response.statusCode == 200){
        final body = response.body as Map<String,dynamic>;
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

    // try{
    //   final url = Uri.https(Urls.base_url, Urls.order_entry_for_self);
    //   final headers = {
    //     'Authorization' : 'Bearer ${userToken}',
    //     'Content-Type': 'application/json'
    //   };
    //   final Map<String,dynamic> value = {};
    //
    //   value['order_type'] = 'self';
    //   value['order_from'] = orderForm;
    //   value['order_from_others'] = orderFromOther;
    //   value['app_name'] = 'mobile';
    //   value['product_details'] = productDetails;
    //
    //   if (orderBill != null && orderBill.isNotEmpty) {
    //     List<String> encodedList = [];
    //
    //     for (File file in orderBill) {
    //       final extension = file.path.split('.').last.toLowerCase();
    //
    //       if (['png', 'jpg', 'jpeg'].contains(extension)) {
    //         final bytes = await file.readAsBytes();
    //         final mediaType = extension == 'png' ? 'image/png' : 'image/jpeg';
    //         final base64String = 'data:$mediaType;base64,${base64Encode(bytes)}';
    //         encodedList.add(base64String);
    //       } else {
    //         print('Unsupported file type: $extension');
    //       }
    //     }
    //
    //     value['order_bill'] = encodedList;
    //   } else {
    //     value['order_bill'] = null;
    //   }
    //
    //
    //
    //
    //   value.forEach((key,value){
    //     print('Key: $key, Value: $value, Type: ${value.runtimeType}');
    //   });
    //   final body = json.encode(value);
    //
    //   final response = await post(url,headers: headers,body: body);
    //   print('Get Response ${response.body}');
    //   if(response.statusCode == 200 || response.statusCode == 201){
    //     final data = json.decode(response.body) as Map<String,dynamic>;
    //     return data;
    //   }else{
    //     handleHttpResponse(context, response);
    //   }
    // }catch(exception,trace){
    //   print('Exception: ${exception},Trace: ${trace}');
    // }

    try {
    final url = Uri.https(Urls.base_url, Urls.order_entry_for_self);
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $userToken'
        ..fields['order_type'] = 'self'
        ..fields['app_name'] = 'mobile';
      // Optional fields
      if (orderForm?.isNotEmpty == true) {
        request.fields['order_from'] = orderForm!;
      }

      if (orderFromOther != null && orderFromOther.isNotEmpty) {
        request.fields['order_form_others'] = jsonEncode(orderFromOther);
      }

      if (productDetails != null && productDetails.isNotEmpty) {
        request.fields['product_details'] = jsonEncode(productDetails);
      }

      // Attach order bill images
      if (orderBill != null && orderBill.isNotEmpty) {
        for (final file in orderBill) {
          final mimeType = file.path.toLowerCase().endsWith('.png')
              ? MediaType('image', 'png')
              : MediaType('image', 'jpeg');

          request.files.add(
            await http.MultipartFile.fromPath(
              'order_bill',
              file.path,
              contentType: mimeType,
            ),
          );
        }
      }

      // Debug log
      print('Submitting order with fields:');
      request.fields.forEach((key, value) => print('$key: $value'));
      print('Attached files: ${request.files.length}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Request failed: ${response.statusCode} -> ${response.body}');
        handleHttpResponse(context, response);
      }
    } catch (e, trace) {
      print('Exception: $e\nTrace: $trace');
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

  Future<Map<String,dynamic>?> orderForOthers()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.order_entry_for_others);
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
  }) async {
    final userToken = Pref.instance.getString(Consts.user_token);

    try {
      final url = Uri.https(Urls.base_url, Urls.invoice_claim_entry);

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $userToken'
        ..fields['invoice_id'] = invoiceNo ?? ''
        ..fields['invoice_date'] = invoiceData
        ..fields['claimed_from'] = claimFrom ?? ''
        ..fields['claim_amount'] = amount
        ..fields['app_name'] = 'mobile'
        ..fields['claimed_from_others'] = jsonEncode(claimFromOthers);

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

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }else if(response.statusCode == 201){
        return jsonDecode(response.body) as Map<String,dynamic>;
      } else {
        print('Failed: ${response.statusCode} -> ${response.body}');
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
      final url = Uri.https(Urls.base_url,Urls.getTransportationDetails);
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