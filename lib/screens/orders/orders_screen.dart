import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/screens/orders/place_order_screen.dart';
import 'package:krishco/models/order_related/order_list.dart';
import 'package:krishco/models/order_related/order_product_data.dart';
import 'package:krishco/models/order_related/order_reporting_list_data.dart';
import 'package:krishco/widgets/cust_loader.dart';

import 'order_details/order_details_screen.dart';
import 'order_details/order_reporting_details_screen.dart';


class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedTabIndex = 0;
  OrderListData? orderList;
  OrderReportingListData? orderReportingList;
  Future<Map<String,dynamic>?>? _futureOrder;
  final ValueNotifier<List<OrderData>> _filteredOrderList = ValueNotifier<List<OrderData>>([]);
  final ValueNotifier<List<OrderReportingData>> _filteredReportingList = ValueNotifier<List<OrderReportingData>>([]);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterOrders);
    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchOrderData();
    });
  }

  void _updateFilteredOrders() {
    if (selectedTabIndex == 0) {
      _filteredOrderList.value = orderList?.data ?? [];
    } else {
      _filteredReportingList.value = orderReportingList?.data ?? [];
    }
  }

  void _fetchOrderData()async{
    final orderRelatedObj = APIService.getInstance(context).orderRelated;
    setState(() {
      _futureOrder = selectedTabIndex == 0 ? orderRelatedObj.getOrderList():orderRelatedObj.getOrderReportingList();
    });
  }


  void _filterOrders() {
    final query = _searchController.text.toLowerCase();
    if (selectedTabIndex == 0) {
      final filtered = orderList?.data.where((order) {
        return order.orderNo?.toLowerCase().contains(query) ?? false;
      }).toList()??[];
      _filteredOrderList.value = filtered;
    } else {
      final filtered = orderReportingList?.data.where((order) {
        return order.order!.orderNo!.toLowerCase().contains(query);
      }).toList()??[];
      _filteredReportingList.value = filtered;
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
      _searchController.clear();
      _fetchOrderData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredOrderList.dispose();
    _filteredReportingList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabTitles = ["Order List", "Reporting Message"];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Custom tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(tabTitles.length, (index) {
                    final isSelected = selectedTabIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabSelected(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabTitles[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            // Search box
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search by Order Number",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Image.asset('assets/icons/task-checklist.webp',width: 20.0,height: 20.0, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    selectedTabIndex == 0 ? "List of Orders" : "List of Reporting Messages",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: CustomRefreshIndicator(
                onRefresh: _onRefresh,
                builder: (context, child, controller) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (controller.isLoading)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: CircularProgressIndicator(color: Colors.blue.shade600,),
                        ),
                      Transform.translate(
                        offset: Offset(0, 100 * controller.value),
                        child: child,
                      ),
                    ],
                  );
                },
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _futureOrder,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CustLoader());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Something went wrong !!',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      );
                    }

                    final data = snapshot.data;
                    if (data == null) {
                      return const Center(child: Text('Empty'));
                    }

                    if (selectedTabIndex == 0) {
                      orderList = OrderListData.fromJson(data);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _updateFilteredOrders();
                      });
                      return ValueListenableBuilder<List<OrderData>>(
                        valueListenable: _filteredOrderList,
                        builder: (context, filteredOrders, _) {
                          if (filteredOrders.isEmpty) {
                            return const Center(child: Text("Empty", style: TextStyle(color: Colors.grey)));
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                            itemCount: filteredOrders.length,
                            itemBuilder: (context, index) {
                              final order = filteredOrders[index];
                              return _OrderCard(order: order);
                            },
                          );
                        },
                      );
                    } else {
                      orderReportingList = OrderReportingListData.fromJson(data);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _updateFilteredOrders();
                      });
                      return ValueListenableBuilder<List<dynamic>>(
                        valueListenable: _filteredReportingList,
                        builder: (context, filteredReports, _) {
                          if (filteredReports.isEmpty) {
                            return const Center(child: Text("Empty", style: TextStyle(color: Colors.grey)));
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                            itemCount: filteredReports.length,
                            itemBuilder: (context, index) {
                              return _OrderReportingCard(data: filteredReports[index],);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _fabButton(),
    );
  }


  Widget _fabButton() {
    return FloatingActionButton.extended(
      heroTag: 'order_fav_button',
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaceOrderScreen(
          onSuccess: (){
            _fetchOrderData();
          },
        )));
      },
      icon: const Icon(Icons.shopping_bag),
      label: const Text("Place Order"),
      backgroundColor: Colors.blue,
    );
  }


  Future<void> _onRefresh()async{
    final orderRelatedObj = APIService.getInstance(context).orderRelated;
    if(selectedTabIndex == 0){
      final data = await orderRelatedObj.getOrderList();
      if(data != null){
        orderList = OrderListData.fromJson(data);
      }
    }else{
      final data = await orderRelatedObj.getOrderReportingList();
      if(data!=null){
        orderReportingList = OrderReportingListData.fromJson(data);
      }
    }
  }

}



