import 'dart:io';
import 'package:flutter/material.dart';
import 'package:krishco/widgets/choose_file.dart';

class ChannelPartnerKycScreen extends StatefulWidget {
  @override
  _ChannelPartnerKycScreenState createState() =>
      _ChannelPartnerKycScreenState();
}

class _ChannelPartnerKycScreenState extends State<ChannelPartnerKycScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<_ProofSectionWidgetState> _idProofKey = GlobalKey<_ProofSectionWidgetState>();
  final GlobalKey<_ProofSectionWidgetState> _addressProofKey = GlobalKey<_ProofSectionWidgetState>();

  // Controllers for text fields
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController accHolderNameController = TextEditingController();
  final TextEditingController accountConfNumberController =
      TextEditingController();

  // ID Proof
  String? selectedIdProofType;
  String? idProofFileName;

  // Address Proof
  String? selectedAddressProofType;
  String? addressProofFileName;

  // Bank Details
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final List<String> bankProofTypes = ['Cancelled Cheque', 'Bank Passbook', 'Bank Statement'];
  String? selectedBankProofType;
  File? bankProofFile;


  // Dummy lists for dropdowns
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
    'Gas Number',
    'Electricity Bill',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KYC Details')),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  ),
                ),
        
                // === Address Proof Group ===
                _buildGroupSection(
                  title: 'Address Proof *',
                  child: ProofSectionWidget(
                    key: _addressProofKey,
                    title: 'Address Proof',
                    allProofTypes: addressProofTypes,
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
                    child: Text('Submit KYC'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (idProofFileName == null ||
                            addressProofFileName == null ||
                            bankProofFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please upload required documents')),
                          );
                          return;
                        }

                        // Submit logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('KYC Submitted Successfully!')),
                        );
                      }
                    },
                  ),
                ),
                
              ],
            ),
          ),
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
          value: 'KRISHCO/EMP0104',
        ),

        _buildReadOnlyField(
          label: 'Customer Name',
          icon: Icons.person,
          value: 'Channel Partner',
        ),

        _buildReadOnlyField(
          label: 'Contact Number',
          icon: Icons.phone,
          value: '1234567891',
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
        const SizedBox(height: 12.0,),
        BankProofUploadSection(
          proofTypes: bankProofTypes,
          onProofTypeChanged: (value) => setState(() => selectedBankProofType = value),
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
          )
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),

        // Tightly controlled prefix icon
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 4), // Adjust as needed
          child: Icon(iconData, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),

        // Remove extra vertical/horizontal padding
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      validator: validator ??
              (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'Enter $label';
            }
            return null;
          },
    );
  }


}

class ProofSectionWidget extends StatefulWidget {
  final String title;
  final List<String> allProofTypes;


  const ProofSectionWidget({
    super.key,
    required this.title,
    required this.allProofTypes,
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
        currentProof.frontImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields"),backgroundColor: Colors.red,behavior: SnackBarBehavior.floating,padding: EdgeInsets.all(20.0),),
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
        SnackBar(content: Text("${currentProof.type} already added"),backgroundColor: Colors.red,behavior: SnackBarBehavior.floating,padding: EdgeInsets.all(20.0),),
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
    final bool isNumericProof = proof.type != null &&
        (proof.type!.toLowerCase().contains("aadhaar card"));
            // || proof.type!.toLowerCase().contains("") ||
            // proof.type!.toLowerCase().contains("number") ||
            // proof.type!.toLowerCase().contains("no"));

    final int minLength = 4;
    final int maxLength = 20;
    WidgetsBinding.instance.addPostFrameCallback((_){
      idController.text = proof.idNumber;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '${widget.title} Type *',
            border: OutlineInputBorder(),
          ),
          items: availableTypes
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          value: proof.type,
          onChanged: (val) => setState(() => proof.type = val),
          validator: (t){
            if((t == null || t.trim().isEmpty) && savedProofs.isEmpty){
              return 'Select ${widget.title}';
            }
            return null;
          },
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: idController,
          decoration: InputDecoration(
            labelText: proof.type == null
                ? '${widget.title} No *'
                : '${proof.type} No *',
            border: OutlineInputBorder(),
          ),
          keyboardType:
          isNumericProof ? TextInputType.number : TextInputType.text,
          onChanged: (val) => proof.idNumber = val,
          validator: (val) {
            if(savedProofs.isNotEmpty){
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
        Text(' Upload document *',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildImageSelector(
                label: 'Front Image *',
                selectedFile: proof.frontImage,
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
            selectedFile == null
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
                      child: Stack(
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
                      ),
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

  const BankProofUploadSection({
    super.key,
    required this.proofTypes,
    required this.onProofTypeChanged,
    required this.onFilePicked,
  });

  @override
  State<BankProofUploadSection> createState() => _BankProofUploadSectionState();
}

class _BankProofUploadSectionState extends State<BankProofUploadSection> {
  String? selectedType;
  String? fileName;

  void _pickFile() async {
    // Simulate file picking
    ChooseFile.showImagePickerBottomSheet(context, (file){
      setState(() => fileName = file.path.split('/').last??'');
      widget.onFilePicked(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Bank Proof Type',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: widget.proofTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          value: selectedType,
          onChanged: (value) {
            setState(() => selectedType = value);
            widget.onProofTypeChanged(value);
          },
          validator: (value) => value == null ? 'Select a proof type' : null,
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _pickFile,
          icon: Icon(Icons.upload_file),
          label: Text(fileName == null ? 'Upload File' : 'Change File'),
        ),
        if (fileName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Uploaded: $fileName',
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
      ],
    );
  }
}


class ProofModel {
  String? type;
  String idNumber = '';
  File? frontImage;
  File? backImage;

  ProofModel();

  ProofModel.clone(ProofModel original)
    : type = original.type,
      idNumber = original.idNumber,
      frontImage = original.frontImage,
      backImage = original.backImage;
}
