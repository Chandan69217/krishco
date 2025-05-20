import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/change_password_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/channel_partner_notification_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/edit_details_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/kyc_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/navigations/claim_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/navigations/home_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/navigations/my_wallet.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/navigations/orders_screen.dart';
import 'package:krishco/screens/authentication/login_screen.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/cust_colors.dart';

class ChannelPartnerDashboard extends StatefulWidget {
  @override
  State<ChannelPartnerDashboard> createState() =>
      _ChannelPartnerDashboardState();
}

class _ChannelPartnerDashboardState extends State<ChannelPartnerDashboard> {
  final List<String> _titles = ['Home', 'Claims', 'Orders', 'My Wallet'];
  int _currentIndex = 0;
  final List<Widget> _screens = [HomeScreen(),ClaimScreen(),OrdersScreen(),MyWallet()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      drawer: _drawerUi(),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  BottomNavigationBar _bottomNavBar() {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      currentIndex: _currentIndex,
      items: <BottomNavigationBarItem>[
        _bottomNavBarItem(iconData: Icons.home, label: 'Home'),
        _bottomNavBarItem(iconData: Icons.receipt_long, label: 'Claim'),
        _bottomNavBarItem(iconData: Icons.inventory_2, label: 'Orders'),
        _bottomNavBarItem(iconData: Icons.wallet, label: 'My Wallet'),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavBarItem({
    required IconData iconData,
    required String label,
  }) {
    return BottomNavigationBarItem(icon: Icon(iconData), label: label);
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        _titles[_currentIndex],
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: CustColors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChannelPartnerNotificationScreen()));
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.green,
                child: const Text(
                  "1",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Drawer _drawerUi() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: CustColors.nile_blue),
              child: SafeArea(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60.0,
                      backgroundImage: AssetImage('assets/logo/dummy_profile.webp'),
                    ),
                    const SizedBox(height: 6,),
                    Text('Channel Partner',style: TextStyle(color: Colors.white),),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(height: 1.2, fontSize: 16), // Common text style
                        children: [
                          TextSpan(
                            text: 'Cp Testing ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: '(Approved)',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(color: CustColors.white),
              child: Column(
                children: [
                  _buildMenu(iconData:  Icons.edit, label: 'Edit Details',onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditDetailsScreen()));
                  }),
                  _buildMenu(iconData: Icons.badge, label: 'KYC Details',onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>KycScreen()));
                  },
                    trailing: Text('Pending',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.orange),)
                  ),
                  Divider(height: 2,),
                  _buildMenu(iconData: Icons.lock, label: 'Change Password',onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));
                  }),
                  _buildMenu(iconData: Icons.logout, label: 'Logout',onTap: (){
                    Pref.instance.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                    );
                  }),
                  Spacer(),
                  Text('Version: 1.32.0',style: TextStyle(color: Colors.grey),),
                  const SizedBox(height: 12.0,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMenu({required IconData iconData, required String label,VoidCallback? onTap,Widget? trailing}){
    return ListTile(
      trailing: trailing,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
      minLeadingWidth: 0,
      leading: Icon(iconData, color: Colors.black54,),
      title: Text(label,
        style: Theme.of(context).textTheme.bodyLarge,),
      onTap: onTap,
    );
  }

}
