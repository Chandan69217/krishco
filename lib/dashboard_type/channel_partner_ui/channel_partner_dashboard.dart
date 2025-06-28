import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/screens/change_password_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/channel_partner_notification_screen.dart';
import 'package:krishco/screens/edit_details_screen.dart';
import 'package:krishco/screens/kyc_screen.dart';
import 'package:krishco/screens/claim_invoice/claim_invoice_screen.dart';
import 'package:krishco/screens/support/query_list_screen.dart';
import 'package:krishco/screens/support/support_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/navigations/channel_partner_home_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/navigations/channel_partner_my_wallet.dart';
import 'package:krishco/screens/orders/orders_screen.dart';
import 'package:krishco/screens/authentication/login_screen.dart';
import 'package:krishco/screens/scan_code_screen.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';


class ChannelPartnerDashboard extends StatefulWidget {
  @override
  State<ChannelPartnerDashboard> createState() =>
      _ChannelPartnerDashboardState();
}

class _ChannelPartnerDashboardState extends State<ChannelPartnerDashboard> {
  final List<String> _titles = ['Home', 'Claims', 'Orders', 'My Wallet'];
  int _currentIndex = 0;
  final GlobalKey<ClaimScreenState> _claimKey = GlobalKey<ClaimScreenState>();
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _init();
  }

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
      selectedItemColor: CustColors.nile_blue,
      unselectedLabelStyle: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w800),
      selectedLabelStyle: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w800),
      items: <BottomNavigationBarItem>[
        _bottomNavBarItem(iconData: 'assets/icons/home_icon.webp', label: 'Home'),
        _bottomNavBarItem(iconData: 'assets/icons/point-of-sale-bill.webp', label: 'Claim'),
        _bottomNavBarItem(iconData: 'assets/icons/order-history.webp', label: 'Orders'),
        _bottomNavBarItem(iconData: 'assets/icons/wallet.webp', label: 'My Wallet'),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavBarItem({
    required String iconData,
    required String label,
  }) {
    return BottomNavigationBarItem(
        icon: Image.asset(iconData,width: 20,height: 20,color: Colors.grey,),
        label: label,
        activeIcon: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 6.0),
            decoration: BoxDecoration(
              color: CustColors.cyan,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Image.asset(iconData,width: 20,height: 20,color: CustColors.nile_blue,))
    );
  }
  AppBar _appBar() {
    return AppBar(
      shape: _currentIndex == 3 ? const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0))):null,
      title: Text(
        _titles[_currentIndex],
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      actions: [
        IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScanCodeScreen()));
        }, icon: Icon(Icons.qr_code_scanner)),
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
      child: ValueListenableBuilder(
        valueListenable: UserState.userData,
        builder: (context,value,child){
          return Column(
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
                        CustomNetworkImage(
                          placeHolder: 'assets/logo/dummy_profile.webp',
                          width: 130.0,
                            height: 130.0,
                            borderRadius: BorderRadius.circular(80.0),
                            imageUrl:value?.photo,
                        ),

                        // CircleAvatar(
                        //   radius: 60.0,
                        //   backgroundImage: value != null && value.photo != null && value.photo.isNotEmpty
                        //       ? CachedNetworkImageProvider(value.photo )
                        //       : const AssetImage('assets/logo/dummy_profile.webp') as ImageProvider,
                        // ),
                        //
                        const SizedBox(height: 6,),
                        Text(
                          value != null && value.fname != null && value.fname!.isNotEmpty? '${value.fname} ${value.lname}' :'unknown',
                          style: TextStyle(color: Colors.white),),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Icon(Icons.phone,size: 16.0,),
                        //     SizedBox(width: 4.0,),
                        //     Text(
                        //       Pref.instance.getString(Consts.number)??'',
                        //       style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),),
                        //   ],
                        // ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(height: 1.2, fontSize: 16), // Common text style
                            children: [
                              TextSpan(
                                text: Pref.instance.getString(Consts.group_name)??'',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextSpan(text: ' '),
                              TextSpan(
                                text: Pref.instance.getString(Consts.approval_status)??'',
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
                      Expanded(child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          _buildMenu(iconData:  'assets/icons/edit.webp', label: 'Edit Details',onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditDetailsScreen(onUpdated: (){
                              _init();
                            },)));
                          }),
                          _buildMenu(iconData: 'assets/icons/id-card-clip-alt.webp', label: 'KYC Details',onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>KycScreen()));
                          },
                              trailing: Text(Pref.instance.getString(Consts.kyc_status)??'',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.orange),)
                          ),
                          Divider(height: 2,),
                          _buildMenu(iconData: 'assets/icons/lock.webp', label: 'Change Password',onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));
                          }),
                          _buildMenu(iconData:  'assets/icons/comment_icons.webp', label: 'Suggestions & Queries',onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> QueryListScreen()));
                          }),
                          _buildMenu(iconData:  'assets/icons/headset_icon.webp', label: 'Need Help?',onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SupportScreen(showAppBar: true,)));
                          }),
                          _buildMenu(iconData: 'assets/icons/logout_icon.webp', label: 'Logout',onTap: (){
                            Pref.instance.clear();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                                  (route) => false,
                            );
                          }),
                        ],
                      )),
                      SafeArea(child: Text('Version: ${Consts.app_version}',style: TextStyle(color: Colors.grey),)),
                      const SizedBox(height: 4.0,),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildMenu({required String iconData, required String label,VoidCallback? onTap,Widget? trailing}){
    return ListTile(
      trailing: trailing,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
      minLeadingWidth: 0,
      leading: Image.asset(iconData, color: Colors.black54,width: 22.0,height: 22.0,),
      title: Text(label,
        style: Theme.of(context).textTheme.bodyLarge,),
      onTap: onTap,
    );
  }

  void _init()async {
    _screens = [ChannelPartnerHomeScreen(onRefresh: (){
      _claimKey.currentState?.onRefresh();
    },),ClaimScreen(key: _claimKey,),OrdersScreen(),ChannelPartnerMyWallet()];
    WidgetsBinding.instance.addPostFrameCallback((duration)async{
      final data = await APIService.getInstance(context).getUserDetails.getUserLoginData();
      if(data != null){
        final value = LoginDetailsData.fromJson(data);
        UserState.update(value.data);
      }
    });
  }

}
