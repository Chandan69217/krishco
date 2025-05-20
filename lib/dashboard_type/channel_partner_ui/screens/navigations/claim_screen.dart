import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class ClaimScreen extends StatefulWidget {
  @override
  _ClaimScreenState createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
  int selectedTabIndex = 0;

  final List<Map<String, dynamic>> claimList = [
    {
      'sno': 1,
      'claimNumber': 'CLM1234563',
      'invoiceId': 'INV98765',
      'invoiceDate': '2025-04-12',
      'claimDate': '2025-05-01',
      'enterpriseDetails': 'Enterprise A',
      'claimedFromOthers': 'No',
      'invoiceCopy': 'Available',
      'claimAmount': '5000',
      'approvedAmount': '4500',
      'gainedPoints': '50',
      'remarks': 'Partial damage covered',
      'status': 'Approved',
      'statusMessage': 'Processed',
      'createdAt': '2025-05-01',
    },
  ];

  final List<Map<String, dynamic>> reportingClaims = [
    {
      'claimNumber': 'CLM123456',
      'claimMessage': 'Product damaged',
      'invoiceId': 'INV98765',
      'invoiceDate': '2025-04-12',
      'claimDate': '2025-05-01',
      'claimedBy': 'John Doe',
      'claimAmount': '5000',
      'approvedAmount': '4500',
      'remarks': 'Partial damage covered',
      'status': 'Approved',
      'statusMessage': 'Processed successfully',
      'createdAt': '2025-05-01',
      'updatedAt': '2025-05-03',
    },
    {
      'claimNumber': 'CLM123457',
      'claimMessage': 'Missing item',
      'invoiceId': 'INV98766',
      'invoiceDate': '2025-04-15',
      'claimDate': '2025-05-05',
      'claimedBy': 'Jane Smith',
      'claimAmount': '3000',
      'approvedAmount': '3000',
      'remarks': 'Fully reimbursed',
      'status': 'Approved',
      'statusMessage': 'Payment issued',
      'createdAt': '2025-05-05',
      'updatedAt': '2025-05-07',
    },
  ];

  List<Map<String, dynamic>> _filteredClaims = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateFilteredClaims();
    _searchController.addListener(_filterClaims);
  }

  void _updateFilteredClaims() {
    final data = selectedTabIndex == 0 ? claimList : reportingClaims;
    _filteredClaims = List.from(data);
  }

  void _filterClaims() {
    final query = _searchController.text.toLowerCase();
    final data = selectedTabIndex == 0 ? claimList : reportingClaims;
    setState(() {
      _filteredClaims = data.where((claim) {
        return claim['claimNumber'].toLowerCase().contains(query) ||
            claim['invoiceId'].toLowerCase().contains(query) ||
            claim['claimedBy'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
      _searchController.clear();
      _updateFilteredClaims();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabTitles = ["Claim List", "Reporting Claim"];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Custom tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(tabTitles.length, (index) {
                    final isSelected = selectedTabIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabSelected(index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabTitles[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Search box
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search by Claim Number, Invoice ID or Claimed By",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.receipt, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    selectedTabIndex == 0 ? "List of Claim Invoices" : "List of Reporting Claims",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: _filteredClaims.isNotEmpty
                  ? ListView.builder(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 80),
                itemCount: _filteredClaims.length,
                itemBuilder: (context, index) {
                  final claim = _filteredClaims[index];
                  return Card(
                    key: ValueKey(claim['claimNumber']),
                    color: Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ExpansionTile(
                      title: Text(
                        "Claim Number: ${claim['claimNumber']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Status: ${claim['status']}",
                        style: TextStyle(
                          color: _getStatusColor(claim['status']),
                        ),
                      ),
                      children: [
                        ClaimCard(
                          claimData: claim,
                          onView: (){},
                          onCancel: selectedTabIndex == 0 ? (){

                          }:null,
                          onDownload: selectedTabIndex == 1 ? (){

                          }:null,
                        )
                      ],
                    ),
                  );
                },
              )
                  : Center(
                child: Text("No claims found",
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _fabButton(),
    );
  }


  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _fabButton() {
    return FloatingActionButton.extended(
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>_ClaimInvoiceForm()));
      },
      icon: Icon(Icons.add),
      label: Text("Create Claim"),
      backgroundColor: Colors.blue,
    );
  }
}



class ClaimCard extends StatelessWidget {
  final Map<String, dynamic> claimData;
  final VoidCallback? onCancel;
  final VoidCallback? onView;
  final VoidCallback? onDownload;

  const ClaimCard({
    Key? key,
    required this.claimData,
    this.onCancel,
    this.onView,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (claimData.containsKey('claimMessage'))
            _buildRow("Claim Message", claimData['claimMessage']),
          if (claimData.containsKey('claimNumber'))
            _buildRow("Claim Number", claimData['claimNumber']),
          _buildRow("Invoice ID", claimData['invoiceId']),
          _buildRow("Invoice Date", claimData['invoiceDate']),
          _buildRow("Claim Date", claimData['claimDate']),
          if (claimData.containsKey('claimedBy'))
            _buildRow("Claimed By", claimData['claimedBy']),
          if (claimData.containsKey('enterpriseDetails'))
            _buildRow("Enterprise Details", claimData['enterpriseDetails']),
          if (claimData.containsKey('claimedFromOthers'))
            _buildRow("Claimed From Others", claimData['claimedFromOthers']),
          if (claimData.containsKey('invoiceCopy'))
            _buildRow("Invoice Copy", claimData['invoiceCopy']),
          _buildRow("Claim Amount", "₹${claimData['claimAmount']}"),
          _buildRow("Approved Amount", "₹${claimData['approvedAmount']}"),
          if (claimData.containsKey('gainedPoints'))
            _buildRow("Gained Points", claimData['gainedPoints']),
          _buildRow("Remarks", claimData['remarks']),
          _buildRow(
            "Status",
            claimData['status'],
            color: _getStatusColor(claimData['status']),
          ),
          _buildRow("Status Message", claimData['statusMessage']),
          _buildRow("Created At", claimData['createdAt']),
          if (claimData.containsKey('updatedAt'))
            _buildRow("Updated At", claimData['updatedAt']),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onDownload != null)
                TextButton.icon(
                  onPressed: onDownload,
                  icon: const Icon(Icons.download, color: Colors.blue),
                  label: const Text("Claim Copy",
                      style: TextStyle(color: Colors.blue)),
                ),
              if (onCancel != null)
                TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text("Cancel Claim",
                      style: TextStyle(color: Colors.red)),
                ),
              if (onView != null) const SizedBox(width: 12),
              if (onView != null)
                ElevatedButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility),
                  label: const Text("View Claim"),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRow(String title, String? value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text("$title:", style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value ?? "-", style: TextStyle(color: color ?? Colors.black87)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}



class _ClaimInvoiceForm extends StatefulWidget {
  @override
  _ClaimInvoiceFormState createState() => _ClaimInvoiceFormState();
}

class _ClaimInvoiceFormState extends State<_ClaimInvoiceForm> {
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

