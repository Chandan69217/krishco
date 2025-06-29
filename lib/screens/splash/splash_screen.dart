import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/channel_partner_dashboard.dart';
import 'package:krishco/dashboard_type/consumer_ui/consumer_dashboard.dart';
import 'package:krishco/dashboard_type/dashboard_types.dart';
import 'package:krishco/dashboard_type/influencer_ui/influencer_dashboard.dart';
import 'package:krishco/dashboard_type/user_ui/screens/default_screen/default_screen.dart';
import 'package:krishco/dashboard_type/user_ui/user_dashboard.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/login_screen.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    futureCall(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo/krishco-logo-bg.webp',width: screenWidth * 0.9,),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'Service',
            //         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            //           color: Colors.blue,
            //           fontSize: fontSize,
            //           fontWeight: FontWeight.normal,
            //         ),
            //       ),
            //       TextSpan(
            //         text: ' Partner',
            //         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            //           color: Colors.black,
            //           fontSize: fontSize,
            //           fontWeight: FontWeight.normal,
            //         ),
            //       ),
            //     ],
            //   ),
            // )

          ],
        ),
      ),
    );
  }

  futureCall(BuildContext context)async{
    WidgetsBinding.instance.addPostFrameCallback((duration)async{
      Pref.instance = await SharedPreferences.getInstance();
      bool isLogin = Pref.instance.getBool(Consts.isLogin)??false;
      String? group_type = Pref.instance.getString(Consts.group_type);
      GroupRoles.dashboardType = group_type??'';
      GroupRoles.roles = Pref.instance.getStringList(Consts.roles)??[];
      Future.delayed(Duration(seconds: 1),()=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>isLogin&&group_type!=null ? _getScreenByGroup(context,group_type)!:LoginScreen()),(route)=> false));
    });
  }

  Widget? _getScreenByGroup(BuildContext context,String group_type){
    switch(group_type){
      case DashboardTypes.User:
        return UserDashboard();
      case DashboardTypes.customer:
        return ConsumerDashboard();
      case DashboardTypes.channel_partner:
        return ChannelPartnerDashboard();
      case DashboardTypes.influencer:
        return InfluencerDashboard();
      default: return LoginScreen();
    }
  }

}

class Pref{
  Pref._();
  static late SharedPreferences instance;
}

