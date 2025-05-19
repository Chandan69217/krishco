import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/screens/authentication/login_screen.dart';
import 'package:krishco/screens/splash/splash_screen.dart';

class InfluencerDashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Influencer Dashboard'),
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