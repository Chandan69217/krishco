import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ChannelPartnerPlaceOrderScreen extends StatefulWidget {
  const ChannelPartnerPlaceOrderScreen({super.key});

  @override
  State<ChannelPartnerPlaceOrderScreen> createState() => _ChannelPartnerPlaceOrderScreenState();
}

class _ChannelPartnerPlaceOrderScreenState extends State<ChannelPartnerPlaceOrderScreen> {
  String _orderFor = 'self';
  bool _isEnterpriseNotListed = false;
  final _consumerNumberController = TextEditingController();
  final _consumerNameController = TextEditingController();
  final _consumerAddressController = TextEditingController();
  final TextEditingController _filePreviewController = TextEditingController(text: 'Choose File');
  List<PlatformFile> _selectedFile = [];
  PlatformFile? _pickedFile;
  List<_ProductItem> _productList = [
    _ProductItem(
      category: 'Electronics',
      name: 'Wireless Mouse',
      qty: 2,
      unit: 'pcs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Electronics',
      name: 'Bluetooth Keyboard',
      qty: 1,
      unit: 'pcs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Stationery',
      name: 'A4 Notebook',
      qty: 5,
      unit: 'pcs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Stationery',
      name: 'Ballpoint Pen',
      qty: 10,
      unit: 'pcs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Furniture',
      name: 'Office Chair',
      qty: 1,
      unit: 'pcs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Furniture',
      name: 'Desk Organizer',
      qty: 3,
      unit: 'pcs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Electronics',
      name: 'Webcam',
      qty: 1,
      unit: 'pcs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Electronics',
      name: 'HDMI Cable',
      qty: 4,
      unit: 'pcs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Cleaning',
      name: 'Surface Cleaner',
      qty: 2,
      unit: 'bottles',
      imageUrl: 'https://via.placeholder.com/50',
    ),
    _ProductItem(
      category: 'Pantry',
      name: 'Coffee Pack',
      qty: 6,
      unit: 'packs',
      imageUrl: 'https://via.placeholder.com/50',
    ),
  ];
  int _currentPage = 0;
  final int _itemsPerPage = 5;



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Order Details',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSection('Basic Details', _buildBasicDetailsSection()),
            _buildSection('Order By Bill', _buildOrderByUploadBill()),
            _buildSection('Order By Product Details', _buildOrderByProductDetails()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBasicDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Order For *:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Row(
              children: [
                Radio<String>(
                  value: 'self',
                  groupValue: _orderFor,
                  onChanged: (val) => setState(() => _orderFor = val!),
                ),
                const Text('Self'),
                Radio<String>(
                  value: 'others',
                  groupValue: _orderFor,
                  onChanged: (val) => setState(() => _orderFor = val!),
                ),
                const Text('Others'),
              ],
            ),
          ],
        ),

        if(_orderFor == 'self')...[
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Enterprise Details *',
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select Enterprise Details'),
            items: ['Enterprise A', 'Enterprise B']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {},
          ),
          Row(
            children: [
              Checkbox(
                value: _isEnterpriseNotListed,
                onChanged: (val) => setState(() => _isEnterpriseNotListed = val!),
              ),
              const Expanded(
                child: Text('From where you purchased is not in the enterprise list.'),
              ),
            ],
          ),

          if (_isEnterpriseNotListed) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _consumerNumberController,
              decoration: const InputDecoration(
                labelText: 'Consumer Number *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _consumerNameController,
              decoration: const InputDecoration(
                labelText: 'Consumer Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _consumerAddressController,
              decoration: const InputDecoration(
                labelText: 'Consumer Address (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ],

        // 👇 Conditionally show when orderFor is 'others'
        if (_orderFor == 'others') ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _consumerNumberController,
            decoration: const InputDecoration(
              labelText: 'Consumer Number *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _consumerNameController,
            decoration: const InputDecoration(
              labelText: 'Consumer Name *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _consumerAddressController,
            decoration: const InputDecoration(
              labelText: 'Consumer Address (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ],
    );
  }


  Widget _buildSection(String title, Widget child) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF007BFF),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
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
              onPressed: () {},
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
              onPressed: () {},
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

  Widget _buildOrderByUploadBill() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // const Text('Choose File:', style: TextStyle(fontWeight: FontWeight.bold)),
            // const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _filePreviewController,
                maxLines: 1,
                readOnly: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  labelText: 'Choose File',
                  border: const OutlineInputBorder(),

                  suffixIcon: _filePreviewController.text.toLowerCase().contains('choose file')
                      ? TextButton.icon(
                    icon: const Icon(Icons.attach_file),
                    label: const Text("Upload"),
                    onPressed: _pickFile,
                  )
                      : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _pickedFile = null;
                        _filePreviewController.text = 'Choose file';
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                if(_pickedFile != null){
                  setState(() {
                    _selectedFile.add(_pickedFile!);
                    _pickedFile = null;
                    _filePreviewController.text = 'Choose file';
                  });
                }
              },
              icon: const Icon(Icons.add_circle,color: Colors.green,),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.green),
              ),
            ),
          ],
        ),
        if(_selectedFile.isNotEmpty)...[
          const SizedBox(height: 10),
          const Text(
            'Added Bill List',
            style: TextStyle(
              color: Color(0xFF1E40AF),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _buildSelectedImagesGrid()
        ],
      ],
    );
  }

  Widget _buildSelectedImagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _selectedFile.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final file = File(_selectedFile[index].path!);
        return Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                file,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFile.removeAt(index);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderByProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Product Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: FittedBox(child: Text('Select Product Category')),
                  ),
                ],
                onChanged: (val) {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: FittedBox(child: Text('Select Product Name')),
                  ),
                ],
                onChanged: (val) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_circle,color: Colors.green),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.green),
              ),
            ),
          ],
        ),
        if(_productList.isNotEmpty)...[
          const SizedBox(height: 10),
          const Text(
            'Added Product List',
            style: TextStyle(
              color: Color(0xFF1E40AF),
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildSelectedItemTable()
        ]
      ],
    );
  }

  Widget _buildSelectedItemTable() {
    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = (_currentPage + 1) * _itemsPerPage;
    final List<_ProductItem> visibleItems =
    _productList.sublist(startIndex, endIndex > _productList.length ? _productList.length : endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 800),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FixedColumnWidth(40),
                  1: FixedColumnWidth(60),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                  4: FixedColumnWidth(60),
                  5: FixedColumnWidth(50),
                  6: FixedColumnWidth(80),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.blue.shade100),
                    children: [
                      _cell('S.No'),
                      _cell('Image'),
                      _cell('Category'),
                      _cell('Product Name'),
                      _cell('Qty'),
                      _cell('Unit'),
                      _cell('Action'),
                    ],
                  ),
                  for (int i = 0; i < visibleItems.length; i++)
                    TableRow(
                      children: [
                        _cell('${startIndex + i + 1}'),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: CachedNetworkImage(
                            imageUrl: visibleItems[i].imageUrl
                            ,width: 40,
                            height: 40,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Image.asset('assets/logo/Placeholder_image.webp'),
                          ),
                        ),
                        _cell(visibleItems[i].category),
                        _cell(visibleItems[i].name),
                        _cell('${visibleItems[i].qty}'),
                        _cell(visibleItems[i].unit),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => setState(() {
                            _productList.removeAt(startIndex + i);
                            final totalPages = (_productList.length / _itemsPerPage).ceil();
                            if (_currentPage >= totalPages) {
                              _currentPage = totalPages - 1;
                            }
                          }),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildPaginationControls(),
      ],
    );
  }


  Widget _buildPaginationControls() {
    final int totalPages = (_productList.length / _itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
          child: const Text('Previous'),
        ),
        const SizedBox(width: 16),
        Text('Page ${_currentPage + 1} of $totalPages'),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _currentPage < totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }


  @override
  void dispose() {
    _consumerNumberController.dispose();
    _consumerNameController.dispose();
    _consumerAddressController.dispose();
    _filePreviewController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.first;
        _filePreviewController.text = _pickedFile!.name;
      });
    }
  }

}

class _ProductItem {
  final String category;
  final String name;
  final int qty;
  final String unit;
  final String imageUrl;

  _ProductItem({
    required this.category,
    required this.name,
    required this.qty,
    required this.unit,
    required this.imageUrl,
  });
}


