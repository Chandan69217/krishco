import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';


import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ConsumerProfileScreen extends StatefulWidget {
  @override
  State<ConsumerProfileScreen> createState() => _ConsumerProfileScreenState();
}

class _ConsumerProfileScreenState extends State<ConsumerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header with background
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.teal.shade300],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                  AssetImage('assets/profile_placeholder.png'),
                ),
                SizedBox(height: 12),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Body content
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                _buildProfileTile(
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    // Navigate to edit profile
                  },
                ),
                _buildProfileTile(
                  icon: Icons.verified_user,
                  title: 'KYC Verification',
                  subtitle: 'Verify your identity',
                  onTap: () {
                    // Navigate to KYC
                  },
                ),
                _buildProfileTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your password securely',
                  onTap: () {
                    // Navigate to change password
                  },
                ),
                _buildProfileTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              // Add logout logic here
                            },
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.withOpacity(0.1),
          child: Icon(icon, color: Colors.teal),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}















// class ConsumerProfileScreen extends StatefulWidget {
//   @override
//   State<ConsumerProfileScreen> createState() => _ConsumerProfileScreenState();
// }
//
// class _ConsumerProfileScreenState extends State<ConsumerProfileScreen> {
//   String? _selectedRegistrationType;
//   List<String> _radioOptions = ['Consumer','Plumber','Dealer','Distributor',];
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: AppBar(
//       //   backgroundColor: CustColors.yellow,
//       //   title: Text('Profile'),
//       //   automaticallyImplyLeading: false,
//       // ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: screenHeight * 0.05),
//           // Registration Box
//           Container(
//             padding: EdgeInsets.only(top: screenWidth * 0.05),
//             margin: EdgeInsets.symmetric(horizontal:screenWidth * 0.05 ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.black.withOpacity(0.1), width: 1.2),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal:  screenWidth *0.06),
//                   child: Text(
//                     'Select Registration Type',
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.05,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.019),
//                 Divider(),
//                 Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
//                       child: RadioOption(
//                         label: _radioOptions[0],
//                         groupVlaue: _selectedRegistrationType,
//                         onChange: (value) {
//                           setState(() {
//                             _selectedRegistrationType = value;
//                           });
//                         },
//                       ),
//                     ),
//                     Divider(),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
//                       child: RadioOption(
//                         label: _radioOptions[1],
//                         groupVlaue: _selectedRegistrationType,
//                         onChange: (value) {
//                           setState(() {
//                             _selectedRegistrationType = value;
//                           });
//                         },
//                       ),
//                     ),
//                     Divider(),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
//                       child: RadioOption(
//                         label: _radioOptions[2],
//                         groupVlaue: _selectedRegistrationType,
//                         onChange: (value) {
//                           setState(() {
//                             _selectedRegistrationType = value;
//                           });
//                         },
//                       ),
//                     ),
//                     Divider(),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
//                       child: RadioOption(
//                         label: _radioOptions[3],
//                         groupVlaue: _selectedRegistrationType,
//                         onChange: (value) {
//                           setState(() {
//                             _selectedRegistrationType = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//
//           // Go Button
//           SizedBox(height: screenHeight * 0.05),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: CustColors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(topLeft: Radius.circular(screenWidth * 0.05),bottomLeft: Radius.circular(screenWidth * 0.05)),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'GO',
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.05,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Icon(
//                     Icons.arrow_forward,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: screenWidth * 0.01),
//         ],
//       ),
//     );
//   }
// }
//
// class RadioOption extends StatelessWidget {
//   final String label;
//   final String? groupVlaue;
//   final Function(String? vlaue)? onChange;
//
//   const RadioOption({required this.label,this.groupVlaue,this.onChange});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (onChange != null) {
//           onChange!(label);
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           children: [
//             Radio(
//               activeColor: CustColors.yellow,
//               value: label,
//               groupValue: groupVlaue,
//               onChanged: onChange,
//             ),
//             Text(
//               label,
//               style: TextStyle(fontSize: 16, color: Colors.black),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
