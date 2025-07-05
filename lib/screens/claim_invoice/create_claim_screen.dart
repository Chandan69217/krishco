import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/dashboard_type/dashboard_types.dart';
import 'package:krishco/models/define_roles/define_roles.dart';
import 'package:krishco/models/enterprised_related/enterprises_details_list_data.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/utilities/full_screen_loading.dart';
import 'package:krishco/utilities/permission_handler.dart';
import 'package:krishco/widgets/choose_file.dart';
import 'package:krishco/widgets/cust_dialog_box/cust_dialog_box.dart';
import 'package:krishco/widgets/cust_snack_bar.dart';
import 'package:krishco/widgets/custom_button.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';

class CreateClaimScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  CreateClaimScreen({this.onSuccess});
  @override
  _CreateClaimScreenState createState() => _CreateClaimScreenState();
}

class _CreateClaimScreenState extends State<CreateClaimScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _invoiceNumberController = TextEditingController();
  final TextEditingController _claimAmountController = TextEditingController();
  final TextEditingController _filePreviewController = TextEditingController(text: 'No file uploaded yet.');
  final TextEditingController _enterpriseNameController = TextEditingController();
  final TextEditingController _enterpriseNumberController = TextEditingController();
  final TextEditingController _enterpriseAddressController = TextEditingController();
  final TextEditingController _consumerPhoneNumberController = TextEditingController();
  final FocusNode _consumerPhoneNumberFocusNode = FocusNode();
  bool _isLoading = false;
  ValueNotifier<EnterpriseDetailsListData?> taggedEnterprise = ValueNotifier<EnterpriseDetailsListData?>(null);
  DateTime? _invoiceDate = DateTime.now();
  String? _enterpriseID;
  String? _claimBy;
  bool _notInList = false;
  File? _selectedFile;



  void _getEnterprises()async{
    final taggedEnterpriseObj = APIService.getInstance(context).taggedEnterprise;
    final data = await taggedEnterpriseObj.getTaggedEnterpriseOfLoginCustomer();
    if(data !=null){
      taggedEnterprise.value = EnterpriseDetailsListData.fromJson(data);
    }
  }

  Future<void> _getEnterprisesByNumber(String number) async {
    try {
      final taggedEnterpriseObj = APIService.getInstance(context).taggedEnterprise;
      final data = await taggedEnterpriseObj.getTaggedEnterpriseByNumber(number);

      if (data != null) {
        final bool status = data['isScuss'] ?? false;

        if (status) {
          taggedEnterprise.value = EnterpriseDetailsListData.fromJson(data);
        } else {
          taggedEnterprise.value = null;
          // final String message = data['messages'] ?? 'Something went wrong!';
          // CustDialog.show(context: context, message: message);
        }
      } else {
        taggedEnterprise.value = null;
        // CustDialog.show(context: context, message: 'No data received from server.');
      }
    } catch (e, trace) {
      debugPrint('Error in _getEnterprisesByNumber: $e\n$trace');
      // CustDialog.show(context: context, message: 'Failed to fetch data. Please try again later.');
    }
  }

  Future<String?> _getConsumerDetailsByNumber(String number)async{
    String? claimBy;
    final data = await APIService.getInstance(context).groupDetails.getCustomerDetailsByNumber(int.tryParse(number,)??0);
    if(data != null){
      final status = data['isScuss'];
      if(status){
        claimBy = data['data']['id'].toString();
      }else{
        final message = data['messages'].toString();
        CustDialog.show(context: context, message: message);
      }
    }
    return claimBy;
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (GroupRoles.dashboardType == DashboardTypes.User &&
          GroupRoles.roles.contains(DefineRoles.user.Who_can_claim_points_by_uploading_invoice)) {

        _consumerPhoneNumberFocusNode.addListener(() async {
          if (!_consumerPhoneNumberFocusNode.hasFocus && mounted) {
            final number = _consumerPhoneNumberController.text.trim();
            if (number.isNotEmpty) {
              setState(() => _isLoading = true);
              _claimBy = await _getConsumerDetailsByNumber(number);
              if(_claimBy != null){
                await _getEnterprisesByNumber(number);
              }
              if (mounted) {
                setState(() => _isLoading = false);
              }
            }
          }
        });

      } else {
        _getEnterprises();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(GroupRoles.dashboardType == DashboardTypes.User && GroupRoles.roles.contains(DefineRoles.user.Who_can_claim_points_by_uploading_invoice)){
      _consumerPhoneNumberFocusNode.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        appBar: AppBar(
          title: const Text('Claim Invoice'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: ()=> _consumerPhoneNumberFocusNode.unfocus(),
            behavior: HitTestBehavior.translucent,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Claim Details *',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0B6EF6)),
                      ),
                      SizedBox(width: 18.0,),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(text: 'Note: '),
                              TextSpan(
                                text: 'All ',
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[700], fontWeight: FontWeight.normal),
                              ),
                              TextSpan(children: [
                                TextSpan(
                                  text: '(',
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[700], fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: '*',
                                ),
                                TextSpan(
                                  text: ') ',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700], fontWeight: FontWeight.normal),
                                )
                              ]),
                              TextSpan(
                                text: 'Fields are Mandatory.',
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[700], fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    style:Theme.of(context).textTheme.bodySmall,
                    controller: _invoiceNumberController,
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue,newValue){
                        return newValue.copyWith(
                          text: newValue.text.toUpperCase(),
                          selection: newValue.selection,
                        );
                      })
                    ],
                    decoration: InputDecoration(
                      labelText: 'Invoice Number (Optional)',
                      border: OutlineInputBorder(),
                      hintText: 'Enter invoice number',
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    style:Theme.of(context).textTheme.bodySmall,
                    controller: TextEditingController(
                      text: _invoiceDate != null ? DateFormat('yyyy-MM-dd').format(_invoiceDate!) : '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Invoice Date *',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode()); // prevent keyboard
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _invoiceDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _invoiceDate = pickedDate;
                        });
                      }
                    },
                    validator: (value) {
                      if (_invoiceDate == null) {
                        return 'Please select invoice date';
                      }
                      return null;
                    },
                  ),

                  if(GroupRoles.dashboardType == DashboardTypes.User && GroupRoles.roles.contains(DefineRoles.user.Who_can_claim_points_by_uploading_invoice))...[
                    const SizedBox(height: 16),
                    TextFormField(
                      style:Theme.of(context).textTheme.bodySmall,
                      controller: _consumerPhoneNumberController,
                      keyboardType: TextInputType.number,
                      focusNode: _consumerPhoneNumberFocusNode,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Mobile No *',
                        prefixIcon: Icon(Icons.call),
                        counterText: '',
                        border: OutlineInputBorder(),
                        hintText: 'Enter Consumer Number (*)',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Enter Consumer Number';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  ValueListenableBuilder<EnterpriseDetailsListData?>(
                    valueListenable: taggedEnterprise,
                    builder: (context,value,child){
                      return DropdownButtonFormField<String>(
                        style:Theme.of(context).textTheme.bodySmall,
                        isExpanded: true,
                        validator:  !_notInList ? (value){
                          if(value == null || value.isEmpty){
                            return 'Select Enterprise Details';
                          }
                          return null;
                        }:null,
                        decoration: InputDecoration(
                          labelText: 'Enterprise Details *',
                          border: OutlineInputBorder(),
                        ),
                        value: _enterpriseID,
                        items: [
                          DropdownMenuItem(child: Text("Select Enterprise Details"), value: null),
                          if(value != null)...[
                            ...value.data.map((datum) {
                              final customer = datum?.customer;
                              if (customer == null) return null;

                              final displayText =
                                  '${customer.name ?? 'Unknown'} - ${customer.groupName??''}';

                              return DropdownMenuItem<String>(
                                value: customer.id?.toString(),
                                child: Text(displayText),
                              );
                            }).whereType<DropdownMenuItem<String>>().toList(),
                          ]
                        ],
                        onChanged: !_notInList ? (value) {
                          setState(() {
                            _enterpriseID = value;
                          });
                        }
                        :null,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: CustColors.nile_blue,
                    title: Text('From where you purchased is not in the enterprise list.', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                    value: _notInList,
                    onChanged: (value) => setState(() => _notInList = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  if (_notInList) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      style:Theme.of(context).textTheme.bodySmall,
                      controller: _enterpriseNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        counterText: '',
                        labelText: 'Enterprise Name *',
                        hintText: 'Enter enterprise name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enterprise Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style:Theme.of(context).textTheme.bodySmall,
                      controller: _enterpriseNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        counterText: '',
                        labelText: 'Mobile No *',
                        hintText: 'Enter enterprise number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enterprise Number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style:Theme.of(context).textTheme.bodySmall,
                      controller: _enterpriseAddressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Address (Optional)',
                        hintText: 'Enter enterprises address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  TextFormField(
                    style:Theme.of(context).textTheme.bodySmall,
                    controller: _claimAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Claim Amount *',
                      prefixIcon: Icon(Icons.currency_rupee_rounded),
                      border: OutlineInputBorder(),
                      counterText: '',
                      hintText: 'Claim Amount (*)',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Enter Claim Amount';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    style:Theme.of(context).textTheme.bodySmall,
                    controller: _filePreviewController,
                    maxLines: 1,
                    readOnly: true,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      labelText: 'Uploaded File Preview',
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 20.0),
                      suffixIcon: _selectedFile == null
                          ? TextButton.icon(
                        icon: const Icon(Icons.attach_file),
                        label: const Text("Upload"),
                        style: TextButton.styleFrom(
                          textStyle:Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                        ),
                        // onPressed: _pickFile,
                        onPressed: (){
                          ChooseFile.showImagePickerBottomSheet(context,(file){
                            setState(() {
                              _selectedFile = file;
                              _filePreviewController.text = _selectedFile!.path.split('/').last;
                            });
                          });
                        },
                      )
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _selectedFile = null;
                            _filePreviewController.text = 'No file uploaded yet.';
                          });
                        },
                      ),
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please Upload Claim Copy';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildBottomBar(),
                ],
              ),
            ),
          ),
                  ),
        ),
        // bottomNavigationBar: _buildBottomBar(),
      ),
        if(_isLoading)...[
          FullScreenLoading()
        ]
      ]
    );
  }


  void _onReset()async{
    _formKey.currentState!.reset();
    _invoiceNumberController.clear();
    _claimAmountController.clear();
    _filePreviewController.text = 'No file uploaded yet.';
    _selectedFile = null;
    _enterpriseNameController.clear();
    _enterpriseNumberController.clear();
    _enterpriseAddressController.clear();
    setState(() {
      _enterpriseID = null;
      _notInList = false;
      _invoiceDate = DateTime.now();
      _selectedFile = null;
    });
  }

  void _onSubmit()async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload the Claim Copy.')),
        );
        return;
      }

      if (_notInList) {
        if (_enterpriseNameController.text.isEmpty || _enterpriseNumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in Enterprise Name and Number.')),
          );
          return;
        }
      }
      setState(() {
        _isLoading = true;
      });


      // if(GroupRoles.dashboardType == DashboardTypes.User && _claimBy == null){
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   return;
      // }

      final response = await APIService.getInstance( context).invoiceClaim.createInvoiceClaim(
          invoiceNo: _invoiceNumberController.text,
          claimFrom: !_notInList ? _enterpriseID :null,
          invoiceData: _invoiceDate != null ? DateFormat('yyyy-MM-dd').format(_invoiceDate!) : '',
          amount: _claimAmountController.text,
          claimCopy: _selectedFile != null ? _selectedFile!.path: '',
          claimedBy: GroupRoles.dashboardType == DashboardTypes.User ? _claimBy :null,
          claimFromOthers: _notInList ? {
            "name": _enterpriseNameController.text,
            "number":_enterpriseNumberController.text,
            "address":_enterpriseAddressController.text
          }:null
      );
      print("Claim Entry Response: ${response.toString()}");

      if(response == null){
        showSnackBar(context: context, title: 'Failed', message:'Something went Wrong !!',contentType: ContentType.warning );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if(response['isScuss']){
        _onReset();
        widget.onSuccess?.call();
        CustDialog.show(context: context, title: 'Success', message:response['messages'].toString() );
      }else{
        print('Message: ${response['messages']}');
        final errorMessage = response.values.last as Map<String,dynamic>;
        CustDialog.show(context: context, title: 'Failed', message:'${errorMessage.keys.toString().replaceAll(RegExp(r'[()]'), '')} - ${errorMessage.values.toString().replaceAll(RegExp(r'[()]'), '')}',);
      }

      setState(() {
        _isLoading = false;
      });

    }

  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomElevatedButton(text: 'Submit', onPressed: _onSubmit),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _onReset,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 8.0),
              elevation: 1,
              side: const BorderSide(color: Colors.red,),
              backgroundColor: Colors.white,
            ),
            icon: const Icon(Icons.sync,color: Colors.red,),
            label: const Text('Reset'),
          ),
        ],
      ),
    );
  }


}



