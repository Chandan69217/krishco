import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/choose_file.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mime/mime.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class SupportScreen extends StatefulWidget {
  final bool? showAppBar;
  SupportScreen({super.key,this.showAppBar = false});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  late Future<Map<String,dynamic>?> _futureSupportDetails;

  @override
  void initState() {
    super.initState();
    _futureSupportDetails = _getSupportDetails();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: widget.showAppBar! ? AppBar(
        title: const Text('About & Support'),
      ):null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
          child: FutureBuilder(
            future: _futureSupportDetails,
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child:SizedBox.square(
                    dimension: 25.0,
                    child: CircularProgressIndicator(
                      color: CustColors.nile_blue,
                    ),
                  ),
                );
              }
              if(snapshot.hasData && snapshot.data != null){
                final careNumber = snapshot.data!['customer_care_number'].toString();
                final careEmail = snapshot.data!['customer_care_email'].toString();
                final salesPerson = snapshot.data!['sales_person'] != null ? snapshot.data!['sales_person'] as List<dynamic> : [];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(Icons.support_agent, size: 40, color: CustColors.nile_blue),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Krishco Solutions',
                          style: TextStyle(fontSize: screenHeight * 0.03, fontWeight: FontWeight.bold, color: CustColors.nile_blue),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: screenWidth * 0.2,
                          height: 2,
                          margin: const EdgeInsets.only(top: 6, bottom: 20),
                          color: CustColors.nile_blue,
                        ),
                      ),

                      SectionTitle('About Us', screenWidth * 0.045),
                      SectionContent(
                        'Krishco Solutions Private Limited is a celebrated name in Rajkot, known for manufacturing and supplying superior quality products.',
                        screenWidth * 0.035,
                      ),
                      const SizedBox(height: 20),

                      SectionTitle('Our Factory', screenWidth * 0.045),
                      SectionContent(
                        'We operate a modern, state-of-the-art facility in Rajkot to ensure quality and efficiency.',
                        screenWidth * 0.035,
                      ),
                      const SizedBox(height: 20),

                      SectionTitle('Our Team', screenWidth * 0.045),
                      SectionContent(
                        'A team of dedicated and experienced professionals ensures smooth operations and high-quality output.',
                        screenWidth * 0.035,
                      ),
                      const SizedBox(height: 24),

                      // SectionTitle('Quick Info', screenWidth * 0.045),
                      // const SizedBox(height: 12),
                      // _infoBox(screenWidth),

                      // const SizedBox(height: 24),
                      if(salesPerson.isNotEmpty)...[
                        _SalesSupportSection(salesPersonList: salesPerson,),
                        const SizedBox(height: 12.0),
                      ],

                      SectionTitle('Need Help?', screenWidth * 0.045),
                      const SizedBox(height: 12),
                      _supportBox(screenWidth, context,careNumber,careEmail,),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _queryActionButton(context, 'Query'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '|',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.blueAccent.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _queryActionButton(context, 'Suggestion'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '|',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.blueAccent.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _queryActionButton(context, 'Complaint'),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }
              return Center(
                child: Text('Something went wrong !'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _queryActionButton(BuildContext context, String type) {
    return Row(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent.shade700,
            splashFactory: NoSplash.splashFactory,
            overlayColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          onPressed: () => _showQueryBottomSheet(type),
          child: Text(type,),
        ),
      ],
    );
  }

  void _showQueryBottomSheet(String selectedType) {
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;
    final TextEditingController _messageController = TextEditingController();
    File? _attachedImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              final screenWidth = MediaQuery.of(context).size.width;
              return Form(
                key: _formKey,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SectionTitle('Register $selectedType',  screenWidth * 0.045),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Your message',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter your $selectedType'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      if (_attachedImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_attachedImage!.path),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      TextButton.icon(
                        onPressed: (){
                          ChooseFile.showImagePickerBottomSheet(context,(selectedFile){
                           setState((){
                             _attachedImage = selectedFile;
                           });
                          });
                        },
                        icon: const Icon(Icons.attach_file),
                        label: Text(_attachedImage == null
                            ? 'Attach Image'
                            : 'Change Image'),
                      ),
                      const SizedBox(height: 12),
                      if(!_isLoading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState((){
                                _isLoading = true;
                              });
                              String? encodedImage;
                              String? mediaType;
                              if (_attachedImage != null) {
                                final bytes = await File(_attachedImage!.path).readAsBytes();
                                mediaType = lookupMimeType(_attachedImage!.path);
                                final base64Str = base64Encode(bytes);

                                encodedImage = 'data:$mediaType;base64,$base64Str';
                              }

                              final Map<String,dynamic> queryData = {
                                'query_type': selectedType.toLowerCase(),
                                'query': _messageController.text.trim(),
                                'photo': encodedImage,
                                'app_name': 'mobile'
                              } as Map<String,dynamic>;

                              final isSuccess = await _submitQuery(queryData);

                              if(isSuccess){
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$selectedType submitted successfully')),
                                );
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Somethings went wrong !')),
                                );
                              }
                              setState((){
                                _isLoading = false;
                              });
                            }
                          },
                          child: Text('Submit ${selectedType}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustColors.nile_blue
                          ),
                        ),
                      ),
                      if(_isLoading)
                        Center(
                          child: SizedBox.square(
                            dimension: 25.0,
                            child: CircularProgressIndicator(
                              color: CustColors.nile_blue,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _infoBox(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: CustColors.cyan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          infoRow('CEO', 'Mr. Mitul Patel', screenWidth),
          infoRow('Established', '2020', screenWidth),
          infoRow('Business', 'Manufacturer & Supplier', screenWidth),
          infoRow('GST No.', '24AALCP1709K1ZB', screenWidth),
        ],
      ),
    );
  }

  Widget _supportBox(double screenWidth, BuildContext context,String careNumber,String careEmail,) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: CustColors.cyan,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.phone, color: CustColors.nile_blue),
            title: Text('Call Customer Care'),
            subtitle: Text('+91 $careNumber'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: ()async {
              final Uri url = Uri(scheme: 'tel', path: careNumber);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email, color: CustColors.nile_blue),
            title: Text('Email Support'),
            subtitle: Text('$careEmail'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async{
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: careEmail,
              );

              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              } else {
                print('Could not launch email');
              }
            },
          ),

          // if (salesPersonList.isNotEmpty) ...[
          //   Divider(),
          //   Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text(
          //       'Sales Support',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: screenWidth * 0.04,
          //         color: CustColors.nile_blue,
          //       ),
          //     ),
          //   ),
          //   const SizedBox(height: 8),
          //   ...salesPersonList.map((person) {
          //     final name = person['name'] ?? '';
          //     final number = person['number'] ?? '';
          //     final email = person['email'] ?? '';
          //
          //     return Column(
          //       children: [
          //         ListTile(
          //           leading: Icon(Icons.person, color: CustColors.nile_blue),
          //           title: Text(name),
          //           subtitle: Text('+91 $number'),
          //           trailing: Icon(Icons.call, color: Colors.green),
          //           onTap: () async {
          //             final Uri url = Uri(scheme: 'tel', path: number);
          //             if (await canLaunchUrl(url)) {
          //               await launchUrl(url);
          //             } else {
          //               ScaffoldMessenger.of(context).showSnackBar(
          //                 SnackBar(content: Text('Could not launch call')),
          //               );
          //             }
          //           },
          //         ),
          //         if (email.toString().trim().isNotEmpty)
          //           ListTile(
          //             leading: Icon(Icons.email, color: CustColors.nile_blue),
          //             title: Text('Email $name'),
          //             subtitle: Text(email),
          //             trailing: Icon(Icons.send, color: Colors.blue),
          //             onTap: () async {
          //               final Uri emailLaunchUri = Uri(
          //                 scheme: 'mailto',
          //                 path: email,
          //               );
          //
          //               if (await canLaunchUrl(emailLaunchUri)) {
          //                 await launchUrl(emailLaunchUri);
          //               } else {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   SnackBar(content: Text('Could not launch email')),
          //                 );
          //               }
          //             },
          //           ),
          //         Divider(),
          //       ],
          //     );
          //   }).toList(),
          // ]

        ],
      ),
    );
  }

  Widget infoRow(String label, String value, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenWidth * 0.035)),
          ),
          Text(': '),
          Expanded(
            flex: 5,
            child: Text(value, style: TextStyle(fontSize: screenWidth * 0.033)),
          ),
        ],
      ),
    );
  }

  Widget SectionTitle(String title, double fontSize) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: CustColors.nile_blue,
      ),
    );
  }

  Widget SectionContent(String content, double fontSize) {
    return Text(
      content,
      style: TextStyle(fontSize: fontSize, height: 1.6, color: Colors.black87),
    );
  }

  Future<Map<String, dynamic>?> _getSupportDetails() async{
    final userToken = Pref.instance.getString(Consts.user_token);
    try{
      final url = Uri.https(Urls.base_url,Urls.support_details);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $userToken'
      });
      print('Response Code: ${response.statusCode} , Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isScuss'];
        if(status){
          return body;
        }
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception, Trace: $trace');
    }
    return null;
  }

  Future<bool> _submitQuery(Map<String,dynamic> data)async{
    final userToken = Pref.instance.getString(Consts.user_token);
    print('Received Data: $data');
    try{
      final url = Uri.https(Urls.base_url,Urls.query_center);
      final response = await post(url,headers: {
        'Authorization' : 'Bearer $userToken',
        'content-type':'Application/json'
      },body:  json.encode(data));

      print('Response Code: ${response.statusCode}, Body:${response.body} ');
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }else{
        handleHttpResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace:$trace');
    }
    return false;
  }


}






