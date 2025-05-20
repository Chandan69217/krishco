import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/place_order_screen.dart';

// class OrdersScreen extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('Orders Screen'),
//       ),
//     );
//   }
// }



class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedTabIndex = 0;

  final List<Map<String, dynamic>> orderList =[
    {
      "sno": 1,
      "orderNumber": "ORD-1001",
      "productName": "Wireless Mouse",
      "quantity": 2,
      "orderDateTime": "2025-05-15 10:30 AM",
      "receivedDate": "2025-05-18"
    },
    {
      "sno": 2,
      "orderNumber": "ORD-1002",
      "productName": "Mechanical Keyboard",
      "quantity": 1,
      "orderDateTime": "2025-05-16 03:45 PM",
      "receivedDate": "2025-05-19"
    },
    {
      "sno": 3,
      "orderNumber": "ORD-1003",
      "productName": "USB-C Charger",
      "quantity": 3,
      "orderDateTime": "2025-05-17 09:20 AM",
      "receivedDate": "2025-05-20"
    },
    {
      "sno": 4,
      "orderNumber": "ORD-1004",
      "productName": "Laptop Stand",
      "quantity": 1,
      "orderDateTime": "2025-05-18 11:15 AM",
      "receivedDate": "2025-05-21"
    },
    {
      "sno": 5,
      "orderNumber": "ORD-1005",
      "productName": "External Hard Drive",
      "quantity": 2,
      "orderDateTime": "2025-05-19 04:00 PM",
      "receivedDate": "2025-05-22"
    }
  ];

  final List<Map<String, dynamic>> reportingOrder = [
    {
      "sno": 1,
      "orderNumber": "ORD-2001",
      "orderDate": "2025-05-10",
      "consumerDetails": "John Doe, johndoe@example.com",
      "remarks": "Urgent delivery",
      "status": "Delivered",
      "statusMessage": "Delivered on time",
      "reportingMessage": "Customer satisfied",
      "messageDate": "2025-05-12",
      "actions": "View"
    },
    {
      "sno": 2,
      "orderNumber": "ORD-2002",
      "orderDate": "2025-05-11",
      "consumerDetails": "Jane Smith, jane.smith@example.com",
      "remarks": "Gift package",
      "status": "Pending",
      "statusMessage": "Waiting for dispatch",
      "reportingMessage": "Dispatch scheduled",
      "messageDate": "2025-05-13",
      "actions": "View"
    },
    {
      "sno": 3,
      "orderNumber": "ORD-2003",
      "orderDate": "2025-05-12",
      "consumerDetails": "Mike Johnson, mike.j@example.com",
      "remarks": "Need invoice",
      "status": "Cancelled",
      "statusMessage": "Cancelled by user",
      "reportingMessage": "Refund issued",
      "messageDate": "2025-05-14",
      "actions": "View"
    },
    {
      "sno": 4,
      "orderNumber": "ORD-2004",
      "orderDate": "2025-05-13",
      "consumerDetails": "Anna Brown, anna.b@example.com",
      "remarks": "Bulk order",
      "status": "Processing",
      "statusMessage": "Packaging started",
      "reportingMessage": "Estimated delivery: 3 days",
      "messageDate": "2025-05-15",
      "actions": "View"
    },
    {
      "sno": 5,
      "orderNumber": "ORD-2005",
      "orderDate": "2025-05-14",
      "consumerDetails": "Chris Evans, chris.e@example.com",
      "remarks": "Resend required",
      "status": "Returned",
      "statusMessage": "Returned by courier",
      "reportingMessage": "Reshipment approved",
      "messageDate": "2025-05-16",
      "actions": "View"
    }
  ];

  List<Map<String, dynamic>> _filteredOrders = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateFilteredOrders();
    _searchController.addListener(_filterOrders);
  }

  void _updateFilteredOrders() {
    final data = selectedTabIndex == 0 ? orderList : reportingOrder;
    _filteredOrders = List.from(data);
  }

  void _filterOrders() {
    final query = _searchController.text.toLowerCase();
    final data = selectedTabIndex == 0 ? orderList : reportingOrder;
    setState(() {
      _filteredOrders = data.where((claim) {
        return claim['orderNumber'].toLowerCase().contains(query) ||
            claim['productName'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
      _searchController.clear();
      _updateFilteredOrders();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                          duration: Duration(milliseconds: 200),
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
                              fontWeight: FontWeight.bold,
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
                  hintText: "Search by Order Number, Product Name",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                  Icon(Icons.receipt, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    selectedTabIndex == 0 ? "List of Orders" : "List of Reporting Messages",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: _filteredOrders.isNotEmpty
                  ? ListView.builder(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 80),
                itemCount: _filteredOrders.length,
                itemBuilder: (context, index) {
                  final claim = _filteredOrders[index];
                  return Card(
                    key: ValueKey(claim['claimNumber']),
                    color: Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ExpansionTile(
                      title: Text( claim.containsKey('status')?
                        "Order Number: ${claim['orderNumber']}":"Product Name: ${claim['productName']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        claim.containsKey('status')?
                        "Status: ${claim['status']}":"Order No: ${claim['orderNumber']}",
                        style: TextStyle(
                          color: _getStatusColor(claim['status']),
                        ),
                      ),
                      children: [
                        _OrderCard(
                          orderData: claim,
                          onView: (){},
                          onCancel: selectedTabIndex == 0 ? (){

                          }:null,
                          // onDownload: selectedTabIndex == 1 ? (){
                          //
                          // }:null,
                        )
                      ],
                    ),
                  );
                },
              )
                  : Center(
                child: Text("No claims found",
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _fabButton(),
    );
  }


  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "delivered":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      case "processing":
        return Colors.blue;
      case "returned":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _fabButton() {
    return FloatingActionButton.extended(
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PlaceOrderScreen()));
      },
      icon: Icon(Icons.shopping_bag),
      label: Text("Place Order"),
      backgroundColor: Colors.blue,
    );
  }
}



class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final VoidCallback? onCancel;
  final VoidCallback? onView;
  final VoidCallback? onDownload;

  const _OrderCard({
    Key? key,
    required this.orderData,
    this.onCancel,
    this.onView,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

            _buildRow("Order Number", orderData['orderNumber']),
          if (orderData.containsKey('productName'))
          _buildRow("Product Name", orderData['productName']),
          if (orderData.containsKey('quantity'))
          _buildRow("Quantity", "${orderData['quantity']}"),
          if (orderData.containsKey('orderDateTime'))
          _buildRow("Order DateTime", orderData['orderDateTime']),
          if (orderData.containsKey('receivedDate'))
            _buildRow("Received Date", orderData['receivedDate']),
          if(orderData.containsKey('orderDate'))
            _buildRow('Order Date', orderData['orderDate']),

          if(orderData.containsKey('consumerDetails'))
            _buildRow('Consumer Details', orderData['consumerDetails']),

          if (orderData.containsKey('remarks'))
            _buildRow("Remarks", orderData['remarks']),

          if (orderData.containsKey('status'))
          _buildRow(
            "Status",
            orderData['status'],
            color: _getStatusColor(orderData['status']),
          ),
          if(orderData.containsKey('statusMessage'))
          _buildRow("Status Message", orderData['statusMessage']),
          if(orderData.containsKey('reportingMessage'))
          _buildRow("Reporting Message", orderData['reportingMessage']),
          if (orderData.containsKey('messageDate'))
            _buildRow("Message Date", orderData['messageDate']),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onDownload != null)
                TextButton.icon(
                  onPressed: onDownload,
                  icon: const Icon(Icons.download, color: Colors.blue),
                  label: const Text("Invoice Copy",
                      style: TextStyle(color: Colors.blue)),
                ),
              if (onCancel != null)
                TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text("Cancel",
                      style: TextStyle(color: Colors.red)),
                ),
              if (onView != null) const SizedBox(width: 12),
              if (onView != null)
                ElevatedButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility),
                  label: const Text("View"),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRow(String title, String? value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text("$title:", style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value ?? "-", style: TextStyle(color: color ?? Colors.black87)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "delivered":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      case "processing":
        return Colors.blue;
      case "returned":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

}
