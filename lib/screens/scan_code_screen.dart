import 'dart:convert';
import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/full_screen_loading.dart';
import 'package:krishco/utilities/permission_handler.dart';
import 'package:krishco/widgets/cust_dialog_box/cust_dialog_box.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:krishco/widgets/custom_button.dart';
import 'package:krishco/widgets/custom_textfield.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utilities/cust_colors.dart';

class ScanCodeScreen extends StatefulWidget {
  final String? title;
  const ScanCodeScreen({super.key,this.title});

  @override
  State<ScanCodeScreen> createState() => _ScanCodeScreenState();
}

class _ScanCodeScreenState extends State<ScanCodeScreen> {

  bool showScanner = false;
  bool _isLoading = false;
  final TextEditingController _uniqueCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title??'Scan Code'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // QR Code
                  showScanner ? ScannerScreen()
                  :Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Image.asset(
                      'assets/logo/qr_logo.webp',
                      width: screenWidth * 0.55,
                      height: screenWidth * 0.55,
                    ),
                  ),

                  // Scan Button
                  SizedBox(
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: ()async {
                        if(await PermissionHandler.handleCameraPermission(context)){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScannerScreen()));
                        }
                        // if(!showScanner){
                        //   setState(() {
                        //     showScanner = !showScanner;
                        //   });
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.01)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Click here to scan a unique code',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              height: 1,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 20),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                              child: Icon(Icons.camera_alt,color: Colors.black,)),
                        ],
                      ),
                    ),
                  ),

                  // "or" text
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Text(
                      'or',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black),
                    ),
                  ),

                  // Input Field for Code

                  CustomFormTextField(hintText: 'Enter Serial Number', prefixIcon: Icon(Icons.qr_code_scanner),radius: screenWidth * 0.01,
                   textCapitalization: TextCapitalization.characters,
                    textInputFormatter: [CustomSerialNumberFormatter()],
                    controller: _uniqueCodeController,
                    validator: (value){
                    if(value == null || value.isEmpty ){
                      return 'Please Enter Serial Number || Scan QR Code';
                    }
                    return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.08,),
                  // Proceed Button
                  _isLoading ? SizedBox.square(
                    dimension: 25,
                    child: CircularProgressIndicator(
                        color:CustColors.nile_blue
                    ),
                  ):CustomElevatedButton(text: 'Proceed', onPressed: _onProceed),

                  SizedBox(height: screenHeight * 0.02,),
                  // History Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> WarrantyRegistrationListScreen()));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        splashFactory: NoSplash.splashFactory,
                        backgroundColor: Colors.transparent,
                        overlayColor: Colors.transparent
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Go to warranty registration history'),
                          SizedBox(width: 10),
                          CircleAvatar(child: Icon(Icons.arrow_forward_rounded,color: Colors.black,),backgroundColor: CustColors.yellow,),
                        ],
                      ),
                    ),
                  ),


                  // // Help Section
                  // Padding(
                  //   padding: EdgeInsets.only(top: screenHeight * 0.07),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text('Need help?',style: TextStyle(
                  //         fontSize: screenWidth * 0.06,
                  //         fontWeight: FontWeight.w400
                  //       ),),
                  //       SizedBox(height: 8.0,),
                  //       _buildContactItem(icon: Icons.phone, label: '9717500011'),
                  //       _buildContactItem(icon: Icons.email, label: 'info@vguardrishta.com'),
                  //       _buildContactItem(icon: FontAwesomeIcons.whatsapp, label: '9818900011'),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildContactItem({required IconData icon,required String label}){
    return Row(
      children: [
        Icon(icon, color: CustColors.yellow),
        SizedBox(width: 10),
        Text(label),
      ],
    );
  }


  

  void _onProceed() async{
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final response = await APIService.getInstance(context).warrantyRelated.warrantyRegistration(
        warrantyType: 'serial_no',
        warrantyNumber: _uniqueCodeController.text
    );
    String message = 'Something went wrong';
    if(response != null){
      final status = response['isScuss'];
      if(status){
        message =  response['messages'];
      }else{
        final error = response['error'] as Map<String,dynamic>;
        message = error.entries.first.value;
      }
      CustDialog.show(context: context, message: message);
    }
    setState(() {
      _isLoading = false;
    });
  }
}






