import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:krishco/models/product_related/product_category_data.dart';
import 'package:krishco/models/product_related/product_details_data.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/utilities/constant.dart';
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

  Future<List<ProductCategoryData>?> getProductCategory() async {
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
          var productData = rawData['data'] as List<dynamic>;
           return productData
              .map((e) => ProductCategoryData.fromJson(e as Map<String, dynamic>))
              .toList();
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

  Future<List<ProdDetailsList?>> getAllProductListByID(List<ProductCategoryData> productCategory) async {

    try {
      final responses = await Future.wait<ProdDetailsList?>(
        productCategory.map((product) {
          return _getProdDetailsByProductID(product.id.toString(),categoryName: product.catName);
        }).toList(),
      );
      return responses;
    } catch (e) {
      print("Error fetching all product details: $e");
      return [];
    }

  }


  Future<ProdDetailsList?> _getProdDetailsByProductID(String productId,
      {String? categoryName})async{
    try {
      final uri = Uri.https(Urls.base_url, "${Urls.product_details_by_id}/$productId/");
      final userToken = Pref.instance.getString(Consts.user_token);
      final response = await get(uri, headers: {
        'Authorization': 'Bearer $userToken',
      });
      if (response.statusCode == 200){
        final body = jsonDecode(response.body) as Map<String,dynamic>;
        return ProdDetailsList.fromJson(body,categoryName: categoryName);
      } else {
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
    final url = Uri.https(Urls.base_url,Urls.tagged_enterprise_of_login_customer);

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

  Future<Map<String,dynamic>?> getTaggedEnterprisedByNumber(String number)async{
    final userToken = Pref.instance.getString(Consts.user_token);
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

  Future<Map<String,dynamic>?> orderForSelf()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,Urls.order_entry_for_self);
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

}