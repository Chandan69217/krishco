import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/api_service/kyc_details_api.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/choose_file.dart';

class ChannelPartnerKycScreen extends StatefulWidget {
  @override
  _ChannelPartnerKycScreenState createState() =>
      _ChannelPartnerKycScreenState();
}

class _ChannelPartnerKycScreenState extends State<ChannelPartnerKycScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<_ProofSectionWidgetState> _idProofKey =
      GlobalKey<_ProofSectionWidgetState>();
  final GlobalKey<_ProofSectionWidgetState> _addressProofKey =
      GlobalKey<_ProofSectionWidgetState>();
  late Future<Map<String, dynamic>?> _futureKYCDetails;
  bool _isInitialized = false;
  String memberId = 'N/A';
  String custName = 'unknown';
  String custNumber = 'N/A';
  List<ProofModel> _initSavedIDProofs = [];
  List<ProofModel> _initSavedAddressProofs = [];
  // Controllers for text fields
  final TextEditingController accHolderNameController = TextEditingController();
  final TextEditingController accountConfNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();

  // ID Proof
  String? selectedIdProofType;
  String? idProofFileName;

  // Address Proof
  String? selectedAddressProofType;
  String? addressProofFileName;
  // Bank Details
  final List<String> bankProofTypes = [
    'Cancelled Cheque',
    'Bank Passbook',
    'Bank Statement',
  ];
  String? selectedBankProofType;
  File? bankProofFile;
  String? bankUploadedDocumentImage;

  final List<String> idProofTypes = [
    'Pan Card',
    'Passport',
    'Driving License',
    'Voter Card',
    'Aadhaar Card',
  ];
  final List<String> addressProofTypes = [
    'Bank Passbook',
    'Aadhaar Card',
    'Gas Bill',
    'Electricity Bill',
  ];

  @override
  void initState() {
    super.initState();
    _futureKYCDetails = KYCDetailsAPI(context: context).getKYCDetails();
  }



  void _init(Map<String, dynamic> data) {
    ProofModel getOrCreate(List<ProofModel> list, String type) {
      return list.firstWhere(
            (p) => p.type == type,
        orElse: () {
          final p = ProofModel()..type = type;
          list.add(p);
          return p;
        },
      );
    }

    final Map<String, String> idProofTypes = {
      'pan': 'Pan Card',
      'aadhar': 'Aadhaar Card',
      'pass': 'Passport',
      'voter': 'Voter ID',
      'dl': 'Driving License',
    };

    final Map<String, String> addressProofTypes = {
      'aadhar': 'Aadhaar Card',
      'pass': 'Bank Passbook',
      'gas': 'Gas Bill',
      'electricity': 'Electricity Bill',
    };

    data.forEach((key, value) {
      if (value == null || value.toString().trim().isEmpty) return;

      // ID Proofs
      if (key.startsWith('id_')) {
        idProofTypes.forEach((shortKey, typeName) {
          if (key.contains(shortKey)) {
            final proof = getOrCreate(_initSavedIDProofs, typeName);
            if (key.endsWith(shortKey)) proof.idNumber = value;
            if (key.endsWith('${shortKey}_front')) proof.frontImageUrl = value;
            if (key.endsWith('${shortKey}_back')) proof.backImageUrl = value;
          }
        });

        // Address Proofs
      } else if (key.startsWith('add_')) {
        addressProofTypes.forEach((shortKey, typeName) {
          if (key.contains(shortKey)) {
            final proof = getOrCreate(_initSavedAddressProofs, typeName);
            if (key.endsWith(shortKey)) proof.idNumber = value;
            if (key.endsWith('${shortKey}_front')) proof.frontImageUrl = value;
            if (key.endsWith('${shortKey}_back')) proof.backImageUrl = value;
          }
        });

        // Member Info
      } else {
        memberId = data['m_id'] ?? '';
        custName = data['cust_name'] ?? '';
        custNumber = data['cont_no'] ?? '';
        bankNameController.text = data['bank_name'] ?? '';
        accHolderNameController.text = data['account_holder_name'] ?? '';
        accountNumberController.text = data['acct_no'] ?? '';
        accountConfNumberController.text = data['acct_no'] ?? '';
        ifscController.text = data['ifsc'] ?? '';

        // Bank proof
        bankUploadedDocumentImage = data['bank_cheque'] ?? data['bank_pass'] ?? data['bank_stat'];
        selectedBankProofType = data['bank_cheque'] != null
            ? 'Cancelled Cheque'
            : data['bank_pass'] != null
            ? 'Bank Passbook'
            : 'Bank Statement';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KYC Details')),
      body: SafeArea(
        child: FutureBuilder(
          future: _futureKYCDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox.square(
                  dimension: 25.0,
                  child: CircularProgressIndicator(color: CustColors.nile_blue),
                ),
              );
            }

            if (snapshot.hasData) {
              if (!_isInitialized) {
                _init(snapshot.data!);
                _isInitialized = true;
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // === Customer Details Group ===
                      _buildGroupSection(
                        title: 'Customer Details',
                        subTitle: 'Not editable',
                        child: _buildCustomerDetails(),
                      ),

                      // === ID Proof Group ===
                      // _buildGroupSection(title: 'ID Proof', child: _buildIDProof()),
                      _buildGroupSection(
                        title: 'ID Proof *',
                        child: ProofSectionWidget(
                          key: _idProofKey,
                          title: 'ID Proof',
                          allProofTypes: idProofTypes,
                          initialProofs: _initSavedIDProofs,
                        ),
                      ),

                      // === Address Proof Group ===
                      _buildGroupSection(
                        title: 'Address Proof *',
                        child: ProofSectionWidget(
                          key: _addressProofKey,
                          title: 'Address Proof',
                          allProofTypes: addressProofTypes,
                          initialProofs: _initSavedAddressProofs,
                        ),
                      ),

                      // === Bank Details Group ===
                      _buildGroupSection(
                        title: 'Bank Details *',
                        child: _buildBankDetails(),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          child: Text(snapshot.data != null ?'Update KYC' :'Submit KYC'),
                          onPressed:_onSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('Something went wrong !!'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildGroupSection({
    required String title,
    String? subTitle,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: [TextSpan(text: title)],
            ),
          ),
          if (subTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.red.shade600,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildCustomerDetails() {
    return GridView.count(
      crossAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        _buildReadOnlyField(
          label: 'Customer Id',
          icon: Icons.badge,
          value: memberId,
        ),

        _buildReadOnlyField(
          label: 'Customer Name',
          icon: Icons.person,
          value: custName,
        ),

        _buildReadOnlyField(
          label: 'Contact Number',
          icon: Icons.phone,
          value: custNumber,
        ),
      ],
    );
  }

  Widget _buildBankDetails() {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 8.0,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          children: [
            _buildTextFormField(
              controller: bankNameController,
              label: 'Bank Name *',
              iconData: Icons.account_balance,
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Enter Bank Name' : null,
            ),
            _buildTextFormField(
              controller: accHolderNameController,
              label: 'Acc. Holder Name *',
              iconData: Icons.person,
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Enter Acc. Holder Name'
                          : null,
            ),
            _buildTextFormField(
              controller: accountNumberController,
              label: 'Account No *',
              textInputType: TextInputType.number,
              iconData: Icons.numbers,
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Enter Account Number'
                          : null,
            ),
            _buildTextFormField(
              controller: accountConfNumberController,
              label: 'Confirm Acc. No *',
              textInputType: TextInputType.number,
              iconData: Icons.numbers,
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Enter Confirm Acc. No'
                          : null,
            ),
            _buildTextFormField(
              controller: ifscController,
              label: 'IFSC Code *',
              iconData: Icons.code,
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Enter IFSC Code' : null,
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        BankProofUploadSection(
          proofTypes: bankProofTypes,
          imageUrl: bankUploadedDocumentImage,
          selectedType: selectedBankProofType,
          onProofTypeChanged:
              (value) => setState(() => selectedBankProofType = value),
          onFilePicked: (file) => setState(() => bankProofFile = file),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.grey, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData iconData,
    TextInputType? textInputType,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontSize: 14,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),

        // Tightly controlled prefix icon
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 4), // Adjust as needed
          child: Icon(iconData, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

        // Remove extra vertical/horizontal padding
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      validator:
          validator ??
          (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'Enter $label';
            }
            return null;
          },
    );
  }



  void _onSubmit()async {

    if (_formKey.currentState!.validate()) {
      // if (idProofFileName == null ||
      //     addressProofFileName == null ||
      //     bankProofFile == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red,
      //       behavior: SnackBarBehavior.floating,
      //       content: Text(
      //         'Please upload required documents',
      //       ),
      //     ),
      //   );
      //   return;
      // }

      final response = await KYCDetailsAPI(context: context).updateOrCreateKYC(
          idProofs: _idProofKey.currentState?.savedProofs??[],
          addressProofs: _addressProofKey.currentState?.savedProofs??[],
          bankDetails: {
            'bank_name' : bankNameController.text,
            'account_holder_name' : accHolderNameController.text,
            'acct_no': accountConfNumberController.text,
            'ifsc': ifscController.text,
            'bank_cheque': selectedBankProofType == 'Cancelled Cheque' ? bankProofFile:null,
            'bank_pass': selectedBankProofType == 'Bank Passbook' ? bankProofFile:null,
            'bank_stat' : selectedBankProofType == 'Bank Statement' ? bankProofFile:null
          });

      if(response != null){
        final status = response['isScuss'];
        var message = '';
        if(status){
          message = response['messages'];
        }else{
          final error = response['error'] as Map<String,dynamic>;
          message = error.values.toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.all(18.0),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text(
              message,
            ),
          ),
        );
      }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Failed KYC not updated',
            ),
          ),
        );
      }
    }
  }

class ProofSectionWidget extends StatefulWidget {
  final String title;
  final List<String> allProofTypes;
  final List<ProofModel>? initialProofs;

  ProofSectionWidget({
    super.key,
    required this.title,
    required this.allProofTypes,
    this.initialProofs,
  });

  @override
  State<ProofSectionWidget> createState() => _ProofSectionWidgetState();
}

class _ProofSectionWidgetState extends State<ProofSectionWidget> {
  List<ProofModel> savedProofs = [];
  ProofModel currentProof = ProofModel();
  int? editingIndex;
  final TextEditingController idController = TextEditingController();

  final TextEditingController frontFileController = TextEditingController(
    text: 'Choose file',
  );
  final TextEditingController backFileController = TextEditingController(
    text: 'Choose file',
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialProofs != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          savedProofs = widget.initialProofs ?? [];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> availableDropdownItems =
        widget.allProofTypes
            .where(
              (type) =>
                  savedProofs.every((proof) => proof.type != type) ||
                  (editingIndex != null &&
                      savedProofs[editingIndex!].type == type),
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProofForm(currentProof, availableDropdownItems),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _handleAddOrUpdate,
            icon: Icon(editingIndex == null ? Icons.add : Icons.update),
            label: Text(editingIndex == null ? 'Add' : 'Update'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        if (savedProofs.isNotEmpty) ...[
          Divider(),
          Text("Added Proofs", style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 10),
          ...savedProofs.asMap().entries.map((entry) {
            int index = entry.key;
            ProofModel proof = entry.value;
            return Card(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.badge)),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                title: Text('${proof.type}'),
                subtitle: Text(
                  'ID: ${proof.idNumber}\nBack Image: ${proof.backImage != null ? "Yes" : "No"}',
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 0,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        setState(() {
                          editingIndex = index;
                          currentProof = ProofModel.clone(proof);
                          frontFileController.text =
                              proof.frontImage?.path.split('/').last ??
                              'Choose file';
                          backFileController.text =
                              proof.backImage?.path.split('/').last ??
                              'Choose file';
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          savedProofs.removeAt(index);
                          if (editingIndex == index) {
                            editingIndex = null;
                            currentProof = ProofModel();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  void _handleAddOrUpdate() {
    if (currentProof.type == null ||
        currentProof.idNumber.isEmpty ||
       ( currentProof.frontImage == null && currentProof.frontImageUrl == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all required fields"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(20.0),
        ),
      );
      return;
    }

    bool alreadyExists = savedProofs.any(
      (proof) =>
          proof.type == currentProof.type &&
          (editingIndex == null ||
              savedProofs[editingIndex!].type != currentProof.type),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${currentProof.type} already added"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(20.0),
        ),
      );
      return;
    }

    setState(() {
      if (editingIndex != null) {
        savedProofs[editingIndex!] = currentProof;
        editingIndex = null;
      } else {
        savedProofs.add(currentProof);
      }

      currentProof = ProofModel();
      frontFileController.text = 'Choose file';
      backFileController.text = 'Choose file';
      idController.text = '';
    });
  }

  Widget _buildProofForm(ProofModel proof, List<String> availableTypes) {
    final bool isNumericProof =
        proof.type != null &&
        (proof.type!.toLowerCase().contains("aadhaar card"));
    // || proof.type!.toLowerCase().contains("") ||
    // proof.type!.toLowerCase().contains("number") ||
    // proof.type!.toLowerCase().contains("no"));

    final int minLength = 4;
    final int maxLength = 20;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      idController.text = proof.idNumber;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: '${widget.title} Type *',
            border: OutlineInputBorder(),
          ),
          items:
              availableTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          value: proof.type,
          onChanged: (val) => setState(() => proof.type = val),
          validator: (t) {
            if ((t == null || t.trim().isEmpty) && savedProofs.isEmpty) {
              return 'Select ${widget.title}';
            }
            return null;
          },
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: idController,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText:
                proof.type == null
                    ? '${widget.title} No *'
                    : '${proof.type} No *',
            border: OutlineInputBorder(),
          ),
          keyboardType:
              isNumericProof ? TextInputType.number : TextInputType.text,
          onChanged: (val) => proof.idNumber = val,
          validator: (val) {
            if (savedProofs.isNotEmpty) {
              return null;
            }
            if (val == null || val.trim().isEmpty) {
              return proof.type == null
                  ? 'Enter ${widget.title} No'
                  : 'Enter ${proof.type} No';
            }
            if (val.length < minLength) {
              return 'Minimum $minLength characters required';
            }
            if (val.length > maxLength) {
              return 'Maximum $maxLength characters allowed';
            }
            return null;
          },
        ),
        const SizedBox(height: 18),
        Text(
          ' Upload document *',
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildImageSelector(
                label: 'Front Image *',
                selectedFile: proof.frontImage,
                selectedImageUrl: proof.frontImageUrl,
                controller: frontFileController,
                onFileSelected: (file) {
                  setState(() {
                    currentProof.frontImage = file;
                    frontFileController.text = file.path.split('/').last;
                  });
                },
                onDelete: () {
                  setState(() {
                    currentProof.frontImage = null;
                    frontFileController.text = '';
                  });
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildImageSelector(
                label: 'Back Image (optional)',
                selectedFile: proof.backImage,
                selectedImageUrl: proof.backImageUrl,
                controller: backFileController,
                onFileSelected: (file) {
                  setState(() {
                    currentProof.backImage = file;
                    backFileController.text = file.path.split('/').last;
                  });
                },
                onDelete: () {
                  setState(() {
                    currentProof.backImage = null;
                    backFileController.text = '';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

    Widget _buildImageSelector(
    {
      required String label,
      File? selectedFile,
      String? selectedImageUrl,
      required TextEditingController controller,
      required Function(File) onFileSelected,
      VoidCallback? onDelete,
  }
    ) {
      return GestureDetector(
        onTap: () {
          ChooseFile.showImagePickerBottomSheet(context, (file) {
            onFileSelected(file);
          });
        },
        child: Container(
          padding: EdgeInsets.all(8),
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              selectedFile == null && selectedImageUrl == null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera, color: Colors.grey),
                      SizedBox(height: 6),
                      Text(
                        label,
                        style: TextStyle(color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: selectedFile != null ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                selectedFile,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  onDelete?.call();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ):
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(imageUrl: selectedImageUrl!)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        controller.text,
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
        ),
      );
    }

}

class BankProofUploadSection extends StatefulWidget {
  final List<String> proofTypes;
  final ValueChanged<String?> onProofTypeChanged;
  final ValueChanged<File?> onFilePicked;
  final String? imageUrl;
  final String? selectedType;

  const BankProofUploadSection({
    super.key,
    required this.proofTypes,
    required this.onProofTypeChanged,
    required this.onFilePicked,
    this.imageUrl,
    this.selectedType
  });

  @override
  State<BankProofUploadSection> createState() => _BankProofUploadSectionState();
}

class _BankProofUploadSectionState extends State<BankProofUploadSection> {
  String? selectedType;
  String? fileName;
  File? selectedFile;
  final TextEditingController fileController = TextEditingController(
    text: 'Choose file',
  );

  @override
  void initState() {
    super.initState();
    selectedType = widget.selectedType;
  }
  void _pickFile() async {
    ChooseFile.showImagePickerBottomSheet(context, (file) {
      setState(() => fileName = file.path.split('/').last ?? '');
      selectedFile = file;
      widget.onFilePicked(file);
    });
  }

  Widget _buildImageSelector(
      {
        required String label,
        File? selectedFile,
        String? selectedImageUrl,
        required TextEditingController controller,
        required Function(File) onFileSelected,
        VoidCallback? onDelete,
      }
      ) {
    return GestureDetector(
      onTap: () {
        ChooseFile.showImagePickerBottomSheet(context, (file) {
          onFileSelected(file);
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(12),
        ),
        child:
        selectedFile == null && selectedImageUrl == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera, color: Colors.grey),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: selectedFile != null ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      selectedFile,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        onDelete?.call();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ):
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(imageUrl: selectedImageUrl!)),
            ),
            SizedBox(height: 4),
            Text(
              controller.text,
              style: TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: 'Select Bank Proof Type',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items:
              widget.proofTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
          value: selectedType,
          onChanged: (value) {
            setState(() => selectedType = value);
            widget.onProofTypeChanged(value);
          },
          validator: (value) => value == null ? 'Select a proof type' : null,
        ),
        const SizedBox(height: 12),
        _buildImageSelector(
          controller: fileController,
          label: 'upload \n${selectedType}',
          onFileSelected: (file){
            setState(() => fileName = file.path.split('/').last ?? '');
            selectedFile = file;
            widget.onFilePicked(file);
          },
          onDelete: (){},
          selectedFile: selectedFile,
          selectedImageUrl: widget.imageUrl
        )
        // ElevatedButton.icon(
        //   onPressed: _pickFile,
        //   icon: Icon(Icons.upload_file),
        //   label: Text(fileName == null ? 'Upload File' : 'Change File'),
        // ),
        // if (fileName != null)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8),
        //     child: Text(
        //       'Uploaded: $fileName',
        //       style: TextStyle(color: Colors.green.shade700),
        //     ),
        //   ),
      ],
    );
  }
}

class ProofModel {
  String? type;
  String idNumber = '';
  File? frontImage;
  String? frontImageUrl;
  File? backImage;
  String? backImageUrl;

  ProofModel();

  ProofModel.clone(ProofModel original)
    : type = original.type,
      idNumber = original.idNumber,
      frontImage = original.frontImage,
  frontImageUrl = original.frontImageUrl,
      backImage = original.backImage,
  backImageUrl = original.backImageUrl;
}