class _OrderCard extends StatelessWidget {
  final OrderData order;
  const _OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderProducts = order.orderProduct;
    final product =  orderProducts.isNotEmpty ? orderProducts[0].product : null;

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row (Product Name + Order Status)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product?.name ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.orderStatus ?? 'Unknown',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text("Order No: ${order.orderNo ?? 'N/A'}",
                style: const TextStyle(fontSize: 13)),

            const SizedBox(height: 8.0),

            // User Info & More Details Button
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "By: ${order.addBy!.name} (${order.addBy!.number})",
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                // TextButton(
                //   style: Theme.of(context).textButtonTheme.style!.copyWith(
                //     padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                //     foregroundColor: WidgetStatePropertyAll(Colors.blue.shade600),
                //     splashFactory: NoSplash.splashFactory,
                //     overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => OrderDetailsScreen(order: order),
                //       ),
                //     );
                //   },
                //   child: const Text("More Details"),
                // ),
              ],
            ),

            // const SizedBox(height: 4.0),

            if (order.statusMessage != null &&
                order.statusMessage.toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Text(
                  "Note: ${order.statusMessage}",
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),

            // Product Details
            if (product != null)
              _PaginatedProductList(orderProducts: orderProducts),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(
                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                    foregroundColor: WidgetStatePropertyAll(Colors.blue.shade600),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                  child: const Text("More Details"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderReportingCard extends StatelessWidget {
  final OrderReportingData data;

  const _OrderReportingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final order = data.order;
    final orderedBy = order!.addBy;
    final orderedFrom = order.orderedFrom;
    final product = order.orderProduct.isNotEmpty ? order.orderProduct[0].product : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Order Meta
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order No: ${order.orderNo}", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14,fontWeight: FontWeight.bold)),
                SizedBox(width: 4,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.orderStatus ?? 'Unknown',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data.message??'',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 12),


            if (product != null)...[
              Text('Products Details',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue.shade600,fontWeight: FontWeight.bold),),
              _PaginatedProductList(orderProducts: order.orderProduct),
            ],
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     ClipRRect(
              //       borderRadius: BorderRadius.circular(8),
              //       child: CachedNetworkImage(
              //         imageUrl: product.photo ?? '',
              //         width: 60,
              //         height: 60,
              //         fit: BoxFit.cover,
              //         placeholder: (context, url) =>
              //         const SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
              //         errorWidget: (context, url, error) =>
              //             Image.asset('assets/logo/Placeholder_image.webp'),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(product.name ?? 'N/A',
              //               style: const TextStyle(fontWeight: FontWeight.bold)),
              //           Text("Category: ${product.catgeory}", style: const TextStyle(fontSize: 12)),
              //           Text("Price: ₹${product.price}", style: const TextStyle(fontSize: 12)),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

            const SizedBox(height: 8),


            // View Details Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: Theme.of(context).textButtonTheme.style!.copyWith(
                  foregroundColor: WidgetStatePropertyAll(Colors.blue.shade600)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderReportingDetailsScreen(data: data),
                    ),
                  );
                },
                child: const Text("View Order Details"),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class _PaginatedProductList extends StatefulWidget {
  final List<OrderProduct> orderProducts;

  const _PaginatedProductList({
    super.key,
    required this.orderProducts,
  });

  @override
  State<_PaginatedProductList> createState() => _PaginatedProductListState();
}

class _PaginatedProductListState extends State<_PaginatedProductList> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.95);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProducts = widget.orderProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            itemCount: orderProducts.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final op = orderProducts[index];
              final product = op.product;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: product?.photo ?? '',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                            'assets/logo/Placeholder_image.webp'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product?.name ?? 'N/A',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          Text("Category: ${product?.catgeory ?? 'N/A'}",
                              style: const TextStyle(fontSize: 12)),
                          Text("Price: ₹${product?.price ?? 0}",
                              style: const TextStyle(fontSize: 12)),
                          Text("Quantity: ${op.orderedQuantity}",
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),


        Center(child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              shape: BoxShape.rectangle,
              color: Colors.grey.shade200,
            ),child: Text('${_currentPage +1 } of ${orderProducts.length}',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.blue.shade600,fontWeight: FontWeight.bold),))),
        // Indicator (Dots)
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: List.generate(orderProducts.length, (index) {
        //     final isActive = index == _currentPage;
        //     return AnimatedContainer(
        //       duration: const Duration(milliseconds: 300),
        //       margin: const EdgeInsets.symmetric(horizontal: 4),
        //       width: isActive ? 14 : 8,
        //       height: 8,
        //       decoration: BoxDecoration(
        //         color: isActive ? Colors.blue : Colors.grey[400],
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //     );
        //   }),
        // ),
      ],
    );
  }
}





