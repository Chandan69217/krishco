import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/screens/change_password_screen.dart';
import 'package:krishco/screens/edit_details_screen.dart';
import 'package:krishco/screens/kyc_screen.dart';
import 'package:krishco/screens/product_catalogues/product_catalogue.dart';
import 'package:krishco/screens/authentication/login_screen.dart';
import 'package:krishco/screens/redemeption_catalogues/redemption_catalogues.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/screens/support/query_list_screen.dart';
import 'package:krishco/screens/support/support_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';
import 'screens/customer_notification_screen.dart';
import 'screens/navigations/consumer_home_screen.dart';


class ConsumerDashboard extends StatefulWidget {
  @override
  State<ConsumerDashboard> createState() => _ConsumerDashboardState();
}

class _ConsumerDashboardState extends State<ConsumerDashboard> {
  int _currentIndex = 0;
  final List<String> _titles = ['Home','New Arrivals','Redemption','Support',];
  final List<Widget> _screens = [
    ConsumerHomeScreen(),
    // ConsumerNewArrivalsScreen(),
    ProductCatalogueScreen(
      showNewArrivalsOnly: true,
      selectedTabIndex: 1,
    ),
    // ConsumerRedemptionScreen(),
    RedemptionCataloguesScreen(),
    SupportScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;


    return Scaffold(
      appBar: _appBar(),
      body: IndexedStack(
        index: _currentIndex,
          children: _screens
      ),
      bottomNavigationBar: _buildBottomNavigationBar(screenWidth),
      drawer: _drawerUi(),
    );

  }

  BottomNavigationBarItem _bottomNavBarItem({
    required String iconData,
    required String label,
  }) {
    return BottomNavigationBarItem(
        icon: Image.asset(iconData,width: 20,height: 20,color: Colors.grey,), label: label,
      activeIcon: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 6.0),
        decoration: BoxDecoration(
          color: CustColors.cyan,
          borderRadius: BorderRadius.circular(20.0),
        ),
          child: Image.asset(iconData,width: 20,height: 20,color: CustColors.nile_blue,))
    );
  }

  Widget _buildBottomNavigationBar(double screenWidth){
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        // iconSize: screenWidth * 0.05,
        selectedItemColor: CustColors.nile_blue,
        unselectedLabelStyle: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w800),
        selectedLabelStyle: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w800),
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 30,
        items: [
          _bottomNavBarItem(label: 'Home', iconData: 'assets/icons/home_icon.webp'),
          _bottomNavBarItem(label: 'New Arrivals', iconData: 'assets/icons/gift.webp'),
          _bottomNavBarItem(label: 'Redemption', iconData: 'assets/icons/shop_icon.webp'),
          _bottomNavBarItem(label: 'Support', iconData: 'assets/icons/customer-service.webp'),
        ]);
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
        // IconButton(onPressed: (){
        //   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScanCodeScreen()));
        // }, icon: Icon(Icons.qr_code_scanner)),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: CustColors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ConsumerNotificationScreen()));
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
                              _buildMenu(iconData: 'assets/icons/comment_icons.webp', label: 'Suggestions & Queries',onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> QueryListScreen()));
                              }),
                              _buildMenu(iconData: 'assets/icons/headset_icon.webp', label: 'Need Help?',onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SupportScreen(showAppBar: true,)));
                              }),
                              _buildMenu(iconData:'assets/icons/logout_icon.webp', label: 'Logout',onTap: (){
                                Pref.instance.clear();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                      (route) => false,
                                );
                              }),
                            ],
                          )
                      ),
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