class _SalesSupportSection extends StatefulWidget {
  final List<dynamic> salesPersonList;

  const _SalesSupportSection({super.key, required this.salesPersonList});

  @override
  State<_SalesSupportSection> createState() => _SalesSupportSectionState();
}

class _SalesSupportSectionState extends State<_SalesSupportSection> {
  final PageController _pageController = PageController(viewportFraction: 0.90);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final salesPersonList = widget.salesPersonList;

    if (salesPersonList.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales Support',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: CustColors.nile_blue,
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            padEnds: !(salesPersonList.length > 1),
            itemCount: salesPersonList.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final person = salesPersonList[index];
              final name = person['name'] ?? '';
              final email = person['email'] ?? '';
              final phone = person['number'] ?? '';
              final photo = person['photo'];
              final address = [
                person['city'],
                person['district'],
                person['state'],
                person['country']
              ].where((e) => e != null && e.toString().isNotEmpty).join(', ');

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomNetworkImage(
                        imageUrl:photo,
                        placeHolder: 'assets/logo/dummy_profile.webp',
                        width: 60.0,
                        height: 60.0,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(address, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 4),
                            if (email.isNotEmpty)
                              Text(email, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final Uri url = Uri(scheme: 'tel', path: phone);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Could not launch call')),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.call, size: 18),
                                  label: const Text('Call'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    textStyle: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (email.isNotEmpty)
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final Uri emailUri = Uri(
                                        scheme: 'mailto',
                                        path: email,
                                        query: Uri.encodeFull('subject=Support&body=Hello'),
                                      );
                                      if (await canLaunchUrl(emailUri)) {
                                        await launchUrl(emailUri);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Could not launch email')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.email, size: 18),
                                    label: const Text('Email'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: CustColors.nile_blue,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      textStyle: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Page Indicator
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: salesPersonList.length,
            effect: WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: CustColors.nile_blue,
              dotColor: Colors.grey.shade300,
            ),
          ),
        ),
      ],
    );
  }
}