// class _OrderReportingDetailsScreen extends StatelessWidget {
//   final OrderReportingData data;
//
//   const _OrderReportingDetailsScreen({super.key, required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     final order = data.order;
//     final productList = order!.orderProduct;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reporting Message Details'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Message
//           Text(
//             data.message??'',
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//
//           // Order Info
//           _buildInfoRow("Order No", order.orderNo),
//           _buildInfoRow("Status", order.orderStatus),
//           _buildInfoRow("Date", order.orderDate.toString()),
//           const SizedBox(height: 16),
//
//           // Ordered From
//           const Text("Ordered From", style: TextStyle(fontWeight: FontWeight.bold)),
//           _buildUserCard(),
//
//           const SizedBox(height: 12),
//
//           // Ordered By
//           const Text("Ordered By", style: TextStyle(fontWeight: FontWeight.bold)),
//           _buildUserCard(),
//
//           const SizedBox(height: 16),
//
//           // Product List
//           const Text("Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           ...productList.map((item) => _buildProductCard()).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         children: [
//           Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value ?? "N/A")),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUserCard() {
//     final user = data.order!.addBy!;
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 1,
//       child: ListTile(
//         leading: const Icon(Icons.person_outline),
//         title: Text(user.name??'N/A'),
//         subtitle: Text("${user.groupType} - ${user.groupName}"),
//         trailing: Text(user.number??'N/A'),
//       ),
//     );
//   }
//
//   Widget _buildProductCard() {
//     final item = data.order!.orderProduct[0];
//     final product = item.product;
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: CachedNetworkImage(
//                 imageUrl: product!.photo ?? '',
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) =>
//                 const SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
//                 errorWidget: (context, url, error) =>
//                     Image.asset('assets/logo/Placeholder_image.webp'),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(product.name ?? '',
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 4),
//                   Text("Category: ${product.catgeory}"),
//                   Text("Price: ₹${product.price}"),
//                   Text("Ordered Qty: ${item.orderedQuantity} ${product.unit}"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }