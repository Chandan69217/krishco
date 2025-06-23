// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:krishco/utilities/cust_colors.dart';
//
//
// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
//
// // class ConsumerRedemptionScreen extends StatefulWidget {
// //   @override
// //   State<ConsumerRedemptionScreen> createState() => _ConsumerRedemptionScreenState();
// // }
// //
// // class _ConsumerRedemptionScreenState extends State<ConsumerRedemptionScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.grey[100],
// //       body: Column(
// //         children: [
// //           // Header with background
// //           // Container(
// //           //   width: double.infinity,
// //           //   padding: EdgeInsets.symmetric(vertical: 40),
// //           //   decoration: BoxDecoration(
// //           //     gradient: LinearGradient(
// //           //       colors: [Colors.teal, Colors.teal.shade300],
// //           //       begin: Alignment.topCenter,
// //           //       end: Alignment.bottomCenter,
// //           //     ),
// //           //     borderRadius: BorderRadius.only(
// //           //       bottomLeft: Radius.circular(32),
// //           //       bottomRight: Radius.circular(32),
// //           //     ),
// //           //   ),
// //           //   child: Column(
// //           //     children: [
// //           //       CircleAvatar(
// //           //         radius: 50,
// //           //         backgroundImage:
// //           //         AssetImage('assets/profile_placeholder.png'),
// //           //       ),
// //           //       SizedBox(height: 12),
// //           //       Text(
// //           //         'John Doe',
// //           //         style: TextStyle(
// //           //           fontSize: screenWidth * 0.055,
// //           //           fontWeight: FontWeight.bold,
// //           //           color: Colors.white,
// //           //         ),
// //           //       ),
// //           //       Text(
// //           //         'john.doe@example.com',
// //           //         style: TextStyle(
// //           //           color: Colors.white70,
// //           //           fontSize: 14,
// //           //         ),
// //           //       ),
// //           //     ],
// //           //   ),
// //           // ),
// //           //
// //           // // Body content
// //           // Expanded(
// //           //   child: ListView(
// //           //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
// //           //     children: [
// //           //       _buildProfileTile(
// //           //         icon: Icons.edit,
// //           //         title: 'Edit Profile',
// //           //         subtitle: 'Update your personal information',
// //           //         onTap: () {
// //           //           // Navigate to edit profile
// //           //         },
// //           //       ),
// //           //       _buildProfileTile(
// //           //         icon: Icons.verified_user,
// //           //         title: 'KYC Verification',
// //           //         subtitle: 'Verify your identity',
// //           //         onTap: () {
// //           //           // Navigate to KYC
// //           //         },
// //           //       ),
// //           //       _buildProfileTile(
// //           //         icon: Icons.lock,
// //           //         title: 'Change Password',
// //           //         subtitle: 'Update your password securely',
// //           //         onTap: () {
// //           //           // Navigate to change password
// //           //         },
// //           //       ),
// //           //       _buildProfileTile(
// //           //         icon: Icons.logout,
// //           //         title: 'Logout',
// //           //         subtitle: 'Sign out of your account',
// //           //         onTap: () {
// //           //           showDialog(
// //           //             context: context,
// //           //             builder: (ctx) => AlertDialog(
// //           //               title: Text('Logout'),
// //           //               content: Text('Are you sure you want to logout?'),
// //           //               actions: [
// //           //                 TextButton(
// //           //                   onPressed: () => Navigator.pop(ctx),
// //           //                   child: Text('Cancel'),
// //           //                 ),
// //           //                 TextButton(
// //           //                   onPressed: () {
// //           //                     Navigator.pop(ctx);
// //           //                     // Add logout logic here
// //           //                   },
// //           //                   child: Text('Logout'),
// //           //                 ),
// //           //               ],
// //           //             ),
// //           //           );
// //           //         },
// //           //       ),
// //           //     ],
// //           //   ),
// //           // ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildProfileTile({
// //     required IconData icon,
// //     required String title,
// //     String? subtitle,
// //     required VoidCallback onTap,
// //   }) {
// //     return Card(
// //       elevation: 2,
// //       margin: EdgeInsets.symmetric(vertical: 8),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
// //       child: ListTile(
// //         leading: CircleAvatar(
// //           backgroundColor: Colors.teal.withOpacity(0.1),
// //           child: Icon(icon, color: Colors.teal),
// //         ),
// //         title: Text(
// //           title,
// //           style: TextStyle(fontWeight: FontWeight.w600),
// //         ),
// //         subtitle: subtitle != null ? Text(subtitle) : null,
// //         trailing: Icon(Icons.arrow_forward_ios, size: 16),
// //         onTap: onTap,
// //       ),
// //     );
// //   }
// // }
//
//
//
//
// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
//
// class ConsumerRedemptionScreen extends StatefulWidget {
//   @override
//   _ConsumerRedemptionScreenState createState() => _ConsumerRedemptionScreenState();
// }
//
// class _ConsumerRedemptionScreenState extends State<ConsumerRedemptionScreen> {
//   int points = 1200;
//
//   final List<Map<String, dynamic>> redeemItems = [
//     {
//       'title': 'Gift Voucher',
//       'description': '₹500 Amazon Gift Card',
//       'points': 1000,
//       'icon': Icons.card_giftcard
//     },
//     {
//       'title': 'Mobile Recharge',
//       'description': '₹100 Prepaid Recharge',
//       'points': 300,
//       'icon': Icons.phone_android
//     },
//     {
//       'title': 'Coffee Mug',
//       'description': 'Custom Branded Mug',
//       'points': 250,
//       'icon': Icons.local_cafe
//     },
//   ];
//
//   void _redeemItem(int cost) {
//     if (points >= cost) {
//       setState(() {
//         points -= cost;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Redemption successful!')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Insufficient points')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Colors.teal,
//       //   elevation: 0,
//       //   centerTitle: true,
//       //   title: const Text('Redemption'),
//       // ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildPointsCard(),
//             const SizedBox(height: 24),
//             Text(
//               'Recent Redeems',
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: redeemItems.length,
//                 itemBuilder: (context, index) {
//                   final item = redeemItems[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 3,
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(16),
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.teal.shade100,
//                         child: Icon(item['icon'], color: Colors.teal.shade800),
//                       ),
//                       title: Text(
//                         item['title'],
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal.shade900,
//                         ),
//                       ),
//                       subtitle: Padding(
//                         padding: const EdgeInsets.only(top: 4),
//                         child: Text(
//                           item['description'],
//                           style: TextStyle(color: Colors.grey[700]),
//                         ),
//                       ),
//                       trailing: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             '${item['points']} pts',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.teal.shade700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Redeemed',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPointsCard() {
//     return Card(
//       color: Colors.teal.shade100,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           children: [
//             Icon(Icons.stars, size: 40, color: Colors.teal.shade700),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Your Points',
//                   style: TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$points',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.teal.shade900,
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
// // class ConsumerProfileScreen extends StatefulWidget {
// //   @override
// //   State<ConsumerProfileScreen> createState() => _ConsumerProfileScreenState();
// // }
// //
// // class _ConsumerProfileScreenState extends State<ConsumerProfileScreen> {
// //   String? _selectedRegistrationType;
// //   List<String> _radioOptions = ['Consumer','Plumber','Dealer','Distributor',];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final screenHeight = MediaQuery.of(context).size.height;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       // appBar: AppBar(
// //       //   backgroundColor: CustColors.yellow,
// //       //   title: Text('Profile'),
// //       //   automaticallyImplyLeading: false,
// //       // ),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           SizedBox(height: screenHeight * 0.05),
// //           // Registration Box
// //           Container(
// //             padding: EdgeInsets.only(top: screenWidth * 0.05),
// //             margin: EdgeInsets.symmetric(horizontal:screenWidth * 0.05 ),
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(10),
// //               border: Border.all(color: Colors.black.withOpacity(0.1), width: 1.2),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(horizontal:  screenWidth *0.06),
// //                   child: Text(
// //                     'Select Registration Type',
// //                     style: TextStyle(
// //                       fontSize: screenWidth * 0.05,
// //                       fontWeight: FontWeight.w500,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: screenHeight * 0.019),
// //                 Divider(),
// //                 Column(
// //                   children: [
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
// //                       child: RadioOption(
// //                         label: _radioOptions[0],
// //                         groupVlaue: _selectedRegistrationType,
// //                         onChange: (value) {
// //                           setState(() {
// //                             _selectedRegistrationType = value;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                     Divider(),
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
// //                       child: RadioOption(
// //                         label: _radioOptions[1],
// //                         groupVlaue: _selectedRegistrationType,
// //                         onChange: (value) {
// //                           setState(() {
// //                             _selectedRegistrationType = value;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                     Divider(),
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
// //                       child: RadioOption(
// //                         label: _radioOptions[2],
// //                         groupVlaue: _selectedRegistrationType,
// //                         onChange: (value) {
// //                           setState(() {
// //                             _selectedRegistrationType = value;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                     Divider(),
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
// //                       child: RadioOption(
// //                         label: _radioOptions[3],
// //                         groupVlaue: _selectedRegistrationType,
// //                         onChange: (value) {
// //                           setState(() {
// //                             _selectedRegistrationType = value;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 )
// //               ],
// //             ),
// //           ),
// //
// //           // Go Button
// //           SizedBox(height: screenHeight * 0.05),
// //           Align(
// //             alignment: Alignment.bottomRight,
// //             child: ElevatedButton(
// //               onPressed: () {},
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: CustColors.green,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(screenWidth * 0.05),bottomLeft: Radius.circular(screenWidth * 0.05)),
// //                 ),
// //                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Text(
// //                     'GO',
// //                     style: TextStyle(
// //                       fontSize: screenWidth * 0.05,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   SizedBox(width: 10),
// //                   Icon(
// //                     Icons.arrow_forward,
// //                     color: Colors.white,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: screenWidth * 0.01),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class RadioOption extends StatelessWidget {
// //   final String label;
// //   final String? groupVlaue;
// //   final Function(String? vlaue)? onChange;
// //
// //   const RadioOption({required this.label,this.groupVlaue,this.onChange});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         if (onChange != null) {
// //           onChange!(label);
// //         }
// //       },
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 8.0),
// //         child: Row(
// //           children: [
// //             Radio(
// //               activeColor: CustColors.yellow,
// //               value: label,
// //               groupValue: groupVlaue,
// //               onChanged: onChange,
// //             ),
// //             Text(
// //               label,
// //               style: TextStyle(fontSize: 16, color: Colors.black),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
