import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';


class ConsumerNewArrivalsScreen extends StatelessWidget {
  final List<String> categories = ['Taps', 'Pipes', 'Showers', 'Fittings'];
  final List<Map<String, String>> products = [
    {
      'name': 'Stylish Tap',
      'image': 'assets/images/tap1.png',
      'price': '₹450',
      'rating': '4.5',
      'description': 'Elegant chrome finish tap for modern bathrooms.',
    },
    {
      'name': 'Modern Shower',
      'image': 'assets/images/shower1.png',
      'price': '₹1200',
      'rating': '4.8',
      'description': 'Rain shower with adjustable pressure modes.',
    },
    {
      'name': 'PVC Pipe',
      'image': 'assets/images/pipe1.png',
      'price': '₹300',
      'rating': '4.2',
      'description': 'Durable pipe for residential plumbing.',
    },
    {
      'name': 'Angle Valve',
      'image': 'assets/images/valve1.png',
      'price': '₹200',
      'rating': '4.0',
      'description': 'Stainless steel valve for long-term use.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search new arrivals...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // Categories
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00796B),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Product Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomNetworkImage(imageUrl: product['image']!,height: 120,width: double.infinity,fit: BoxFit.cover,
                                borderRadius:  BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text(product['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                                        SizedBox(width: 6.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.star, color: Colors.orange, size: 16),
                                            SizedBox(width: 4),
                                            Text(product['rating']??'', style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(product['price']!, style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text(product['description']??'', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProductDetailsScreen(product: product),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF00796B),
                                        minimumSize: Size(double.infinity, 36),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Text('View Details', style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // "New Arrival" Tag
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'New Arrival',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProductDetailsScreen extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']!),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetworkImage(
                imageUrl: product['image']!,
                height: 280,
                width: double.infinity,
                borderRadius: BorderRadius.zero,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name']!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      product['price']!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        SizedBox(width: 4),
                        Text(product['rating']!, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      product['description'] ?? 'No description available.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Buy action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00796B),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Buy Now', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