class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<ScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  bool _isLoading = false;
  bool _isScanHandled = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  double zoom = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define font size based on screen size
    double titleFontSize = screenWidth * 0.05;
    double subTitleFontSize = screenWidth * 0.04;

    return Stack(
      children: [
        Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await controller!.toggleFlash();
              setState(() {});
            },
            icon: FutureBuilder(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!
                      ? Icon(Icons.flash_on)
                      : Icon(Icons.flash_off);
                } else {
                  return SizedBox.square(
                    dimension: 25.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),
          // actions: <Widget>[
          //   IconButton(
          //     onPressed: () async {
          //       await controller!.flipCamera();
          //       setState(() {});
          //     },
          //     icon: Icon(Icons.flip_camera_ios),
          //   )
          // ],
          title: Text(
            'Scan',
            style: TextStyle(fontSize: titleFontSize),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.01),

                SizedBox(
                  width: screenWidth * 0.6,
                  child: RichText(
                    text: TextSpan(
                      text: 'Align the QR Code with in the frame to scan',
                      style: TextStyle(fontSize: subTitleFontSize,color: Colors.black),
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                Expanded(child: _buildQrView(context)),
                SizedBox(height: screenHeight * 0.03),

                CustomElevatedButton(text: 'Cancel', onPressed: (){
                  Navigator.of(context).pop();
                },
                  elevation: 2,
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
                    ),
        ),
      ),
        if(_isLoading)...[
          FullScreenLoading()
        ]
      ]
    );
  }

  Widget _buildQrView(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scanArea = (screenWidth < 400 || MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: 20,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (_isScanHandled) return;
      _isScanHandled = true;

      setState(() => _isLoading = true);
      await controller.pauseCamera();

      result = scanData;
      Map<String, dynamic> data = {
        'data': result!.code,
        'time': DateFormat('dd-MMM-yyyy  HH:mm').format(DateTime.now())
      };

      final response = await APIService.getInstance(context).warrantyRelated.warrantyRegistration(
        warrantyType: 'qrcode',
        warrantyNumber: data.entries.first.value,
      );

      String message = 'Something went wrong';
      if (response != null) {
        final status = response['isScuss'];
        if (status) {
          message = response['messages'];
        } else {
          final error = response['error'] as Map<String, dynamic>;
          message = error.entries.first.value;
        }

        CustDialog.show(
          context: context,
          message: message,
          onConfirm: () async {
            _isScanHandled = false;
            await controller.resumeCamera();
          },
        );
      } else {
        _isScanHandled = false;
        await controller.resumeCamera();
      }

      setState(() => _isLoading = false);
    });
  }


  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void showDialogBox(BuildContext context, Barcode result) async {
    await controller?.pauseCamera();

    showGeneralDialog(
      context: context,
      pageBuilder: (buildContext, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Row(
              children: [
                SizedBox(width: 5.0),
                Text(result.format.name),
              ],
            ),
            content: Text(result.code.toString()),
            actions: [
              TextButton(
                onPressed: () async {
                  await controller?.resumeCamera();
                  Navigator.pop(buildContext);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

}


class CustomSerialNumberFormatter extends TextInputFormatter {
  // static final _regExp = RegExp(r'^[A-Z]{0,2}[0-9]{0,6}-?[0-9]{0,2}$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String value = newValue.text.toUpperCase();

    value = value.replaceAll(RegExp(r'[^A-Z0-9]'), '');


    if (value.length > 8) {
      value = value.substring(0, 8) + '-' + value.substring(8);
    }


    // if (value.length > 11) {
    //   value = value.substring(0, 11);
    // }

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}





class WarrantyRegistrationListScreen extends StatefulWidget {

  const WarrantyRegistrationListScreen({super.key});

  @override
  State<WarrantyRegistrationListScreen> createState() => _WarrantyRegistrationListScreenState();
}

class _WarrantyRegistrationListScreenState extends State<WarrantyRegistrationListScreen> {
  ValueNotifier<List<dynamic>> filteredData = ValueNotifier<List<dynamic>>([]);
  List<dynamic> data = [];
  String searchQuery = '';
  late Future<Map<String,dynamic>?> futureWarrantyList;
  @override
  void initState() {
    super.initState();
    futureWarrantyList = APIService.getInstance(context).warrantyRelated.getWarrantyRegistrationList();
  }

  void _search(String query) {
    searchQuery = query.toLowerCase();
    filteredData.value = data.where((item) {
      final customerName = item['customer']['name']?.toLowerCase() ?? '';
      final productName = item['qrcode']['product']['name']?.toLowerCase() ?? '';
      final qrCode = item['qrcode']['qrCodeId']?.toLowerCase() ?? '';
      return customerName.contains(searchQuery) ||
          productName.contains(searchQuery) ||
          qrCode.contains(searchQuery);
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warranty Registrations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Search by customer, product or QR ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: CustomRefreshIndicator(
                  onRefresh: ()async {
                    final data = await APIService.getInstance(context).warrantyRelated.getWarrantyRegistrationList();
                    if(data != null){
                      final status =  data['isScuss'];
                      if(status){
                        filteredData.value = data['data'];
                      }
                    }
                  },
                  builder: (BuildContext context, Widget child, IndicatorController controller) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        if (controller.isLoading)
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: CircularProgressIndicator(color: Colors.blue.shade600,),
                          ),
                        Transform.translate(
                          offset: Offset(0, 100 * controller.value),
                          child: child,
                        ),
                      ],
                    );
                  },
                  child: FutureBuilder(future: futureWarrantyList, builder:(context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: SizedBox.square(
                          dimension: 25.0,
                          child: CircularProgressIndicator(
                            color: CustColors.nile_blue,
                          ),
                        ),
                      );
                    }

                    if(snapshot.hasData){
                      data = snapshot.data!['data'];
                      if(data.isEmpty){
                        return Center(
                          child: Text('Empty'),
                        );
                      }

                      WidgetsBinding.instance.addPostFrameCallback((duration){
                        filteredData.value = data;
                      });

                      return ValueListenableBuilder(valueListenable: filteredData, builder: (context,value,child){
                        if(value.isEmpty){
                          return Center(
                              child: const Center(child: Text('No matching records found.'))
                          );
                        }
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return WarrantyCard(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WarrantyDetailsScreen(warrantyId: value[index]['id'].toString(),)));
                              },
                              item: value[index],
                            );
                          },
                        );
                      });

                    }else{
                     return Center(
                        child: Text('Something went wrong !'),
                      );
                    }
                  })
                ),
          ),
        ],
      ),
    );
  }
}





class WarrantyCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onTap;

  const WarrantyCard({super.key, required this.item,this.onTap});

  String _formatDate(String date) {
    return date.split(" ").first;
  }

  @override
  Widget build(BuildContext context) {
    final customer = item['customer'] ?? {};
    final product = item['qrcode']?['product'] ?? {};
    final qrcode = item['qrcode'] ?? {};

    final String status = (item['status'] ?? '').toString().toUpperCase();
    final bool isActive = status == 'ACTIVE';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
        // padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 4),
              blurRadius: 12,
            )
          ]
        ),
        child: Stack(
          children: [
            // Custom Warranty Watermark
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.09,
                  child: Transform.rotate(
                    angle: 0,
                    child: Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: 180.0,
                    ),
                    // child: Text(
                    //   "KRISHCO",
                    //   style: TextStyle(
                    //     fontSize: 60,
                    //     fontWeight: FontWeight.bold,
                    //     letterSpacing: 12,
                    //     color: Colors.green[800],
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
            // Card with info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  CustomNetworkImage(
                    imageUrl:  product['photo'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(width: 12),

                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product name
                                Text(
                                    product['name'] ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    )
                                ),
                                const SizedBox(height: 4),
                                // QR code and serial
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 4,
                                  children: [
                                    // Text("QR: ${qrcode['qrCodeId']}"),
                                    Text("Serial: ${qrcode['serial_no']}"),
                                  ],
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                            QrImageView(
                              data: qrcode['qrCodeId'] ?? '',
                              version: QrVersions.auto,
                              size: 100,
                              gapless: false,
                            ),
                          ],
                        ),

                        // Customer and warranty
                        Text("Customer: ${customer['name']}"),
                        Row(
                          children: [
                            Text("Warranty: ${item['warranty_period']} months"),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green[100] : Colors.red[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? Colors.green[800] : Colors.red[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Dates
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text("From: ${_formatDate(item['warranty_date'])}"),
                            const SizedBox(width: 12),
                            Text("To: ${_formatDate(item['expire_date'])}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class WarrantyDetailsScreen extends StatelessWidget {
  final String warrantyId;
  const WarrantyDetailsScreen({Key? key,required this.warrantyId}) : super(key: key);

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  Future<Map<String,dynamic>?> _getWarrantyDetails(BuildContext context)async{
    final userToken = Pref.instance.getString(Consts.user_token);
    final url = Uri.https(Urls.base_url,'/api/warranty/${warrantyId}/view/');
    final response = await get(url,headers: {
      'Authorization': 'Bearer ${userToken}'
    });

    print('response code: ${response.statusCode} Body: ${response.body}');
    if(response.statusCode == 200){
      final data = json.decode(response.body) as Map<String,dynamic>;
      return data;
    }else{
      WidgetsBinding.instance.addPostFrameCallback((duration){
        handleHttpResponse(context, response);
      });
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warranty Details'),
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String,dynamic>?>(
          future: _getWarrantyDetails(context),
          builder:(context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: SizedBox.square(
                  dimension: 25.0,
                  child: CircularProgressIndicator(
                    color: CustColors.nile_blue,
                  ),
                ),
              );
            }
            if(snapshot.hasData){
              final status = snapshot.data!['isScuss'];
              if(status){
                final data = snapshot.data!['data'];
                final customer = data['customer'] ?? {};
                final qrcode = data['qrcode'] ?? {};
                final product = qrcode['product'] ?? {};
                final addedBy = data['add_by'] ?? {};
                return  ListView(
                  children: [
                    CustomNetworkImage(
                      width: double.infinity,
                      height: 260,
                      imageUrl: product['photo'],
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader("Product Information"),
                          const SizedBox(height:8.0,),
                          Text(
                            product['name'] ?? 'Product Name',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                          // const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _dataRow("Category", product['catgeory']),
                                    _dataRow("Price", "₹${product['price']}"),
                                    _dataRow("Unit", product['unit']),
                                    _dataRow("QR Code ID", qrcode['qrCodeId']),
                                    _dataRow("Serial No", qrcode['serial_no']),
                                    _dataRow("QR Status", qrcode['status']),
                                  ],
                                ),
                              ),
                              // CustomNetworkImage(
                              //   width: 100,
                              //   height: 100,
                              //   imageUrl: product['photo'],
                              //   fit: BoxFit.cover,
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              // const SizedBox(width: 16),
                              QrImageView(
                                data: qrcode['qrCodeId'] ?? '',
                                version: QrVersions.auto,
                                size: 150,
                                gapless: false,
                              ),
                              SizedBox(width:20 ,)
                            ],
                          ),

                          const Divider(height: 32),
                          _sectionHeader("Customer Details"),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _dataRow("Name", customer['name']),
                                    _dataRow("Group", customer['group_name']),
                                    _dataRow("Group Type", customer['group_type']),
                                    _dataRow("Phone", customer['number']),
                                    _dataRow("Email", customer['email']),
                                  ],
                                ),
                              ),
                              CustomNetworkImage(
                                height: 80.0,
                                width: 80.0,
                                imageUrl: customer['photo'],
                                placeHolder: 'assets/logo/dummy_profile.webp',
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),

                          const Divider(height: 32),
                          _sectionHeader("Warranty Information"),
                          const SizedBox(height: 8),
                          _iconTextRow(Icons.calendar_today, "Warranty Date: ${_formatDate(data['warranty_date'])}"),
                          _iconTextRow(Icons.event_available, "Expiry Date: ${_formatDate(data['expire_date'])}"),
                          _iconTextRow(Icons.timelapse, "Period: ${data['warranty_period']} months"),
                          _iconTextRow(Icons.info_outline, "Status: ${data['status'].toString().toUpperCase()}"),

                          const Divider(height: 32),
                          _sectionHeader("Added By"),
                          const SizedBox(height: 8),
                          _dataRow("Name", addedBy['name']),
                          _dataRow("Email", addedBy['email']),
                          _dataRow("Number", addedBy['number']),
                          _dataRow("Group", addedBy['group_name']),
                        ],
                      ),
                    )
                  ],
                );
              }else{
                return Center(
                  child: Text('Something went wrong !'),
                );
              }
            }else{
              return Center(
                child: Text('Something went wrong !'),
              );
            }
          }
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
    );
  }

  Widget _dataRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        "$label: ${value ?? 'N/A'}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _iconTextRow(IconData icon, String? text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text ?? 'N/A',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}












