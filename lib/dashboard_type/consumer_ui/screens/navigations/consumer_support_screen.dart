import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';

import 'package:flutter/material.dart';


class ConsumerSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: CustColors.nile_blue,
      //   centerTitle: true,
      //   title: const Text('About & Support'),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(Icons.support_agent, size: 40, color: CustColors.nile_blue),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Krishco Solutions',
                    style: TextStyle(fontSize: screenHeight * 0.03, fontWeight: FontWeight.bold, color: CustColors.nile_blue),
                  ),
                ),
                Center(
                  child: Container(
                    width: screenWidth * 0.2,
                    height: 2,
                    margin: const EdgeInsets.only(top: 6, bottom: 20),
                    color: CustColors.nile_blue,
                  ),
                ),

                SectionTitle('About Us', screenWidth * 0.045),
                SectionContent(
                  'Krishco Solutions Private Limited is a celebrated name in Rajkot, known for manufacturing and supplying superior quality products.',
                  screenWidth * 0.035,
                ),
                const SizedBox(height: 20),

                SectionTitle('Our Factory', screenWidth * 0.045),
                SectionContent(
                  'We operate a modern, state-of-the-art facility in Rajkot to ensure quality and efficiency.',
                  screenWidth * 0.035,
                ),
                const SizedBox(height: 20),

                SectionTitle('Our Team', screenWidth * 0.045),
                SectionContent(
                  'A team of dedicated and experienced professionals ensures smooth operations and high-quality output.',
                  screenWidth * 0.035,
                ),
                const SizedBox(height: 24),

                SectionTitle('Quick Info', screenWidth * 0.045),
                const SizedBox(height: 12),
                _infoBox(screenWidth),

                const SizedBox(height: 24),
                SectionTitle('Need Help?', screenWidth * 0.045),
                const SizedBox(height: 12),
                _supportBox(screenWidth, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoBox(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: CustColors.cyan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          infoRow('CEO', 'Mr. Mitul Patel', screenWidth),
          infoRow('Established', '2020', screenWidth),
          infoRow('Business', 'Manufacturer & Supplier', screenWidth),
          infoRow('GST No.', '24AALCP1709K1ZB', screenWidth),
        ],
      ),
    );
  }

  Widget _supportBox(double screenWidth, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: CustColors.cyan,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.phone, color: CustColors.nile_blue),
            title: Text('Call Customer Care'),
            subtitle: Text('+91 98765 43210'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Replace with actual dialer logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling support...')),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email, color: CustColors.nile_blue),
            title: Text('Email Support'),
            subtitle: Text('support@krishco.com'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Replace with actual email logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening email client...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget infoRow(String label, String value, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenWidth * 0.035)),
          ),
          Text(': '),
          Expanded(
            flex: 5,
            child: Text(value, style: TextStyle(fontSize: screenWidth * 0.033)),
          ),
        ],
      ),
    );
  }

  Widget SectionTitle(String title, double fontSize) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: CustColors.nile_blue,
      ),
    );
  }

  Widget SectionContent(String content, double fontSize) {
    return Text(
      content,
      style: TextStyle(fontSize: fontSize, height: 1.6, color: Colors.black87),
    );
  }
}









