import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/models/enterprised_related/enterprises_details_list_data.dart';
import 'package:krishco/models/product_related/product_category_data.dart';
import 'package:krishco/models/product_related/product_details_data.dart';
import 'package:krishco/utilities/full_screen_loading.dart';
import 'package:krishco/widgets/choose_file.dart';



class ChannelPartnerPlaceOrderScreen extends StatefulWidget {
  const ChannelPartnerPlaceOrderScreen({super.key,this.onSuccess});
  final VoidCallback? onSuccess;
  @override
  State<ChannelPartnerPlaceOrderScreen> createState() => _ChannelPartnerPlaceOrderScreenState();
}

class _ChannelPartnerPlaceOrderScreenState extends State<ChannelPartnerPlaceOrderScreen> {
  String _orderFor = 'self';
  bool _isEnterpriseNotListed = false;
  final _consumerNumberController = TextEditingController();
  final _consumerNameController = TextEditingController();
  final _consumerAddressController = TextEditingController();
  final _quantityController = TextEditingController();
  final TextEditingController _filePreviewController = TextEditingController(text: 'Choose File');
  List<File> _selectedFile = [];
  File? _pickedFile;
  List<_ProductItem> _addedProductList = [];
  int _currentPage = 0;
  final int _itemsPerPage = 5;
  final ValueNotifier<ProductCategoryListData?> _productCategoryList = ValueNotifier<ProductCategoryListData?>(null);
  ValueNotifier<EnterpriseDetailsListData?> taggedEnterprise = ValueNotifier<EnterpriseDetailsListData?>(null);
  String? _enterpriseDetails;
  final ValueNotifier<ProdDetailsList?> _productList = ValueNotifier<ProdDetailsList?>(null);
  final ValueNotifier<String?> _selectedProduct = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedProductCategory = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedQuantity = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getProductCategoryList();
      _getEnterprises();
    });
  }

  void _getEnterprises()async{
    final taggedEnterpriseObj = APIService(context:context).taggedEnterprise;
    final data = await taggedEnterpriseObj.getTaggedEnterpriseOfLoginCustomer();
    if(data !=null){
      taggedEnterprise.value = EnterpriseDetailsListData.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        appBar: AppBar(
          title: const Text(
            'Order Details',
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSection('Basic Details', _buildBasicDetailsSection()),
                _buildSection('Order By Bill', _buildOrderByUploadBill()),
                _buildSection('Order By Product Details', _buildOrderByProductDetails()),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
      if(_isLoading)
        FullScreenLoading()
      ]
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
          ValueListenableBuilder<EnterpriseDetailsListData?>(
            valueListenable: taggedEnterprise,
            builder: (context,value,child){
              return DropdownButtonFormField<String>(
                key: Key('enterprise_dropdown'),
                validator:  !_isEnterpriseNotListed ? (value){
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
                onChanged: !_isEnterpriseNotListed ? (value) => setState(() => _enterpriseDetails = value):null,
              );
            },
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
              keyboardType: TextInputType.number,
              key: Key('Self_Customer_Number'),
              validator: (value){
                if(value == null||value.isEmpty){
                  return 'Enter Consumer Number';
                }
                return null;
              },
              controller: _consumerNumberController,
              decoration: const InputDecoration(
                labelText: 'Consumer Number *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: Key('Self Customer Name'),
              controller: _consumerNameController,
              validator: (value){
                if(value == null||value.isEmpty){
                  return 'Enter Consumer Name';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Consumer Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: Key('Self Customer Address'),
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
            key: Key('Other_Customer_Number'),
            validator: (value){
              if(value == null||value.isEmpty){
                return 'Enter Consumer Number';
              }
              return null;
            },
            controller: _consumerNumberController,
            decoration: const InputDecoration(
              labelText: 'Consumer Number *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            key: Key('Other_Customer_Name'),
            validator: (value){
              if(value == null||value.isEmpty){
                return 'Enter Consumer Name';
              }
              return null;
            },
            controller: _consumerNameController,
            decoration: const InputDecoration(
              labelText: 'Consumer Name *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            key: Key('Other_Customer_Address'),
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

  // Widget _buildOrderByUploadBill() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Expanded(
  //             child: TextFormField(
  //               controller: _filePreviewController,
  //               maxLines: 1,
  //               readOnly: true,
  //               textAlignVertical: TextAlignVertical.center,
  //               decoration: InputDecoration(
  //                 labelText: 'Choose File',
  //                 border: const OutlineInputBorder(),
  //
  //                 suffixIcon: _filePreviewController.text.toLowerCase().contains('choose file')
  //                     ? TextButton.icon(
  //                   icon: const Icon(Icons.attach_file),
  //                   label: const Text("Upload"),
  //                   onPressed: (){
  //                     ChooseFile.showImagePickerBottomSheet(context, (file){
  //                       setState(() {
  //                         _selectedFile = file;
  //                         _filePreviewController.text = file.path.split('/').last;
  //                       });
  //                     });
  //                   },
  //                 )
  //                     : IconButton(
  //                   icon: const Icon(Icons.close),
  //                   onPressed: () {
  //                     setState(() {
  //                       _selectedFile = null;
  //                       _filePreviewController.text = 'Choose file';
  //                     });
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: 10),
  //         ],
  //       ),
  //       if(_selectedFile != null)...[
  //         const SizedBox(height: 10),
  //         const Text(
  //           'Added Bill',
  //           style: TextStyle(
  //             color: Color(0xFF1E40AF),
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         _buildSelectedImagePreview()
  //       ],
  //     ],
  //   );
  // }
  //
  // Widget _buildSelectedImagePreview() {
  //   if (_selectedFile == null) return const SizedBox();
  //   return Stack(
  //     children: [
  //       ClipRRect(
  //         borderRadius: BorderRadius.circular(8),
  //         child: Image.file(
  //           _selectedFile!,
  //           width: double.infinity,
  //           height: 200,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       Positioned(
  //         top: 8,
  //         right: 8,
  //         child: GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               _selectedFile = null;
  //               _filePreviewController.text = 'Choose File';
  //             });
  //           },
  //           child: Container(
  //             padding: const EdgeInsets.all(4),
  //             decoration: const BoxDecoration(
  //               color: Colors.black54,
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(Icons.close, size: 20, color: Colors.white),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }


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
                    onPressed: (){
                      ChooseFile.showImagePickerBottomSheet(context, (file){
                        setState(() {
                          _pickedFile = file;
                          _filePreviewController.text = _pickedFile!.path.split('/').last;
                        });
                      });
                    },
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
              onPressed: _pickedFile != null ? () {
                if(_pickedFile != null){
                  setState(() {
                    _selectedFile.add(_pickedFile!);
                    _pickedFile = null;
                    _filePreviewController.text = 'Choose file';
                  });
                }
              }:null,
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
              child: ValueListenableBuilder<ProductCategoryListData?>(
                valueListenable: _productCategoryList,
                builder: (context,value,child) {
                  return DropdownButtonFormField<String?>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Product Category',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedProductCategory.value,
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: FittedBox(child: Text('Select Product Category')),
                      ),
                      if(value!= null)
                        ...[
                          ...value.data.map((x){
                            return DropdownMenuItem<String?>(
                              value: x.id.toString(),
                                child: FittedBox(child: Text(x.catName.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ))
                            );
                          }).whereType<DropdownMenuItem<String?>>().toList()
                        ]
                    ],
                    onChanged: (val) async {
                      _selectedProductCategory.value = val;
                      _selectedProduct.value = null;
                      _selectedQuantity.value = null;
                      _quantityController.text = '';
                      _productList.value = null;
                      if (val != null) {
                        final response = await APIService(context: context)
                            .productDetails
                            .getProdDetailsByProductID(val);
                        if (response != null) {
                          _productList.value = ProdDetailsList.fromJson(response);
                        }
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ValueListenableBuilder2<ProdDetailsList?, String?>(
                first: _productList,
                second: _selectedProduct,
                builder: (context, productList, selectedProduct, child) {
                  return DropdownButtonFormField<String?>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedProduct,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: FittedBox(child: Text('Select Product Name')),
                      ),
                      if (productList != null)
                        ...productList.data.map((x) {
                          return DropdownMenuItem<String?>(
                            value: x.prdId,
                            child: Text(
                              x.prdName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList()
                    ],
                    onChanged: productList == null ? null : (val) {
                      _selectedProduct.value = val;
                    },
                  );
                },
              ),
            ),

          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ValueListenableBuilder<String?>(
                valueListenable: _selectedProduct,
                builder: (context,value,child){
                  return TextFormField(
                    controller: _quantityController,
                    onChanged: (x){
                      _selectedQuantity.value = x;
                    },
                    keyboardType: TextInputType.number,
                    enabled: value!=null,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            ValueListenableBuilder<String?>(
              valueListenable: _selectedQuantity,
              builder: (context,value,child){
                return ElevatedButton.icon(
                    onPressed: value == null ? null : () {
                      final addedProduct = _productList.value!.data
                          .firstWhere((x) => x.prdId == _selectedProduct.value);

                      final alreadyExists = _addedProductList.any((item) => item.name == addedProduct.prdName);

                      if (alreadyExists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Center(child: Text('This product is already added.')),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        return; // prevent adding duplicate
                      }

                      final add = _ProductItem(
                        id: addedProduct.id,
                        category: _productCategoryList.value!.data
                            .firstWhere((x) => x.id.toString() == _selectedProductCategory.value).catName!,
                        name: addedProduct.prdName,
                        qty: int.tryParse(_selectedQuantity.value!) ?? 0,
                        unit: addedProduct.unitType,
                        imageUrl: addedProduct.prodPic,
                      );

                      setState(() {
                        _addedProductList.add(add);
                        _selectedProduct.value = null;
                        _selectedQuantity.value = null;
                        _quantityController.text = '';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Product "${add.name}" added successfully.\nQuantity: ${add.qty}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );

                      });
                    },
                    icon: const Icon(Icons.add_circle,color: Colors.green),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.green),
                  ),
                );
              },
            ),
          ],
        ),

        SizedBox(height: 10),
        const Text(
          'Added Product List',
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        _buildSelectedItemTable()

      ],
    );
  }

  Widget _buildSelectedItemTable() {
    final int totalItems = _addedProductList.length;
    final int totalPages = (totalItems / _itemsPerPage).ceil();

    if (_currentPage >= totalPages && totalPages > 0) {
      _currentPage = totalPages - 1;
    } else if (totalPages == 0) {
      _currentPage = 0;
    }

    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = (_currentPage + 1) * _itemsPerPage;
    final List<_ProductItem> visibleItems = _addedProductList.sublist(
      startIndex,
      endIndex > totalItems ? totalItems : endIndex,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_addedProductList.isEmpty)
          const Center(child: Text("No products added yet."))
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 800),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: const {
                    0: FixedColumnWidth(60),
                    1: FixedColumnWidth(60),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                    4: FixedColumnWidth(60),
                    5: FixedColumnWidth(60),
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
                              imageUrl: visibleItems[i].imageUrl,
                              width: 40,
                              height: 40,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
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
                              _addedProductList.removeAt(startIndex + i);
                              final totalPages = (_addedProductList.length / _itemsPerPage).ceil();
                              if (_currentPage >= totalPages && totalPages > 0) {
                                _currentPage = totalPages - 1;
                              } else if (totalPages == 0) {
                                _currentPage = 0;
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
        if(_addedProductList.isNotEmpty)
        _buildPaginationControls(),
      ],
    );
  }

  Widget _buildPaginationControls() {
    final int totalPages = (_addedProductList.length / _itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
          icon: Icon(Icons.skip_previous,color: _currentPage > 0? Colors.blue.shade600:null,),
        ),
        const SizedBox(width: 16),
        Text('Page ${_currentPage + 1} of $totalPages'),
        const SizedBox(width: 16),
        IconButton(
          onPressed: _currentPage < totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
          icon: Icon(Icons.skip_next,color:  _currentPage < totalPages - 1 ? Colors.blue.shade600:null,),
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


  void _getProductCategoryList() async{
    final response = await APIService(context: context).productDetails.getProductCategory();
    if(response !=  null){
      _productCategoryList.value = ProductCategoryListData.fromJson(response);
    }
  }


  void _onReset()async {
    setState(() {
      _enterpriseDetails= null;
      _selectedProductCategory.value= null;
      _consumerNumberController.text = '';
      _consumerAddressController.text = '';
      _consumerNameController.text = '';
      _selectedFile = [];
      _filePreviewController.text = 'Choose File';
      _addedProductList = [];
    });
  }


  void _onSubmit()async {
    if(!_formKey.currentState!.validate()){
      return;
    }
    if(_selectedFile.isEmpty && _addedProductList.isEmpty ){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(
          child: Text('Please add order by Bill or Product Details for place order'),
        ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final products = _addedProductList.map((x)=>{
      "id": x.id.toString(),
      'quantity' : x.qty.toString()
    }).toList();

    final response = await APIService(context:context).orderRelated.orderForSelf(
      orderBill: _selectedFile,
      orderForm: _enterpriseDetails,
      orderFromOther: _isEnterpriseNotListed?{
        'name' : _consumerNameController.text,
        'number' : _consumerNumberController.text,
        'address':_consumerAddressController.text,
      }:null,
      productDetails: products
    );

    if(response != null){
      final status = response['isScuss'];
      if(status){
        _showSnackBar(message: response['messages'],status: status);
        _onReset();
      }else{
        final error = response['error'] as Map<String,dynamic>;
        _showSnackBar(message: error.values.toString(),status: status);
      }

    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar({required String message,bool? status = true}){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(child: Text(message),),
          backgroundColor: status! ? Colors.green : Colors.red ,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        )
    );
  }
}

class _ProductItem {
  final String category;
  final String name;
  final int qty;
  final String unit;
  final String imageUrl;
  final int id;

  _ProductItem({
    required this.category,
    required this.name,
    required this.qty,
    required this.unit,
    required this.imageUrl,
    required this.id
  });
}


class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueNotifier<A> first;
  final ValueNotifier<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    Key? key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}
