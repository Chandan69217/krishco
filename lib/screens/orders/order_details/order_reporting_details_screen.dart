import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/models/order_related/order_product_data.dart';
import 'package:krishco/models/order_related/order_reporting_list_data.dart';

class OrderReportingDetailsScreen extends StatelessWidget {
  final OrderReportingData data;

  const OrderReportingDetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final order = data.order!;
    final productList = order.orderProduct;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporting Message Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Message
            Text(
              data.message ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
        
            // Order Info
            _buildInfoRow("Order No", order.orderNo),
            _buildInfoRow("Status", order.orderStatus),
            _buildInfoRow("Date", order.orderDate.toString()),
            const SizedBox(height: 16),
        
            // Ordered From
            Text("Ordered From", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            _buildOrderedForm(order.orderedFrom),
        
            const SizedBox(height: 12),
        
            Text("Ordered For", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            _buildOrderedForm(order.orderedFor),
        
            const SizedBox(height: 12),
            // Ordered By
            Text("Ordered By", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            _buildOrderedBy(order.addBy),
        
            const SizedBox(height: 16),
        
            // Product List
            Text("Products", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...productList.map((item) => _buildProductCard(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? "N/A")),
        ],
      ),
    );
  }

  Widget _buildOrderedForm(OrderedF? user) {

    if (user == null) return const SizedBox.shrink();

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: const Icon(Icons.person_outline),
        title: Text(user.name ?? 'N/A'),
        subtitle: Text("${user.groupType ?? '-'} - ${user.groupName ?? '-'}"),
        trailing: Text(user.number ?? 'N/A'),
      ),
    );
  }

  Widget _buildOrderedBy(AddBy? user) {

    if (user == null) return const SizedBox.shrink();

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: const Icon(Icons.person_outline),
        title: Text(user.name ?? 'N/A'),
        subtitle: Text("${user.groupType ?? '-'} - ${user.groupName ?? '-'}"),
        trailing: Text(user.number ?? 'N/A'),
      ),
    );
  }

  // Widget _buildOrderedFor(OrderedF? user) {
  //
  //   if (user == null) return const SizedBox.shrink();
  //
  //   return Card(
  //     color: Colors.white,
  //     margin: const EdgeInsets.symmetric(vertical: 6),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     elevation: 1,
  //     child: ListTile(
  //       leading: const Icon(Icons.person_outline),
  //       title: Text(user.name ?? 'N/A'),
  //       subtitle: Text("${user.groupType ?? '-'} - ${user.groupName ?? '-'}"),
  //       trailing: Text(user.number ?? 'N/A'),
  //     ),
  //   );
  // }

  Widget _buildProductCard(OrderProduct item) {
    final product = item.product;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: product?.photo ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/logo/Placeholder_image.webp'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product?.name ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Category: ${product?.catgeory ?? '-'}"),
                  Text("Price: ₹${product?.price ?? '-'}"),
                  Text("Ordered Qty: ${item.orderedQuantity ?? '-'} ${product?.unit ?? ''}"),
                  if (item.confirmedQuantity != null)
                    Text("Confirmed Qty: ${item.confirmedQuantity}"),
                  if (item.dispatchedQuantity != null)
                    Text("Dispatched Qty: ${item.dispatchedQuantity}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}