import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/channel_partner_notification_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/navigations/channel_partner_home_screen.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/navigations/channel_partner_my_wallet.dart';
import 'package:krishco/dashboard_type/user_ui/screens/navigations/user_helpline_screen.dart';
import 'package:krishco/dashboard_type/user_ui/screens/navigations/user_home_screen.dart';
import 'package:krishco/dashboard_type/user_ui/screens/navigations/user_rules_screen.dart';
import 'package:krishco/dashboard_type/user_ui/screens/user_myearnings_screen.dart';
import 'package:krishco/dashboard_type/user_ui/screens/navigations/user_redemption_screen.dart';
import 'package:krishco/dashboard_type/user_ui/screens/user_notification_screen.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/screens/authentication/login_screen.dart';
import 'package:krishco/screens/change_password_screen.dart';
import 'package:krishco/screens/claim_invoice/claim_invoice_screen.dart';
import 'package:krishco/screens/edit_details_screen.dart';
import 'package:krishco/screens/kyc_screen.dart';
import 'package:krishco/screens/orders/orders_screen.dart';
import 'package:krishco/screens/redemeption_catalogues/redemption_catalogues.dart';
import 'package:krishco/screens/scan_code_screen.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/screens/support/query_list_screen.dart';
import 'package:krishco/screens/support/support_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';


