import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/channel_partner_dashboard.dart';
import 'package:krishco/dashboard_type/consumer_ui/consumer_dashboard.dart';
import 'package:krishco/dashboard_type/dashboard_types.dart';
import 'package:krishco/dashboard_type/influencer_ui/influencer_dashboard.dart';
import 'package:krishco/dashboard_type/user_ui/screens/default_screen/default_screen.dart';
import 'package:krishco/dashboard_type/user_ui/user_dashboard.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/screens/authentication/registration_screen.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/cust_loader.dart';
import 'package:krishco/widgets/custom_button.dart';
import '../../api_services/api_urls.dart';
import '../../utilities/constant.dart';
import '../../api_services/handle_https_response.dart';
import '../../widgets/cust_snack_bar.dart';
import '../../widgets/custom_textbutton.dart';
import '../../widgets/custom_textfield.dart';
import '../splash/splash_screen.dart';
import 'forget_screen.dart';

// enum LoginMode { mobile, email }
//
// class LoginScreen extends StatefulWidget {
//   LoginScreen({super.key,});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isChecked = true;
//   final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
//   bool _isLoading = false;
//   final TextEditingController _txtMobileEditingController = TextEditingController(text: "1234567891");
//   final TextEditingController _txtPasswordEditingController = TextEditingController(text: "Shivamraj@1950");
//   final _formKey = GlobalKey<FormState>();
//   bool _passwordVisibility = false;
//
//   LoginMode _loginMode = LoginMode.mobile;
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double fontSize = screenWidth * 0.08;
//     return Scaffold(
//       backgroundColor: CustColors.cyan,
//       body: Form(
//         key: _formKey,
//         child: FormField<bool>(
//           initialValue: _isChecked,
//           validator: (value) {
//             if (value != true) {
//               showSnackBar(context: context, message: 'Accept the terms and conditions', title: 'Check the box',contentType: ContentType.warning);
//               return 'Please accept the terms and conditions';
//             }
//             return null;
//           },
//           builder: (state)=>SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: MediaQuery.of(context).size.height,
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//                 child: SafeArea(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 8.0,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ChoiceChip(
//                             label: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8.0,),
//                               child: Text('Mobile'),
//                             ),
//                             selected: _loginMode == LoginMode.mobile,
//                             selectedColor: Colors.blue.shade100,
//                             backgroundColor: CustColors.cyan,
//                             checkmarkColor: Colors.blue,
//                             labelStyle: TextStyle(
//                               color: _loginMode == LoginMode.mobile ? Colors.blue : Colors.black87,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                               side: BorderSide(
//                                 color: _loginMode == LoginMode.mobile ? Colors.blue : Colors.grey.shade400,
//                               ),
//                             ),
//                             onSelected: (selected) {
//                               setState(() {
//                                 _loginMode = LoginMode.mobile;
//                                 _txtMobileEditingController.clear();
//                               });
//                             },
//                           ),
//                           SizedBox(width: 12),
//                           ChoiceChip(
//                             label: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8.0,),
//                               child: Text('Email'),
//                             ),
//                             selected: _loginMode == LoginMode.email,
//                             selectedColor: Colors.blue.shade100,
//                             backgroundColor: CustColors.cyan,
//                             checkmarkColor: Colors.blue,
//                             labelStyle: TextStyle(
//                               color: _loginMode == LoginMode.email ? Colors.blue : Colors.black87,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                               side: BorderSide(
//                                 color: _loginMode == LoginMode.email ? Colors.blue : Colors.grey.shade400,
//                               ),
//                             ),
//                             onSelected: (selected) {
//                               setState(() {
//                                 _loginMode = LoginMode.email;
//                                 _txtMobileEditingController.clear();
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//
//                       // Here is logo
//                       Image.asset(
//                         'assets/logo/krishco-logo-bg.webp',
//                         height: screenWidth * 0.25,
//                         width: screenWidth * 0.5,
//                       ),
//                       SizedBox(height: screenWidth * 0.05),
//                       // Title
//                       Text(
//                         'PARTNER LOYALTY PROGRAM',
//                         style: TextStyle(
//                           fontSize: fontSize * 0.4,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.05),
//                       // Login Container
//                       Container(
//                         padding: EdgeInsets.only(
//                           top: screenWidth * 0.03,
//                           bottom: screenWidth * 0.08,
//                           left: screenWidth * 0.05,
//                           right: screenWidth * 0.05,
//                         ),
//                         decoration: BoxDecoration(
//                           color: CustColors.white,
//                           borderRadius: BorderRadius.circular(12.0),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 4,
//                               spreadRadius: 1,
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Login',
//                               style: TextStyle(
//                                 fontSize: fontSize,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: screenHeight * 0.035),
//                             CustomFormTextField(
//                               controller: _txtMobileEditingController,
//                               validator: (String? value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter ${_loginMode == LoginMode.mobile ? "mobile number" : "email address"}';
//                                 } else if (_loginMode == LoginMode.mobile && value.length != 10) {
//                                   return 'Enter a valid 10-digit mobile number';
//                                 } else if (_loginMode == LoginMode.email &&
//                                     !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                                   return 'Enter a valid email address';
//                                 }
//                                 return null;
//                               },
//                               maxLength: _loginMode == LoginMode.mobile ? 10 : null,
//                               keyboardType: _loginMode == LoginMode.mobile
//                                   ? TextInputType.number
//                                   : TextInputType.emailAddress,
//                               label: _loginMode == LoginMode.mobile
//                                   ? 'Mobile'
//                                   : 'Email',
//                               prefixIcon: Icon(
//                                   _loginMode == LoginMode.mobile ? Icons.phone : Icons.email),
//                             ),
//                             SizedBox(height: screenHeight * 0.02),
//                             CustomFormTextField(
//                               controller: _txtPasswordEditingController,
//                               validator: (String? value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password !!';
//                                 } else {
//                                   return null;
//                                 }
//                               },
//                               label: 'Password',
//                               prefixIcon: Icon(Icons.lock),
//                               obscureText: !_passwordVisibility,
//                               suffixIcon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _passwordVisibility = !_passwordVisibility;
//                                   });
//                                 },
//                                 icon: Icon(_passwordVisibility
//                                     ? Icons.visibility
//                                     : Icons.visibility_off),
//                               ),
//                             ),
//                             // Forgot Password
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 CustomTextButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               ForgetPasswordScreen()),
//                                     );
//                                   },
//                                   foregroundColor: Colors.grey,
//                                   label: 'Forgot Password?',
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: screenHeight * 0.005),
//                             _isLoading
//                                 ? CustLoader()
//                                 : CustomElevatedButton(
//                               text: 'Log In',
//                               width: screenWidth * 0.45,
//                               onPressed: _login,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => RegistrationScreen()));
//                         },
//                         style: ButtonStyle(
//                           foregroundColor:
//                           MaterialStateProperty.all(CustColors.blue),
//                         ),
//                         child: Text('Create new account?'),
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Checkbox(
//                             checkColor: Colors.white,
//                             activeColor: Colors.black,
//                             side: BorderSide(
//                               color: state.hasError ? Colors.red : Colors.black,
//                             ),
//                             value: _isChecked,
//                             onChanged: (value) {
//                               setState(() {
//                                 _isChecked = value ?? false;
//                                 state.didChange(value);
//                               });
//                             },
//                           ),
//                           Expanded(
//                             child: Text(
//                               'I have read & fully understood the terms and conditions.',
//                               style: TextStyle(
//                                 color: state.hasError ? Colors.red : Colors.grey,
//                                 fontSize: screenWidth * 0.03,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8.0,),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ),
//       ),
//     );
//   }
//
//
//   _login() async {
//     if (_formKey.currentState!.validate()) {
//       String username = _txtMobileEditingController.text;
//       String password = _txtPasswordEditingController.text;
//
//       final List<ConnectivityResult> connectivityResult =
//       await Connectivity().checkConnectivity();
//       if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
//           connectivityResult.contains(ConnectivityResult.wifi) ||
//           connectivityResult.contains(ConnectivityResult.ethernet))) {
//         showSnackBar(
//             context: context,
//             title: 'No Internet',
//             message: 'Your are not connected to any internet provider');
//         return;
//       }
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         var uri = Uri.https(Urls.base_url,Urls.login);
//         var body = json.encode({
//           'username': username,
//           'password': password,
//         });
//
//         var response = await post(uri, body: body, headers: {
//           'Content-Type': 'application/json',
//         });
//
//         // Check status code
//         if (response.statusCode == 200) {
//           var rawData = json.decode(response.body);
//           String token = rawData['data']['token'];
//           String? group_type = rawData['data']['group_type'];
//           String? approval_status = rawData['data']['approval_status'];
//           String? kyc_status = rawData['data']['kyc_status'];
//           String? group_name = rawData['data']['group_name'];
//           String? name = rawData['data']['name'];
//           String? number = rawData['data']['number'];
//           String? email = rawData['data']['email'];
//           String? photo = rawData['data']['photo'];
//           bool? orderForCompany = rawData['data']['order_from_company'];
//           Pref.instance.setString('photo', photo??'');
//           Pref.instance.setBool('order_from_company', orderForCompany??false);
//           Pref.instance.setBool(Consts.isLogin, true);
//           Pref.instance.setString(Consts.user_token, token);
//           Pref.instance.setString(Consts.group_type,group_type??'');
//           Pref.instance.setString(Consts.group_name,group_name??'');
//           Pref.instance.setString(Consts.approval_status,approval_status??'');
//           Pref.instance.setString(Consts.kyc_status,kyc_status??'');
//           Pref.instance.setString(Consts.name,name??'');
//           Pref.instance.setString(Consts.number,number??'');
//           Pref.instance.setString(Consts.email,email??'');
//           showSnackBar(
//               context: context,
//               title: 'Login Success',
//               message: "Thank you for login !!",
//               contentType: ContentType.success);
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>_getScreenByGroup(group_type!)!));
//         } else {
//           await handleHttpResponse(context, response);
//         }
//       } catch (exception, trace) {
//         print('Exception: $exception, Trace: $trace');
//         showSnackBar(
//             context: context,
//             title: 'Opps!',
//             message: 'Network or server error, please check your connection.');
//       }
//
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Widget? _getScreenByGroup(String group_type){
//     switch(group_type){
//       case DashboardTypes.User:
//         return UserDashboard();
//       case DashboardTypes.customer:
//         return ConsumerDashboard();
//       case DashboardTypes.channel_partner:
//         return ChannelPartnerDashboard();
//       case DashboardTypes.influencer:
//         return InfluencerDashboard();
//       default: return null;
//     }
//   }
//
//
// }

enum LoginMode { mobile, email }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController(text: '1234567891');
  final _emailController = TextEditingController(
    text: 'channelpartner@example.com',
  );
  final _mobilePasswordController = TextEditingController(
    text: 'Shivamraj@1950',
  );
  final _emailPasswordController = TextEditingController(
    text: 'Shivamraj@1950',
  );

  late TabController _tabController;
  bool _passwordVisibility = false;
  bool _isLoading = false;
  bool _isChecked = true;

  LoginMode _loginMode = LoginMode.mobile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _loginMode =
            _tabController.index == 0 ? LoginMode.mobile : LoginMode.email;
      });
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    _mobilePasswordController.dispose();
    _emailPasswordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth * 0.085;
    return Scaffold(
      // backgroundColor: CustColors.cyan,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: FormField(
              initialValue: _isChecked,
              validator: (value) {
                if (value != true) {
                  showSnackBar(
                    context: context,
                    message: 'Accept the terms and conditions',
                    title: 'Check the box',
                    contentType: ContentType.warning,
                  );
                  return 'Please accept the terms and conditions';
                }
                return null;
              },
              builder: (state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.04),
                        // Logo
                        Image.asset(
                          'assets/logo/krishco-logo-bg.webp',
                          height: screenWidth * 0.25,
                          width: screenWidth * 0.5,
                        ),

                        const SizedBox(height: 8.0),
                        Text(
                          'PARTNER LOYALTY PROGRAM',
                          style: TextStyle(
                            fontSize: fontSize * 0.4,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Login',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: CustColors.nile_blue,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        // Tab UI
                        Container(
                          padding: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: DefaultTabController(
                            length: 2,
                            initialIndex:
                                _loginMode == LoginMode.mobile ? 0 : 1,
                            child: Column(
                              children: [
                                // SizedBox(height: screenHeight * 0.035),
                                TabBar(
                                  indicatorColor: CustColors.nile_blue,
                                  labelColor: CustColors.nile_blue,
                                  unselectedLabelColor: Colors.grey,
                                  dividerColor: Colors.grey.shade300,
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.w500),
                                  tabs: const [
                                    Tab(text: 'Mobile'),
                                    Tab(text: 'Email'),
                                  ],
                                  onTap: (index) {
                                    setState(() {
                                      _loginMode =
                                          index == 0
                                              ? LoginMode.mobile
                                              : LoginMode.email;
                                      // _mobileController.clear();
                                      // _emailController.clear();
                                      // _passwordController.clear();
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: screenWidth * 0.03,
                                    left: screenWidth * 0.05,
                                    right: screenWidth * 0.05,
                                  ),
                                  height: screenWidth * 0.85,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: TabBarView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            Column(
                                              children: [
                                                const SizedBox(height: 8.0),
                                                CustomFormTextField(
                                                  controller: _mobileController,
                                                  validator: (value) {
                                                    if (_loginMode ==
                                                        LoginMode.email) {
                                                      return null;
                                                    }
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter mobile number';
                                                    }
                                                    if (value.length != 10) {
                                                      return 'Mobile number must be 10 digits';
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  maxLength: 10,
                                                  hintText: 'Mobile',
                                                  prefixIcon: const Icon(
                                                    Icons.phone,
                                                  ),
                                                ),
                                                const SizedBox(height: 30.0),
                                                _buildPasswordFieldAndForgetButton(
                                                  controller:
                                                      _mobilePasswordController,
                                                  validator: (value) {
                                                    if (_loginMode ==
                                                        LoginMode.email) {
                                                      return null;
                                                    }
                                                    return value == null ||
                                                            value.isEmpty
                                                        ? 'Enter password'
                                                        : null;
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(height: 8.0),
                                                CustomFormTextField(
                                                  controller: _emailController,
                                                  validator: (value) {
                                                    if (_loginMode ==
                                                        LoginMode.mobile) {
                                                      return null;
                                                    }
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter email address';
                                                    }
                                                    if (!RegExp(
                                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                                    ).hasMatch(value)) {
                                                      return 'Invalid email format';
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType
                                                          .emailAddress,
                                                  hintText: 'Email',
                                                  prefixIcon: const Icon(
                                                    Icons.email,
                                                  ),
                                                ),
                                                const SizedBox(height: 30.0),
                                                _buildPasswordFieldAndForgetButton(
                                                  controller:
                                                      _emailPasswordController,
                                                  validator: (value) {
                                                    if (_loginMode ==
                                                        LoginMode.mobile) {
                                                      return null;
                                                    }
                                                    return value == null ||
                                                            value.isEmpty
                                                        ? 'Enter password'
                                                        : null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Terms checkbox
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: CustColors.nile_blue,
                                            value: _isChecked,
                                            onChanged: (val) {
                                              setState(() {
                                                _isChecked = val ?? false;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              'I accept the Terms & Conditions',
                                              style: TextStyle(
                                                color:
                                                    _isChecked
                                                        ? Colors.black
                                                        : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Login Button
                                      _isLoading
                                          ? CustLoader(
                                            color: CustColors.nile_blue,
                                          )
                                          : SizedBox(
                                            width: double.infinity,
                                            child: CustomElevatedButton(
                                              backgroundColor:
                                                  CustColors.nile_blue,
                                              forgroundColor: Colors.white,
                                              onPressed: _login,
                                              text: "Log In",
                                            ),
                                          ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RegistrationScreen(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                              CustColors.blue,
                            ),
                          ),
                          child: Text('Create new account?'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordFieldAndForgetButton({
    required TextEditingController controller,
    String? Function(String? value)? validator,
  }) {
    return Column(
      children: [
        CustomFormTextField(
          controller: controller,
          validator: validator,
          hintText: 'Password',
          prefixIcon: const Icon(Icons.lock),
          obscureText: !_passwordVisibility,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisibility ? Icons.visibility : Icons.visibility_off,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                _passwordVisibility = !_passwordVisibility;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ForgetPasswordScreen()),
                );
              },
              label: 'Forgot Password?',
              foregroundColor: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      String username =
          _loginMode == LoginMode.mobile
              ? _mobileController.text
              : _emailController.text;
      String password =
          _loginMode == LoginMode.mobile
              ? _mobilePasswordController.text
              : _emailPasswordController.text;

      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();
      if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet))) {
        showSnackBar(
          context: context,
          title: 'No Internet',
          message: 'Your are not connected to any internet provider',
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });

      try {
        var uri = Uri.https(Urls.base_url, Urls.login);
        var body = json.encode({'username': username, 'password': password});

        var response = await post(
          uri,
          body: body,
          headers: {'Content-Type': 'application/json'},
        );

        // Check status code
        if (response.statusCode == 200) {
          var rawData = json.decode(response.body);
          String token = rawData['data']['token'];
          String group_type = rawData['data']['group_type']??'';
          String? approval_status = rawData['data']['approval_status'];
          String? kyc_status = rawData['data']['kyc_status'];
          String? group_name = rawData['data']['group_name'];
          String? name = rawData['data']['name'];
          String? number = rawData['data']['number'];
          String? email = rawData['data']['email'];
          String? photo = rawData['data']['photo'];
          bool? orderForCompany = rawData['data']['order_from_company'];
          List<dynamic> roles = rawData['data']['role'] != null ? rawData['data']['role']:[];
          Pref.instance.setString('photo', photo ?? '');
          Pref.instance.setBool('order_from_company', orderForCompany ?? false);
          Pref.instance.setBool(Consts.isLogin, true);
          Pref.instance.setString(Consts.user_token, token);
          Pref.instance.setString(Consts.group_type, group_type ?? '');
          Pref.instance.setString(Consts.group_name, group_name ?? '');
          List<String> tempRole = roles.map<String>((e){
            return e;
          }).toList();
          GroupRoles.dashboardType  = group_type;
          GroupRoles.roles = tempRole;
              Pref.instance.setStringList(Consts.roles, tempRole);
          Pref.instance.setString(
            Consts.approval_status,
            approval_status ?? '',
          );
          Pref.instance.setString(Consts.kyc_status, kyc_status ?? '');
          Pref.instance.setString(Consts.name, name ?? '');
          Pref.instance.setString(Consts.number, number ?? '');
          Pref.instance.setString(Consts.email, email ?? '');
          showSnackBar(
            context: context,
            title: 'Login Success',
            message: "Thank you for login !!",
            contentType: ContentType.success,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => _getScreenByGroup(group_type!)!,
            ),
          );
        } else {
          await handleHttpResponse(context, response);
        }
      } catch (exception, trace) {
        print('Exception: $exception, Trace: $trace');
        showSnackBar(
          context: context,
          title: 'Opps!',
          message: 'Something went wrong, Please retry after sometime.',
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget? _getScreenByGroup(String group_type) {
    switch (group_type) {
      case DashboardTypes.User:
        return UserDashboard();
      case DashboardTypes.customer:
        return ConsumerDashboard();
      case DashboardTypes.channel_partner:
        return ChannelPartnerDashboard();
      case DashboardTypes.influencer:
        return InfluencerDashboard();
      default:
        return DefaultScreen();
    }
  }
}

// class LoginScreen extends StatefulWidget {
//   LoginScreen({super.key,});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool isChecked = true;
//   final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double fontSize = screenWidth * 0.08;
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
//         child: SingleChildScrollView(
//           child: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: screenWidth * 0.1,),
//                 Image.asset(
//                   'assets/logo/splash_logo.webp',
//                   height: screenWidth * 0.25,
//                   width: screenWidth * 0.25,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: 'Service',
//                         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                           color: Colors.blue,
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.normal,
//                           height: 1.1
//                         ),
//                       ),
//                       TextSpan(
//                         text: ' Partner',
//                         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                           color: Colors.black,
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.normal,
//                           height: 1.1
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   'PARTNER LOYALTY PROGRAM',
//                   style: TextStyle(
//                     fontSize: fontSize * 0.4,
//                     color: Colors.grey,
//                   ),
//                 ),
//
//                 SizedBox(height: screenHeight * 0.03),
//                 Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Login or register to continue',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: fontSize * 0.4,
//                   ),
//                 ),
//
//                 // Input fields
//                 SizedBox(height: screenHeight * 0.04),
//                 CustomTextField(hintText: 'Registered Mobile No', prefixIcon: Icon(Icons.phone)),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomTextField(hintText: 'Password', prefixIcon: Icon(Icons.lock)),
//
//                 // Buttons
//                 SizedBox(height: screenWidth * 0.09),
//
//                 // update kyc & Forget button
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(child: CustomElevatedButton(elevation: 0,text: 'UPDATE KYC', onPressed: (){
//                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScanCodeScreen()));
//                     })),
//                     Expanded(
//                       child: CustomTextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
//                           );
//                         },
//                         foregroundColor: Colors.grey,
//                         label: 'Forgot Password?',
//                       ),
//                     ),
//
//                   ],
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomElevatedButton(text: 'Log In', onPressed: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>RetailerDashboard()));
//                 }),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomElevatedButton(text: 'Log In with OTP', onPressed: (){
//                   showOtpDialog(context,otpControllers: _otpControllers);
//                 }),
//                 SizedBox(height: screenHeight * 0.02),
//                 CustomElevatedButton(text: 'New User Registration', onPressed: (){
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => UserRegistrationScreen()),
//                   );
//                 },forgroundColor: Colors.white,backgroundColor: Colors.black,),
//
//
//                 SizedBox(height: screenHeight * 0.02),
//
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Checkbox(
//                       checkColor: Colors.white,
//                       activeColor: Colors.black,
//                       value: isChecked,
//                       onChanged: (_) {
//                         setState(() {
//                           isChecked = !isChecked;
//                         });
//                       },
//                     ),
//                     Expanded(
//                       child: Text(
//                         'I have read & fully understood the terms and conditions of V-Guard Rishta Loyalty Program and abide to follow them.',
//                         style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.03),
//                       ),
//                     ),
//                   ],
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
