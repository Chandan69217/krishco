import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';


class ConsumerNewArrivalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(screenHeight * 0.12),
      //   child: AppBar(
      //     automaticallyImplyLeading: false,
      //     backgroundColor: CustColors.yellow,
      //     title: Padding(
      //       padding: EdgeInsets.only(top: (screenHeight * 0.12) * 0.02), // Add some top padding for alignment
      //       child: Text(
      //         'New Arrivals',
      //         style: TextStyle(fontSize: (screenHeight * 0.12) * 0.16, fontWeight: FontWeight.bold),
      //       ),
      //     ),
      //     bottom: PreferredSize(
      //       preferredSize: Size.fromHeight((screenHeight * 0.12) * 0.45),
      //       child: Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //         child: Container(
      //           height: (screenHeight * 0.12) * 0.45,
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.circular(25),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.black.withOpacity(0.1),
      //                 blurRadius: 4,
      //                 offset: Offset(0, 2),
      //               ),
      //             ],
      //           ),
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Padding(
      //                 padding: EdgeInsets.symmetric(horizontal: (screenHeight * 0.12) * 0.1),
      //                 child: Icon(
      //                   Icons.search,
      //                   color: Colors.grey[600],
      //                 ),
      //               ),
      //               Expanded(
      //                 child: TextField(
      //                   decoration: InputDecoration(
      //                     hintText: 'Search',
      //                     border: InputBorder.none,
      //                     contentPadding: EdgeInsets.zero,
      //                   ),
      //                   style: TextStyle(fontSize: (screenHeight * 0.12) * 0.15,),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            // Content area with image
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.transparent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: (screenHeight * 0.12) * 0.15,),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text('Empty'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

