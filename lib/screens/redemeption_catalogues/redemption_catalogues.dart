import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';

// class ConsumerRedemptionCataloguesScreen extends StatelessWidget {
//   final Map<String, dynamic> jsonData = {
//     "isScuss": true,
//     "messages": "Catalogues Retrieved Successfully",
//     "data": [
//       {
//         "id": 2,
//         "product_details": [
//           {
//             "id": 2,
//             "is_krishco": true,
//             "is_other": false,
//             "product_name": "Cube Pipe",
//             "product_image": "https://krishco.com/media/product_pic/Krishco-QR-Code.pdf",
//             "product_price": "1000",
//             "status": true,
//             "delete_rec": false
//           },
//           {
//             "id": 3,
//             "is_krishco": true,
//             "is_other": false,
//             "product_name": "Motor",
//             "product_image": "https://krishco.com/media/product_pic/WhatsApp_Image_2024-10-29_at_14.08.38.jpeg",
//             "product_price": "1000",
//             "status": true,
//             "delete_rec": false
//           }
//         ],
//         "add_by": {
//           "id": 1,
//           "name": "Krishco Enginners Pvt. Ltd.",
//           "number": "9263584482",
//           "email": "sushant@krishco.com",
//           "group_type": null,
//           "group_name": null
//         },
//         "update_by": null,
//         "add_date": "2025-06-20 06:18:58",
//         "update_date": "2025-06-20 06:18:58",
//         "points": 46,
//         "status": true,
//         "delete_rec": false,
//         "app_name": "web"
//       },
//       {
//         "id": 1,
//         "product_details": [
//           {
//             "id": 1,
//             "is_krishco": true,
//             "is_other": false,
//             "product_name": "Motor",
//             "product_image": "https://krishco.com/media/product_pic/WhatsApp_Image_2024-11-25_at_13.43.16_1.jpeg",
//             "product_price": "5000",
//             "status": true,
//             "delete_rec": false
//           }
//         ],
//         "add_by": {
//           "id": 1,
//           "name": "Krishco Enginners Pvt. Ltd.",
//           "number": "9263584482",
//           "email": "sushant@krishco.com",
//           "group_type": null,
//           "group_name": null
//         },
//         "update_by": null,
//         "add_date": "2025-06-20 06:18:47",
//         "update_date": "2025-06-20 06:18:47",
//         "points": 46,
//         "status": true,
//         "delete_rec": false,
//         "app_name": "web"
//       }
//     ]
//   };
//
//   ConsumerRedemptionCataloguesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List dataList = jsonData['data'] ?? [];
//
//     return Scaffold(
//       body: dataList.isEmpty
//           ? const Center(child: Text('No redemption catalogues found'))
//           : ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           final item = dataList[index];
//           final addBy = item['add_by'] ?? {};
//           final products = item['product_details'] ?? [];
//           final points = item['points'] ?? 0;
//
//           return  Container(
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 6,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header Row
//                   Row(
//                     children: [
//                       const Icon(Icons.business, color: Colors.teal),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           addBy['name'] ?? 'Unknown Company',
//                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Chip(
//                         backgroundColor: Colors.indigo.shade50,
//                         label: Text("$points pts"),
//                         avatar: const Icon(Icons.stars, color: Colors.indigo),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // Product Grid
//                   GridView.builder(
//                     itemCount: products.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 8,
//                       mainAxisSpacing: 8,
//                       childAspectRatio:0.95,
//                     ),
//                     itemBuilder: (context, i) {
//                       final product = products[i];
//                       final name = product['product_name'] ?? '';
//                       final image = product['product_image'] ?? '';
//                       final price = product['product_price'] ?? '';
//
//                       return Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),topRight: Radius.circular(8.0)),
//                                 child: image.endsWith(".pdf")
//                                     ? Container(
//                                   width: double.infinity,
//                                   color: Colors.red[50],
//                                   child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
//                                 )
//                                     : Image.network(
//                                   image,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Padding( padding: const EdgeInsets.all(8),
//                             child: Column(
//                               crossAxisAlignment:CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   name,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(fontWeight: FontWeight.w600),
//                                 ),
//                                 Text(
//                                   "$price pts",
//                                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // Buy All Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       ),
//                       icon: const Icon(Icons.shopping_cart_checkout),
//                       label: const Text("Buy All Products"),
//                       onPressed: () {
//                         // TODO: Implement Buy All logic here
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Buying all ${products.length} items for $points pts')),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


class RedemptionCataloguesScreen extends StatefulWidget {
  final String? title;
  const RedemptionCataloguesScreen({super.key,this.title});

  @override
  State<RedemptionCataloguesScreen> createState() => _RedemptionCataloguesScreenState();
}

