import 'package:flutter/material.dart';

class ChannelPartnerKycScreen extends StatefulWidget {
  @override
  _ChannelPartnerKycScreenState createState() => _ChannelPartnerKycScreenState();
}

class _ChannelPartnerKycScreenState extends State<ChannelPartnerKycScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController accHolderNameController = TextEditingController();
  final TextEditingController accountConfNumberController = TextEditingController();

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

  // Dummy lists for dropdowns
  final List<String> idProofTypes = ['Pan Card','Passport','Driving License','Voter Card','Aadhaar Card'];
  final List<String> addressProofTypes = ['Bank Passbook', 'Aadhaar Card', 'Gas Number','Electricity Bill'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KYC Details')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // === Customer Details Group ===

              _buildGroupSection(title: 'Customer Details',subTitle: 'Not editable', child: _buildCustomerDetails()),

              // === ID Proof Group ===
              _buildGroupSection(title: 'ID Proof', child: _buildIDProof()),
              // === Address Proof Group ===

              _buildGroupSection(title: 'Address Proof', child: _buildAddressProof()),

              // === Bank Details Group ===
              _buildGroupSection(title: 'Bank Details', child: _buildBankDetails()),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child: Text('Submit KYC'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (idProofFileName == null || addressProofFileName == null) {
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
    );
  }

  Widget _buildGroupSection({required String title,String? subTitle,required Widget child}){
    return  Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4))
          ]),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style:
              TextStyle(color: Colors.blue.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              children: [
                TextSpan(text: title),
              ],
            ),
          ),
          if(subTitle!=null)...[
            const SizedBox(height: 4),
            Text(subTitle,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.red.shade600)),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildCustomerDetails(){
    return GridView.count(
      crossAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        _buildReadOnlyField(
          label: 'Customer Id',
          icon: Icons.badge,
          value: 'KRISHCO/EMP0104'
        ),

        _buildReadOnlyField(
            label: 'Customer Name',
            icon: Icons.person,
            value: 'Channel Partner'
        ),

        _buildReadOnlyField(
            label: 'Contact Number',
            icon: Icons.phone,
            value: '1234567891'
        ),

      ],
    );
  }

  Widget _buildIDProof(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Select ID Type',
              border: OutlineInputBorder(),
            ),
            items: idProofTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
            value: selectedIdProofType,
            onChanged: (val) => setState(() => selectedIdProofType = val),
            validator: (value) => value == null ? 'Select ID Type' : null,
          ),
        ),
        SizedBox(width: 10.0,),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                idProofFileName = 'idproof_example.pdf';
              });
            },
            icon: Icon(Icons.upload_file),
            label: FittedBox(child: Text(idProofFileName == null ? selectedIdProofType == null ? 'Upload ID Proof File':'Upload ${selectedIdProofType}' : idProofFileName!)),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetails(){
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 8.0,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      children: [
        _buildTextFormField(controller: bankNameController, label: 'Bank Name',iconData: Icons.account_balance,
          validator: (value) => value == null || value.isEmpty ? 'Enter Bank Name' : null,
        ),
        _buildTextFormField(controller: accHolderNameController, label: 'Acc. Holder Name',iconData: Icons.person,
          validator: (value) => value == null || value.isEmpty ? 'Enter Acc. Holder Name' : null,
        ),
        _buildTextFormField(controller: accountNumberController, label:  'Account No',iconData: Icons.numbers,
          validator: (value) => value == null || value.isEmpty ? 'Enter Account Number' : null,
        ),
        _buildTextFormField(controller: accountConfNumberController, label:  'Confirm Acc. No',iconData: Icons.numbers,
          validator: (value) => value == null || value.isEmpty ? 'Enter Confirm Acc. No' : null,
        ),
       _buildTextFormField(controller: ifscController, label: 'IFSC Code',iconData: Icons.code,
         validator: (value) => value == null || value.isEmpty ? 'Enter IFSC Code' : null,
       ),
      ],
    );
  }

  Widget _buildAddressProof(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Address Proof Type',
                    border: OutlineInputBorder(),
                  ),
                  items: addressProofTypes
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  value: selectedAddressProofType,
                  onChanged: (val) => setState(() => selectedAddressProofType = val),
                  validator: (value) => value == null ? 'Select Address Proof Type' : null,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement file picker here
                    setState(() {
                      addressProofFileName = 'addressproof_example.pdf';
                    });
                  },
                  icon: Icon(Icons.upload_file),
                  label: FittedBox(child: Text(addressProofFileName == null ? selectedAddressProofType == null ? 'Upload Address Proof File':'Upload ${selectedAddressProofType}' : addressProofFileName!)),
                ),
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
          '$label',
          style: const TextStyle(
            fontSize: 12,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration.collapsed(
                    hintText: value,
                    border: InputBorder.none,
                    enabled: false,
                    hintStyle: TextStyle(color: Colors.black87),
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
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          contentPadding: EdgeInsets.zero,
          labelText: label,
        border: const OutlineInputBorder(),
    ),
    validator: validator ??
    (value) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
    return 'Enter $label';
    }
    return null;
        }
    );

    }
}
