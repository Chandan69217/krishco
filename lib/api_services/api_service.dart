import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:krishco/models/product_related/product_category_data.dart';
import 'package:krishco/models/product_related/product_details_data.dart';
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
  APIService({required this.context}){
    productDetails = _ProductDetails(context: context);
    taggedEnterprise = _TaggedEnterprise(context: context);
    groupDetails = _GroupDetails(context: context);
    orderRelated = _OrderRelated(context: context);
    invoiceClaim = _InvoiceClaim(context: context);
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

  Future<Map<String,dynamic>?> orderForSelf({
    String? orderForm,
    Map<String,dynamic>? orderFromOther,
    String? filePath,
    List<Map<String,dynamic>>? productDetails
})async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,Urls.order_entry_for_self);
      final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer ${userToken}'
      ..fields['order_type'] = 'self'
      ..fields['app_name'] = 'mobile'
      ..fields['order_from'] = ''  // This field will update later
      ..fields['order_form_others'] = json.encode(orderFromOther) // This field will update later
      ..fields['product_details'] = json.encode(productDetails);

    if(filePath != null){
      final mimeType = filePath.endsWith('.png')
          ? MediaType('image', 'png')
          : MediaType('image', 'jpeg');
      request.files.add(
          await http.MultipartFile.fromPath('order_bill', filePath,contentType: mimeType)
      );
    }

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }else if(response.statusCode == 201){
      return jsonDecode(response.body) as Map<String,dynamic>;
    } else {
      print('Failed: ${response.statusCode} -> ${response.body}');
    }

    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
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
    final url = Uri.https(Urls.base_url,Urls.invoice_claim_reporting_list);

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


}