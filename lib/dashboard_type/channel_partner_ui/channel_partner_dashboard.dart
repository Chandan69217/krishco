import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/screens/authentication/login_screen.dart';
import 'package:krishco/screens/splash/splash_screen.dart';

class ChannelPartnerDashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Channel Partner Dashboard'),
            ElevatedButton(onPressed: (){
              Pref.instance.clear();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (route)=>false);
            }, child: Text('Logout'))
          ],
        ),
      ),
    );
  }

}