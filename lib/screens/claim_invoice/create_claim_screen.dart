import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/models/enterprised_related/enterprises_details_list_data.dart';
import 'package:krishco/utilities/full_screen_loading.dart';
import 'package:krishco/utilities/permission_handler.dart';
import 'package:krishco/widgets/choose_file.dart';
import 'package:krishco/widgets/cust_snack_bar.dart';

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
  bool _isLoading = false;
  ValueNotifier<EnterpriseDetailsListData?> taggedEnterprise = ValueNotifier<EnterpriseDetailsListData?>(null);
  DateTime? _invoiceDate = DateTime.now();
  String? _enterpriseDetails;
  bool _notInList = false;
  File? _selectedFile;


  void _getEnterprises()async{
    final taggedEnterpriseObj = APIService.getInstance(context).taggedEnterprise;
    final data = await taggedEnterpriseObj.getTaggedEnterpriseOfLoginCustomer();
    if(data !=null){
      taggedEnterprise.value = EnterpriseDetailsListData.fromJson(data);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getEnterprises();
    });
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
                  decoration: InputDecoration(
                    labelText: 'Invoice Number (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'INVOICE NUMBER',
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
          
                const SizedBox(height: 16),
                ValueListenableBuilder<EnterpriseDetailsListData?>(
                  valueListenable: taggedEnterprise,
                  builder: (context,value,child){
                    return DropdownButtonFormField<String>(
                      style:Theme.of(context).textTheme.bodySmall,
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
                      value: _enterpriseDetails,
                      items: [
                        DropdownMenuItem(child: Text("Select Enterprise Details"), value: null),
                        if(value != null)...[
                          ...value.data.map((datum) {
                            final customer = datum.customer;
                            if (customer == null) return null;
          
                            final displayText =
                                '${customer.name ?? 'Unknown'} - ${customer.groupName ?? 'N/A'}';
          
                            return DropdownMenuItem<String>(
                              value: customer.id?.toString(),
                              child: Text(displayText),
                            );
                          }).whereType<DropdownMenuItem<String>>().toList(),
                        ]
                      ],
                      onChanged: !_notInList ? (value) => setState(() => _enterpriseDetails = value):null,
                    );
                  },
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
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
                      labelText: 'Enterprise Name *',
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
                      counterText: '',
                      labelText: 'Enterprise Number *',
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
                      labelText: 'Enterprise Address (Optional)',
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
                    border: OutlineInputBorder(),
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
                  maxLines: 2,
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Uploaded File Preview',
                    border: const OutlineInputBorder(),
          
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
          
                const SizedBox(height: 34),
          
              ],
            ),
          ),
                  ),
        ),
        bottomNavigationBar: _buildBottomBar(),
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
      _enterpriseDetails = null;
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


      final response = await APIService.getInstance( context).invoiceClaim.createInvoiceClaim(
          invoiceNo: _invoiceNumberController.text,
          claimFrom: !_notInList ? _enterpriseDetails :null,
          invoiceData: _invoiceDate != null ? DateFormat('yyyy-MM-dd').format(_invoiceDate!) : '',
          amount: _claimAmountController.text,
          claimCopy: _selectedFile != null ? _selectedFile!.path!: '',
          claimFromOthers: _notInList ? {
            "name": _enterpriseNameController.text,
            "number":_enterpriseNumberController.text,
            "address":_enterpriseAddressController.text
          }:null
      );
      print("Claim Entery Response: ${response.toString()}");

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
        showSnackBar(context: context, title: 'Success', message:response['messages'].toString(),contentType: ContentType.success );
      }else{
        print('Message: ${response['messages']}');
        final errorMessage = response.values.last as Map<String,dynamic>;
        showSnackBar(context: context, title: 'Failed', message:errorMessage.values.toString(),contentType: ContentType.warning );
      }

      setState(() {
        _isLoading = false;
      });

    }

  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _onReset,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                backgroundColor: Colors.white,
              ),
              icon: const Icon(Icons.sync,color: Colors.red,),
              label: const Text('Reset'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
                backgroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check,color: Colors.green,),
              label: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }









}