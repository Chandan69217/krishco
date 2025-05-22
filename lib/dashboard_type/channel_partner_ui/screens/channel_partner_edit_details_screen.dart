import 'package:flutter/material.dart';

class ChannelPartnerEditDetailsScreen extends StatefulWidget {
  const ChannelPartnerEditDetailsScreen({super.key});

  @override
  State<ChannelPartnerEditDetailsScreen> createState() => _ChannelPartnerEditDetailsScreenState();
}

class _ChannelPartnerEditDetailsScreenState extends State<ChannelPartnerEditDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _customerFirstNameController = TextEditingController();
  final TextEditingController _customerLastNameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _altContactNoController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  String gender = 'male';
  String maritalStatus = 'unmarried';

  final blue600 = Colors.blue.shade600;
  final red600 = Colors.red.shade600;
  final borderGray = Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGroupSection(title: 'Credentials Details', subTitle: 'Not Editable', child: _buildCredentialsDetails()),
              _buildGroupSection(title: 'Basic Details *', subTitle: 'Note: Fill all mandatory(*) fields!!', child: _buildBasicDetails()),
              _buildGroupSection(title: 'Address Information *', child: _buildAddressDetails()),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(onPressed: (){}, child: Text('Update'))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialsDetails() {
    return GridView.count(
      crossAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        _buildReadOnlyField(label: 'Member Id', icon: Icons.badge, value: 'KRISHCO/EMP0104'),
        _buildReadOnlyField(label: 'User Id', icon: Icons.badge, value: '1234567891'),
      ],
    );
  }

  Widget _buildReadOnlyField({required String label, required IconData icon, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
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

  Widget _buildBasicDetails() {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 8,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 3,
          shrinkWrap: true,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Group Category *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderGray)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: blue600, width: 2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              value: 'Channel Partner',
              items: const [
                DropdownMenuItem(value: 'Channel Partner', child: Text('Channel Partner')),
              ],
              onChanged: (_) {},
            ),
            _buildTextFormField(controller: _customerFirstNameController, label: 'Customer First name *', iconData: Icons.contact_page),
            _buildTextFormField(controller: _customerLastNameController, label: 'Customer Last name (Optional)', iconData: Icons.contact_page),
            _buildTextFormField(controller: _contactNoController, label: 'Contact No. *', iconData: Icons.numbers),
            _buildTextFormField(controller: _altContactNoController, label: 'Alt. Contact No. (Optional)', iconData: Icons.numbers),
            _buildTextFormField(controller: _dobController, label: 'DOB *', iconData: Icons.calendar_month),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            Row(
              children: [
                Radio<String>(value: 'male', groupValue: gender, onChanged: (val) => setState(() => gender = val!)),
                const Text('Male'),
                Radio<String>(value: 'female', groupValue: gender, onChanged: (val) => setState(() => gender = val!)),
                const Text('Female'),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Marital Status *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            Row(
              children: [
                Radio<String>(value: 'unmarried', groupValue: maritalStatus, onChanged: (val) => setState(() => maritalStatus = val!)),
                const Text('Unmarried'),
                Radio<String>(value: 'married', groupValue: maritalStatus, onChanged: (val) => setState(() => maritalStatus = val!)),
                const Text('Married'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 8,
          childAspectRatio: 3,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            _buildTextFormField(controller: _emailTextController, label: 'Email-Id (Optional)', iconData: Icons.email),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressDetails() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 8,
      childAspectRatio: 3,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _buildTextFormField(controller: _countryController, label: 'Country *', iconData: Icons.public),
        _buildTextFormField(controller: _stateController, label: 'State *', iconData: Icons.map),
        _buildTextFormField(controller: _districtController, label: 'District *', iconData: Icons.location_city),
        _buildTextFormField(controller: _cityController, label: 'City *', iconData: Icons.location_city),
        _buildTextFormField(controller: _addressController, label: 'Address *', iconData: Icons.home),
        _buildTextFormField(controller: _pincodeController, label: 'Pincode *', iconData: Icons.pin_drop),
      ],
    );
  }

  Widget _buildTextFormField({required TextEditingController controller, required String label, required IconData iconData, bool isRequired = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        contentPadding: EdgeInsets.zero,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blue600, width: 2)),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator ?? (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return 'Enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildGroupSection({required String title, String? subTitle, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w600, fontSize: 18),
              children: [TextSpan(text: title)],
            ),
          ),
          if (subTitle != null) ...[
            const SizedBox(height: 4),
            Text(subTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.red.shade600)),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}