// class UserDashboard extends StatefulWidget {
//   @override
//   State<UserDashboard> createState() => _UserDashboardState();
// }
//
// class _UserDashboardState extends State<UserDashboard> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int _currentIndex = 0;
//   List<String> _title = ['Home','My Earnings','My Redemption','Support'];
//   List<Widget> _screens = [UserHomeScreen(),MyEarningsScreen(),UserRedemptionScreen(),UserHelplineScreen(),];
//
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         leading: IconButton(onPressed: (){
//           _scaffoldKey.currentState?.openDrawer();
//         }, icon: Icon(Icons.menu,color: CustColors.white,)),
//         titleSpacing: 0,
//         title: Text(
//           _title[_currentIndex],
//           style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustColors.white),
//         ),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.shopping_cart,color: CustColors.white,),
//                 onPressed: () {},
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: CircleAvatar(
//                   radius: 8,
//                   backgroundColor: Colors.green,
//                   child: const Text("3", style: TextStyle(fontSize: 12, color: Colors.white)),
//                 ),
//               )
//             ],
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.notifications,color: CustColors.white,),
//                 onPressed: () {},
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: CircleAvatar(
//                   radius: 8,
//                   backgroundColor: Colors.green,
//                   child: const Text("1", style: TextStyle(fontSize: 12, color: Colors.white)),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//       body: IndexedStack(index: _currentIndex, children: _screens),
//       drawer: _drawerUI(),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//           backgroundColor: CustColors.nile_blue,
//           iconSize: screenWidth * 0.055,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.grey,
//           currentIndex: _currentIndex,
//           unselectedFontSize: screenWidth * 0.03,
//           selectedFontSize: screenWidth * 0.03,
//           onTap: (selectedIndex){
//           setState(() {
//             _currentIndex = selectedIndex;
//           });
//           },
//           items: [
//             BottomNavigationBarItem(icon: Padding(
//               padding: const EdgeInsets.only(bottom: 2.0),
//               child: Icon(FontAwesomeIcons.home,),
//             ),label: 'Home',),
//             BottomNavigationBarItem(icon: Padding(
//               padding: const EdgeInsets.only(bottom: 2.0),
//               child: Icon(FontAwesomeIcons.wallet,),
//             ),label: 'My Earnings'),
//             BottomNavigationBarItem(icon: Padding(
//               padding: const EdgeInsets.only(bottom: 2.0),
//               child: Icon(FontAwesomeIcons.receipt,),
//             ),label: 'My Redemption'),
//             BottomNavigationBarItem(icon: Padding(
//               padding: const EdgeInsets.only(bottom:0),
//               child: Icon(FontAwesomeIcons.handshake,),
//             ),label: 'Support'),
//           ]
//       ),
//     );
//   }
//
//   Widget _drawerUI() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Drawer(
//       width: screenWidth * 0.8,
//       child: Column(
//         children: [
//           _buildHeader(screenWidth, screenHeight),
//           _buildMenuList(screenWidth * 0.8),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(double screenWidth, double screenHeight) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.only(bottom: (screenWidth * 0.8) * 0.06),
//       decoration: BoxDecoration(
//         color: Color(0xFF003366),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: (screenWidth * 0.8)*0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//              Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Text('Member Since: Jul 2020',
//                          style: TextStyle(color: Colors.white, fontSize: (screenWidth * 0.8)*0.04)),
//                      Text('Version v 1.1.1',
//                          style: TextStyle(color: Colors.white, fontSize: (screenWidth * 0.8)*0.04)),
//                    ],
//                  ),
//                  Spacer(),
//                  IconButton(color: Colors.redAccent,onPressed: ()async{
//                    await Pref.instance.clear();
//                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> LoginScreen()), (route)=> false);
//                  }, icon: Icon(Icons.power_settings_new_rounded),)
//                ],
//              ),
//               SizedBox(height: screenHeight * 0.03,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CircleAvatar(
//                     radius: screenWidth * 0.09,
//                     backgroundImage: NetworkImage(
//                       'https://storage.googleapis.com/a1aa/image/1Nw9AKnYhYQN0r9c84ds1zLvkMHs0g8WcmmxtFI8eXw.jpg',
//                     ),
//                   ),
//                   SizedBox(width: (screenWidth * 0.8) * 0.04),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Saurabh Singh',
//                             style: TextStyle(
//                                 color: Colors.white, fontWeight: FontWeight.bold, fontSize: (screenWidth * 0.8)*0.05)),
//                         Text('Membership ID: xxxxxxxxxx',
//                             style: TextStyle(color: Colors.white, fontSize:(screenWidth * 0.8)*0.04 )),
//                         Text('Total Points: XXXXXX',
//                             style: TextStyle(color: Colors.white, fontSize: (screenWidth * 0.8)*0.04)),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.02,),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuList(double screenWidth) {
//     final List<Map<String, dynamic>> menuItems = [
//       {'icon': FontAwesomeIcons.solidCircleUser, 'label': 'Profile'},
//       {'icon': FontAwesomeIcons.handHoldingUsd, 'label': 'Claim Points'},
//       {'icon': FontAwesomeIcons.clipboardCheck, 'label': 'Claim Status'},
//       {'icon': FontAwesomeIcons.wallet, 'label': 'My Earnings'},
//       {'icon': FontAwesomeIcons.bullhorn, 'label': 'My Promotions'},
//       {'icon': FontAwesomeIcons.shoppingCart, 'label': 'Redemption Catalogue'},
//       {'icon': FontAwesomeIcons.gift, 'label': 'My Redemption'},
//       {'icon': FontAwesomeIcons.heart, 'label': 'Wishlist'},
//       {'icon': FontAwesomeIcons.gift, 'label': 'Dream Gift'},
//       {'icon': FontAwesomeIcons.questionCircle, 'label': 'Lodge Query'},
//       {'icon': FontAwesomeIcons.circleInfo, 'label': 'Helpline'},
//     ];
//     return Expanded(
//       child: ListView.separated(
//         padding: EdgeInsets.zero,
//         itemCount: menuItems.length,
//         separatorBuilder: (_, __) => Divider(color: Colors.grey[300], height: 1),
//         itemBuilder: (context, index) {
//           return ListTile(
//             contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//             minLeadingWidth: 0,
//             leading: Icon(menuItems[index]['icon'], color: Colors.black54,size: screenWidth * 0.07,),
//             title: Text(menuItems[index]['label'],
//                 style: Theme.of(context).textTheme.bodyLarge,),
//             onTap: () {},
//           );
//         },
//       ),
//     );
//   }
//
//
// }

class UserDashboard extends StatefulWidget {
  @override
  State<UserDashboard> createState() =>
      _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final List<String> _titles = ['Home', 'Claims', 'Orders', 'Rules Book'];
  int _currentIndex = 0;
  final List<Widget> _screens = [ChannelPartnerHomeScreen(),ClaimScreen(),OrdersScreen(),UserRulesScreen()];

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
        _bottomNavBarItem(iconData: 'assets/icons/dolly-flatbed-alt.webp', label: 'Orders'),
        _bottomNavBarItem(iconData: 'assets/icons/rules-alt.webp', label: 'Rules Book'),
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

        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: CustColors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserNotificationScreen()));
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
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            _buildMenu(iconData:  'assets/icons/edit.webp', label: 'Edit Details',onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditDetailsScreen(onUpdated: (){
                                _init();
                              },)));
                            }),
                            Divider(height: 2,),
                            _buildMenu(iconData: 'assets/icons/lock.webp', label: 'Change Password',onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));
                            }),
                            _buildMenu(iconData: 'assets/icons/coins.webp', label: 'Claim Points',onTap: (){
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));
                            }),
                            _buildMenu(iconData: 'assets/icons/task-checklist.webp', label: 'Claim Status',onTap: (){
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));
                            }),
                            _buildMenu(iconData: 'assets/icons/wallet.webp', label: 'My Earnings',onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyEarningsScreen(

                              )));
                            }),
                            _buildMenu(iconData: 'assets/icons/gift.webp', label: 'Redemption Catalogues',onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RedemptionCataloguesScreen(
                                title: 'Redemption Catalogues',
                              )));
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
                        ),
                      ),
                      // Spacer(),
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
    WidgetsBinding.instance.addPostFrameCallback((duration)async{
      final data = await APIService.getInstance(context).getUserDetails.getUserLoginData();
      if(data != null){
        final value = LoginDetailsData.fromJson(data);
        UserState.update(value.data);
      }
    });
  }

}

