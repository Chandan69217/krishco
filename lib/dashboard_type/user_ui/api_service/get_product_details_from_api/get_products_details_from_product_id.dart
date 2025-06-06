import 'dart:convert';
import 'package:http/http.dart';
import 'package:krishco/dashboard_type/user_ui/utilities/user_urls.dart';
import 'package:krishco/models/product_related/product_category_data.dart';
import 'package:krishco/models/product_related/product_details_data.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/utilities/constant.dart';

class GetProdDetailsByProductId{
  GetProdDetailsByProductId._();


  static Future<List<ProdDetailsList?>> getAllProductListByID(List<ProductCategoryData> productCategory) async {

    try {
      final responses = await Future.wait<ProdDetailsList?>(
        productCategory.map((product) {
          return getProdDetailsByProductID(product.id.toString(),categoryName: product.catName);
        }).toList(),
      );
      return responses;
    } catch (e) {
      print("Error fetching all product details: $e");
      return [];
    }
  }


  static Future<ProdDetailsList?> getProdDetailsByProductID(String productId,
      {String? categoryName})async{
    try {
      final uri = Uri.https(UserUrls.base_url, "${Urls.product_details_by_id}/$productId/");
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