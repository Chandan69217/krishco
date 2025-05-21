import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';



class ChannelPartnerMyWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("My Wallet", style: TextStyle(color: Colors.black)),
      //   backgroundColor: Colors.white,
      //   elevation: 1,
      //   iconTheme: IconThemeData(color: Colors.black),
      // ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Wallet Balance
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CustColors.nile_blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Wallet Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
                SizedBox(height: 8),
                Text("₹ 2,350.75", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  children: [
                    _actionButton(context, Icons.add, "Add Money", Colors.green),
                    SizedBox(width: 12),
                    // _actionButton(context, Icons.upload, "Withdraw", Colors.orange),
                    SizedBox(width: 12),
                    _actionButton(context, Icons.receipt_long, "Statement", Colors.blue),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Transaction History Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Transactions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                TextButton(onPressed: () {}, child: Text("View All")),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.account_balance_wallet_rounded, color: Colors.deepPurple),
                    title: Text("Added ₹500"),
                    subtitle: Text("March 27, 2025 at 10:32 AM"),
                    trailing: Text("+ ₹500", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label, Color color) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18,color: color,),
        label: Text(label, style: TextStyle(fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          elevation: 1,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}