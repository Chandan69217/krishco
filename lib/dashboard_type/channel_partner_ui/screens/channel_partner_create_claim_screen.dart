import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChannelPartnerCreateClaimScreen extends StatefulWidget {
  @override
  _ChannelPartnerCreateClaimScreenState createState() => _ChannelPartnerCreateClaimScreenState();
}

class _ChannelPartnerCreateClaimScreenState extends State<ChannelPartnerCreateClaimScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _invoiceNumberController = TextEditingController();
  final TextEditingController _claimAmountController = TextEditingController();
  final TextEditingController _filePreviewController = TextEditingController(text: 'No file uploaded yet.');
  final TextEditingController _enterpriseNameController = TextEditingController();
  final TextEditingController _enterpriseNumberController = TextEditingController();
  final TextEditingController _enterpriseAddressController = TextEditingController();


  DateTime? _invoiceDate = DateTime.now();
  String? _enterpriseDetails;
  bool _notInList = false;
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        _filePreviewController.text = _selectedFile!.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      appBar: AppBar(
        title: const Text('Claim Invoice'),
      ),
      body: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0B6EF6)),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(text: 'Note: '),
                        TextSpan(
                          text: 'All ',
                          style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.normal),
                        ),
                        TextSpan(children: [
                          TextSpan(
                            text: '(',
                            style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: '*',
                          ),
                          TextSpan(
                            text: ') ',
                            style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.normal),
                          )
                        ]),
                        TextSpan(
                          text: 'Fields are Mandatory.',
                          style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              TextFormField(
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
                controller: TextEditingController(
                  text: _invoiceDate != null ? DateFormat('dd-MM-yyyy').format(_invoiceDate!) : '',
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
                    lastDate: DateTime(2100),
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Enterprise Details *',
                  border: OutlineInputBorder(),
                ),
                value: _enterpriseDetails,
                items: [
                  DropdownMenuItem(child: Text("Select Enterprise Details"), value: null),
                  // Add actual enterprise options here
                ],
                onChanged: (value) => setState(() => _enterpriseDetails = value),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('From where you purchased is not in the enterprise list.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                value: _notInList,
                onChanged: (value) => setState(() => _notInList = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              if (_notInList) ...[
                const SizedBox(height: 16),
                TextFormField(
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
                  controller: _enterpriseNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
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
                  controller: _enterpriseAddressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Enterprise Address (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              TextFormField(
                controller: _claimAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Claim Amount *',
                  border: OutlineInputBorder(),
                  hintText: 'Claim Amount (*)',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
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
                    onPressed: _pickFile,
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
              ),

              const SizedBox(height: 34),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, color: Color(0xFFE03E4E)),
                    label: const Text('Reset', style: TextStyle(color: Color(0xFFE03E4E))),
                    onPressed: () {
                      _formKey.currentState!.reset();
                      _invoiceNumberController.clear();
                      _claimAmountController.clear();
                      _filePreviewController.text = 'No file uploaded yet.';
                      _enterpriseNameController.clear();
                      _enterpriseNumberController.clear();
                      _enterpriseAddressController.clear();
                      setState(() {
                        _enterpriseDetails = null;
                        _notInList = false;
                        _invoiceDate = DateTime.now();
                        _selectedFile = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE03E4E)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.check, color: Color(0xFF2F6F4E)),
                    label: const Text('Submit', style: TextStyle(color: Color(0xFF2F6F4E))),
                    onPressed: () {
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

                        // Proceed with submission
                      }


                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2F6F4E)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}