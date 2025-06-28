import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/screens/authentication/login_screen.dart';
import 'package:krishco/widgets/custom_button.dart';

class DefaultScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Error',style: TextStyle(fontSize: 16.0),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Something went wrong!\nYour group type doesn\'t match the expected groups.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 24.0,),
            CustomElevatedButton(text: 'Login with another account', onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (route)=> false);
            })
          ],
        ),
      ),
    );
  }

}