class _RedemptionCataloguesScreenState extends State<RedemptionCataloguesScreen> {
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> displayedProducts = [];
  List<Map<String, dynamic>> selectedProducts = [];
  String searchQuery = '';
  late Future<Map<String,dynamic>?> _futureRedemptionCatalogues;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _futureRedemptionCatalogues = _getRedemptionCatalogue();
  }

  Future<Map<String,dynamic>?> _getRedemptionCatalogue()async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,Urls.redemptionCatalogues);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $userToken'
      });
      print('Response Code: ${response.statusCode}, Body: ${response.body}');
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

  void extractAllProducts(Map<String,dynamic> jsonData) {
    final List dataList = jsonData['data'] ?? [];
    final List<Map<String, dynamic>> tempProducts = [];

    for (var item in dataList) {
      final Map<String,dynamic> product = item['product_details'] ?? [];
      final int points = item['points'] ?? 0;
      product['points'] = points;
      tempProducts.add(product);
    }
    WidgetsBinding.instance.addPostFrameCallback((duration){
      setState(() {
        allProducts = tempProducts;
        displayedProducts = List.from(allProducts);
        _isInitialized = true;
      });
    });
  }

  void filterProducts(String query) {
    setState(() {
      searchQuery = query;
      displayedProducts = allProducts
          .where((product) => (product['product_name'] ?? '')
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleSelection(Map<String, dynamic> product) {
    setState(() {
      if (selectedProducts.contains(product)) {
        selectedProducts.remove(product);
      } else {
        selectedProducts.add(product);
      }
    });
  }

  int getTotalPoints() {
    return selectedProducts.fold(0, (sum, item) => sum + int.tryParse(item['points'].toString())!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null ? AppBar(
        title: Text(widget.title??''),
      ) : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: filterProducts,
                      decoration: InputDecoration(
                        hintText: 'Search product by name...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),
                    FutureBuilder<Map<String,dynamic>?>(future: _futureRedemptionCatalogues,
                        builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: SizedBox.square(
                            dimension: 25.0,
                            child: CircularProgressIndicator(
                              color: CustColors.nile_blue,
                            ),
                          ),
                        );
                      }
        
                      if(snapshot.hasData){
                       if(!_isInitialized){
                         extractAllProducts(snapshot.data??{});
                       }
                       return Expanded(
                         child: GridView.builder(
                           itemCount: displayedProducts.length,
                           shrinkWrap: true,
                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount: 2,
                             crossAxisSpacing: 12,
                             mainAxisSpacing: 12,
                             childAspectRatio: 0.8,
                           ),
                           itemBuilder: (context, index) {
                             final product = displayedProducts[index];
                             final isSelected = selectedProducts.contains(product);
                             final name = product['product_name'] ?? '';
                             final image = product['product_image'] ?? '';
                             final price = product['product_price'] ?? '';
                             final points = product['points'] ?? '';
        
                             return Container(
                               decoration: BoxDecoration(
                                 color: isSelected ? Colors.green.shade50 : Colors.white,
                                 border: Border.all(
                                   color: isSelected ? Colors.green : Colors.grey.shade300,
                                   width: 2,
                                 ),
                                 borderRadius: BorderRadius.circular(12.0),
                               ),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Expanded(
                                       child: CustomNetworkImage(
                                         width: double.infinity,
                                         imageUrl: image,
                                         fit: BoxFit.cover,
                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0)),
                                       )
                                   ),
                                   Expanded(
                                     child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                         children: [
                                           Flexible( flex: 2,fit: FlexFit.loose,child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium!.copyWith( fontWeight: FontWeight.w600)),),
                                           // SizedBox(height: 4,),
                                           Flexible( fit: FlexFit.loose,child: Text("Price: ₹$price pts", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey, fontSize: 12))),
                                           Flexible( fit: FlexFit.loose,child: Text("Points: $points pts", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey, fontSize: 12))),
                                           const SizedBox(height: 4),
                                           Flexible(
                                             fit: FlexFit.loose,
                                             child: SizedBox(
                                               width: double.infinity,
                                               child: OutlinedButton(
                                                 onPressed: () => toggleSelection(product),
                                                 style: OutlinedButton.styleFrom(
                                                   foregroundColor: isSelected ? Colors.red : Colors.green,
                                                   side: BorderSide(color: isSelected ? Colors.red : Colors.green),
                                                 ),
                                                 child: Text(isSelected ? 'Remove' : 'Add'),
                                               ),
                                             ),
                                             flex: 3,
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             );
                           },
                         ),
                       );
                      }else{
                        return Center(
                          child: Text('Something Went Wrong !'),
                        );
                      }
                    }
                    )
                  ],
                ),
              ),
            ),
            if (selectedProducts.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Selected: ${selectedProducts.length} | Total Points: ${getTotalPoints()} pts"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Buying ${selectedProducts.length} products')),
                        );
                      },
                      child: const Text("Buy Now"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


