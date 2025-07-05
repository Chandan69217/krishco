import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/models/order_related/order_list.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderData order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final addBy = order.addBy;
    final orderedFrom = order.orderedFrom;
    final productList = order.orderProduct ?? [];
    final nonRegistered = order.isRegistered == false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          shrinkWrap: true,
          children: [
            _buildCard(
              title: "Order Info",
              children: [
                _infoRow("Order No", order.orderNo),
                _infoRow("Date", order.orderDate?.toString()),
                _infoRow("Status", order.orderStatus, highlight: true),
                if ((order.statusMessage ?? '').isNotEmpty)
                  _infoRow("Message", order.statusMessage, isWarning: true),
                _infoRow("Order Type", order.orderType),
                _infoRow("App", order.appName),
              ],
            ),
        
            const SizedBox(height: 12),
        
            if (addBy != null)
              _buildCard(
                title: "Added By",
                children: [
                  _infoRow("Name", addBy.name),
                  _infoRow("Number", addBy.number),
                  _infoRow("Email", addBy.email),
                  _infoRow("Group", "${addBy.groupType ?? '-'} - ${addBy.groupName ?? '-'}"),
                ],
              ),
        
            const SizedBox(height: 12),
        
            if (orderedFrom != null)
              _buildCard(
                title: "Ordered From",
                children: [
                  _infoRow("Name", orderedFrom.name),
                  _infoRow("Number", orderedFrom.number),
                  _infoRow("Email", orderedFrom.email),
                  _infoRow("Group", "${orderedFrom.groupType ?? '-'} - ${orderedFrom.groupName ?? '-'}"),
                ],
              ),
        
            if (nonRegistered) ...[
              const SizedBox(height: 12),
              _buildCard(
                title: "Customer (Unregistered)",
                children: [
                  _infoRow("Name", order.nonRegisteredName),
                  _infoRow("Number", order.nonRegisteredNumber?.toString()),
                  _infoRow("Address", order.nonRegisteredAddress),
                ],
              ),
            ],
        
        
            if (productList.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildCard(
                title: "Products (${productList.length})",
                children: productList.map((product) {
                  final prod = product.product;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: prod?.photo ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Image.asset(
                                    'assets/logo/Placeholder_image.webp'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prod?.name ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  _infoRow("Category", prod?.catgeory),
                                  _infoRow("Price", "₹${prod?.price ?? '-'}"),
                                  _infoRow("Unit", prod?.unit),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _infoRow("Qty per QR", prod?.quanityPerQr),
                        _infoRow("Ordered", product.orderedQuantity?.toString()),
                        _infoRow("Confirmed", product.confirmedQuantity?.toString()),
                        _infoRow("Dispatched", product.dispatchedQuantity?.toString()),
                        const Divider(height: 24),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
        
          ],
        ),
      ),
    );
  }

  // Section Card
  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  // Key-Value Rows
  Widget _infoRow(String key, String? value, {bool highlight = false, bool isWarning = false}) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
      color: isWarning ? Colors.red : Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text("$key:", style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value ?? "-", style: textStyle)),
        ],
      ),
    );
  }
}