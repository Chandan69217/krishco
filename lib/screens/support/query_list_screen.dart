import 'dart:convert';
import 'dart:io';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/dashboard_type/dashboard_types.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/choose_file.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';
import 'package:krishco/widgets/file_viewer/image_viewer.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

class QueryListScreen extends StatefulWidget {
  const QueryListScreen({super.key});

  @override
  State<QueryListScreen> createState() => _QueryListScreenState();
}

class _QueryListScreenState extends State<QueryListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<List<dynamic>> _queryList = ValueNotifier<List<dynamic>>([]);
  bool _isFabExpanded = false;
  String? _selectedMonthYear;
  DateTime? _selectedDate;
  late Future<bool> _getFromFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _getFromFuture = _loadQueryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _loadQueryData() async {
    final response = await _getQueryList();
    if (response != null) {
      _queryList.value = response['data'] ?? [];
      return true;
    }
    return false;
  }

  List<dynamic> filterList(String type) {
    List<dynamic> filtered =
        type == 'all'
            ? _queryList.value
            : _queryList.value.where((e) => e['query_type'] == type).toList();

    if (_selectedMonthYear != null) {
      filtered =
          filtered.where((e) {
            try {
              final dt = DateTime.parse(e['add_date']);
              final group = DateFormat('MMMM yyyy').format(dt);
              return group == _selectedMonthYear;
            } catch (_) {
              return false;
            }
          }).toList();
    }

    return filtered;
  }

  Future<void> _onRefresh()async{
    setState(() {
      _getFromFuture = _loadQueryData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Queries')),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 3),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: TabBar(
                labelStyle: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                controller: _tabController,
                labelColor: CustColors.nile_blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: CustColors.nile_blue,
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Query'),
                  Tab(text: 'Suggestion'),
                  Tab(text: 'Complaint'),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 3),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Filter By Month: ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(_selectedMonthYear ?? 'All'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        helpText: 'Select Month',
                      );

                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                          _selectedMonthYear = DateFormat(
                            'MMMM yyyy',
                          ).format(picked);
                        });
                      }
                    },
                  ),
                  if (_selectedMonthYear != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _selectedMonthYear = null;
                          _selectedDate = null;
                        });
                      },
                    ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _getFromFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox.square(
                        dimension: 25,
                        child: CircularProgressIndicator(
                          color: CustColors.nile_blue,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return ValueListenableBuilder(
                      valueListenable: _queryList,
                      builder: (context, value, child) {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            _buildList('all',onRefresh:_onRefresh ),
                            _buildList('query',onRefresh: _onRefresh),
                            _buildList('suggestion',onRefresh: _onRefresh),
                            _buildList('complaint',onRefresh: _onRefresh),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('Something went wrong !'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (_isFabExpanded) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 180),
              child: _buildFabOption(
                'Complaint',
                Icons.report_problem,
                Colors.redAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: _buildFabOption(
                'Suggestion',
                Icons.lightbulb_outline,
                Colors.orange,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: _buildFabOption(
                'Query',
                Icons.question_answer,
                Colors.blueAccent,
              ),
            ),
          ],
          FloatingActionButton(
            onPressed: () {
              setState(() => _isFabExpanded = !_isFabExpanded);
            },
            backgroundColor: Colors.blueAccent,
            child: Icon(_isFabExpanded ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildFabOption(String label, IconData icon, Color color) {
    return FloatingActionButton.extended(
      heroTag: label,
      onPressed: () {
        setState(() => _isFabExpanded = false);
        _showQueryBottomSheet(label);
      },
      backgroundColor: color,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildList(String type,{required Future<void> Function() onRefresh}) {
    final list = filterList(type);
    if (list.isEmpty) {
      return const Center(child: Text('No records found.'));
    }

    return CustomRefreshIndicator(
        onRefresh: onRefresh,
        builder: (context, child, controller) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              if (controller.isLoading)
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(color: Colors.blue.shade600,),
                ),
              Transform.translate(
                offset: Offset(0, 100 * controller.value),
                child: child,
              ),
            ],
          );
        },
      child: ListView.builder(
        itemCount: list.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final item = list[index];
          final id = item['id'].toString();
          final photoUrl = item['photo'];
          final type = item['query_type'] ?? '';
          final query = item['query'] ?? '';
          final addDate = item['add_date'] ?? '';
          final status = (item['query_status'] ?? '').toString().toUpperCase();
          final response = item['response'];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (photoUrl != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                ImageViewerScreen(imageUrl: photoUrl),
                          ),
                        );
                      },
                      child: CustomNetworkImage(
                        width: 60,
                        height: 60,
                        imageUrl: photoUrl,
                        borderRadius: BorderRadius.circular(8),
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: getTypeColor(type).withOpacity(0.1),
                                border: Border.all(color: getTypeColor(type)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                type.toUpperCase(),
                                style: TextStyle(
                                  color: getTypeColor(type),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              status,
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          query,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                formatDate(addDate),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (GroupRoles.dashboardType == DashboardTypes.User && status == 'OPENED')
                              TextButton.icon(
                                onPressed: () {
                                  _showResponseBottomSheet(
                                    context,
                                        (response, status) {

                                    },
                                  );
                                },
                                label: Text('Reply'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                                icon: Icon(Icons.reply_all, color: Colors.blue),
                              ),
                          ],
                        ),

                        // Show response if present
                        if (response != null &&
                            response.toString().trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.reply,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    response.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'complaint':
        return Colors.redAccent;
      case 'suggestion':
        return Colors.orange;
      case 'query':
      default:
        return Colors.blueAccent;
    }
  }

  String formatDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  void _showQueryBottomSheet(String selectedType) {
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;
    final TextEditingController _messageController = TextEditingController();
    File? _attachedImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              final screenWidth = MediaQuery.of(context).size.width;
              return Form(
                key: _formKey,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Register $selectedType',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: CustColors.nile_blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Your message',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Please enter your $selectedType'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      if (_attachedImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_attachedImage!.path),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      TextButton.icon(
                        onPressed: () {
                          ChooseFile.showImagePickerBottomSheet(context, (
                            selectedFile,
                          ) {
                            setState(() {
                              _attachedImage = selectedFile;
                            });
                          });
                        },
                        icon: const Icon(Icons.attach_file),
                        label: Text(
                          _attachedImage == null
                              ? 'Attach Image'
                              : 'Change Image',
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (!_isLoading)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                String? encodedImage;
                                String? mediaType;
                                if (_attachedImage != null) {
                                  final bytes =
                                      await File(
                                        _attachedImage!.path,
                                      ).readAsBytes();
                                  mediaType = lookupMimeType(
                                    _attachedImage!.path,
                                  );
                                  final base64Str = base64Encode(bytes);

                                  encodedImage =
                                      'data:$mediaType;base64,$base64Str';
                                }

                                final Map<String, dynamic> queryData =
                                    {
                                          'query_type':
                                              selectedType.toLowerCase(),
                                          'query':
                                              _messageController.text.trim(),
                                          'photo': encodedImage,
                                          'app_name': 'mobile',
                                        }
                                        as Map<String, dynamic>;

                                final isSuccess = await _submitQuery(queryData);

                                if (isSuccess) {
                                  Navigator.pop(context);
                                  _loadQueryData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '$selectedType submitted successfully',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Somethings went wrong !'),
                                    ),
                                  );
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: Text('Submit ${selectedType}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustColors.nile_blue,
                            ),
                          ),
                        ),
                      if (_isLoading)
                        Center(
                          child: SizedBox.square(
                            dimension: 25.0,
                            child: CircularProgressIndicator(
                              color: CustColors.nile_blue,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> _submitQuery(Map<String, dynamic> data) async {
    final userToken = Pref.instance.getString(Consts.user_token);
    print('Received Data: $data');
    try {
      final url = Uri.https(Urls.base_url, Urls.query_center);
      final response = await post(
        url,
        headers: {
          'Authorization': 'Bearer $userToken',
          'content-type': 'Application/json',
        },
        body: json.encode(data),
      );

      print('Response Code: ${response.statusCode}, Body:${response.body} ');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        handleHttpResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: $exception,Trace:$trace');
    }
    return false;
  }

  Future<Map<String, dynamic>?> _getQueryList() async {
    final userToken = Pref.instance.getString(Consts.user_token);
    try {
      final url = Uri.https(Urls.base_url, Urls.query_center_list);
      final response = await get(
        url,
        headers: {'Authorization': 'Bearer $userToken'},
      );

      print('Response Code: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final status = body['isScuss'];
        if (status) {
          return body;
        }
      } else {
        handleHttpResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: $exception,Trace: ${trace}');
    }
    return null;
  }

  void _showResponseBottomSheet(
    BuildContext context,
    Function(String response, String status) onSubmit,
  ) {
    final TextEditingController responseController = TextEditingController();
    String queryStatus = 'closed';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Update Response',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
            
                // Response TextField
                TextField(
                  controller: responseController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: false,
                    labelText: 'Your Response',
                    hintText: 'Enter your response...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
            
                // Query Status Dropdown
                DropdownButtonFormField<String>(
                  value: queryStatus,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: false,
                    labelText: 'Query Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items:
                      ['open', 'closed']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.toUpperCase()),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      queryStatus = value;
                    }
                  },
                ),
                const SizedBox(height: 20),
            
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close,color: Colors.black,),
                        label: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final responseText = responseController.text.trim();
                          if (responseText.isNotEmpty) {
                            Navigator.of(context).pop();
                            onSubmit(responseText, queryStatus);
                          }
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustColors.nile_blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class QueryDetailsScreen extends StatefulWidget {
//   final String id;
//
//   const QueryDetailsScreen({super.key, required this.id});
//
//   @override
//   State<QueryDetailsScreen> createState() => _QueryDetailsScreenState();
// }

// class _QueryDetailsScreenState extends State<QueryDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Query Details')),
//       body: FutureBuilder<Map<String, dynamic>?>(
//         future: _getQueryDetails(widget.id),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: SizedBox.square(
//                 dimension: 28,
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//
//           if (snapshot.hasData && snapshot.data != null) {
//             final data = snapshot.data!['data'];
//             return SingleChildScrollView(
//               child: _buildQueryDetails(data),
//             );
//           }
//
//           return const Center(child: Text('Something went wrong!'));
//         },
//       ),
//     );
//   }
//
//   Widget _buildQueryDetails(Map<String, dynamic> data) {
//     final String? imageUrl = data['photo'];
//     final String? query = data['query'];
//     final String? response = data['response'];
//     final String? addDate = data['add_date'];
//     final String? updateDate = data['update_date'];
//     final String status = (data['query_status'] ?? 'closed').toString();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Image
//         CustomNetworkImage(
//           imageUrl: imageUrl,
//           height: 280,
//           width: double.infinity,
//           fit: BoxFit.cover,
//         ),
//         const SizedBox(height: 24),
//
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Message + Status Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Message', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,)),
//                         const SizedBox(height: 6),
//                         Text(query ?? '-', style: Theme.of(context).textTheme.bodyMedium!.copyWith(  fontSize: 14,
//                           color: Colors.black87,)),
//                       ],
//                     ),
//                   ),
//                   Chip(
//                     label: Text(
//                       status.toLowerCase() == 'opened' ? 'Open' : 'Closed',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     backgroundColor: status.toLowerCase() == 'opened'
//                         ? Colors.green
//                         : Colors.grey,
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // Added Date
//               Row(
//                 children: [
//                   const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                   const SizedBox(width: 8),
//                   Text('Added On: ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,)),
//                   Expanded(child: Text(_formatDate(addDate), style: Theme.of(context).textTheme.bodyMedium!.copyWith(  fontSize: 14,
//                     color: Colors.black87,))),
//                 ],
//               ),
//               const SizedBox(height: 12),
//
//               // Updated Date
//               Row(
//                 children: [
//                   const Icon(Icons.update, size: 16, color: Colors.grey),
//                   const SizedBox(width: 8),
//                   Text('Last Updated: ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,)),
//                   Expanded(child: Text(_formatDate(updateDate), style: Theme.of(context).textTheme.bodyMedium!.copyWith(  fontSize: 14,
//                     color: Colors.black87,))),
//                 ],
//               ),
//               const SizedBox(height: 24),
//
//               // Response Section
//               if (response != null && response.trim().isNotEmpty) ...[
//                 Text('Response', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,)),
//                 const SizedBox(height: 6),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.blue.shade100),
//                   ),
//                   child: Text(response, style: Theme.of(context).textTheme.bodyMedium!.copyWith(  fontSize: 14,
//     color: Colors.black87,)),
//                 ),
//                 const SizedBox(height: 12),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//   String _formatDate(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) return '-';
//     try {
//       final parsed = DateTime.parse(dateStr);
//       return DateFormat('dd MMM yyyy • hh:mm a').format(parsed);
//     } catch (_) {
//       return dateStr;
//     }
//   }
//
//   Future<Map<String, dynamic>?> _getQueryDetails(String id) async {
//     final token = Pref.instance.getString(Consts.user_token);
//     try {
//       final url = Uri.https(Urls.base_url, '/api/query-center/$id/view/');
//       final response = await get(url, headers: {
//         'Authorization': 'Bearer $token',
//       });
//
//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);
//         if (body['isScuss'] == true) {
//           return body;
//         }
//       } else {
//         handleHttpResponse(context, response);
//       }
//     } catch (e, trace) {
//       print('Exception: $e\nTrace: $trace');
//     }
//     return null;
//   }
//
// }

// class QueryDetailsScreen extends StatefulWidget {
//   final String id;
//
//   const QueryDetailsScreen({super.key, required this.id});
//
//   @override
//   State<QueryDetailsScreen> createState() => _QueryDetailsScreenState();
// }
//
// class _QueryDetailsScreenState extends State<QueryDetailsScreen> {
//   String formatDate(String input) {
//     try {
//       return DateFormat('dd MMM yyyy • hh:mm a').format(DateTime.parse(input));
//     } catch (_) {
//       return input;
//     }
//   }
//
//   Widget buildInfoTile(String title, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$title: ',
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//           Expanded(
//             child: Text(value ?? '-', style: const TextStyle(color: Colors.black87)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _launchCall(String number) async {
//     final Uri uri = Uri(scheme: 'tel', path: number);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }
//
//   void _launchEmail(String email) async {
//     final Uri uri = Uri(scheme: 'mailto', path: email);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Query Details'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>?>(
//         future: _getQueryDetails(widget.id),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: SizedBox.square(
//                 dimension: 25,
//                 child: CircularProgressIndicator(color: CustColors.nile_blue),
//               ),
//             );
//           }
//
//           if (snapshot.hasData && snapshot.data != null) {
//             final data = snapshot.data!['data'];
//             final customer = data['customer'] ?? {};
//             final addedBy = data['add_by'] ?? {};
//
//             final name = customer['name'] ?? 'Unknown';
//             final email = customer['email'];
//             final phone = customer['number'];
//             final imageUrl = customer['photo'];
//
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: CircleAvatar(
//                       radius: 40,
//                       backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
//                       backgroundColor: Colors.grey.shade300,
//                       child: imageUrl == null ? const Icon(Icons.person, size: 40) : null,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Center(
//                     child: Text(
//                       name,
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   if (phone != null || email != null)
//                     Center(
//                       child: Wrap(
//                         spacing: 12,
//                         children: [
//                           if (phone != null)
//                             ElevatedButton.icon(
//                               onPressed: () => _launchCall(phone),
//                               icon: const Icon(Icons.phone),
//                               label: const Text("Call"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green.shade600,
//                               ),
//                             ),
//                           if (email != null)
//                             ElevatedButton.icon(
//                               onPressed: () => _launchEmail(email),
//                               icon: const Icon(Icons.email),
//                               label: const Text("Email"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue.shade700,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   const Divider(height: 32),
//
//                   buildInfoTile('Query Type', data['query_type']?.toString().toUpperCase()),
//                   buildInfoTile('Status', data['query_status']?.toString().toUpperCase()),
//                   buildInfoTile('Date', formatDate(data['add_date'] ?? '')),
//                   buildInfoTile('Query', data['query']),
//                   buildInfoTile('Response', data['response'] ?? 'Pending'),
//
//                   if (data['photo'] != null) ...[
//                     const SizedBox(height: 16),
//                     const Text('Attached Image:', style: TextStyle(fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 8),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         data['photo'],
//                         height: 180,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) =>
//                             Container(color: Colors.grey.shade300, height: 180),
//                       ),
//                     ),
//                   ],
//
//                   const SizedBox(height: 24),
//                   const Text('Added By:', style: TextStyle(fontWeight: FontWeight.bold)),
//                   buildInfoTile('Name', addedBy['name']),
//                   buildInfoTile('Group', addedBy['group_name']),
//                   buildInfoTile('Email', addedBy['email']),
//                 ],
//               ),
//             );
//           }
//
//           return const Center(child: Text('Something went wrong!'));
//         },
//       ),
//     );
//   }
//
//   Future<Map<String, dynamic>?> _getQueryDetails(String id) async {
//     final userToken = Pref.instance.getString(Consts.user_token);
//     try {
//       final url = Uri.https(Urls.base_url, '/api/query-center/$id//view/');
//       final response = await get(url, headers: {
//         'Authorization': 'Bearer $userToken',
//       });
//
//       print('Response code: ${response.statusCode}, Body: ${response.body}');
//       if (response.statusCode == 200) {
//         final body = json.decode(response.body) as Map<String, dynamic>;
//         final status = body['isScuss'];
//         if (status) return body;
//       } else {
//         handleHttpResponse(context, response);
//       }
//     } catch (e, trace) {
//       print('Exception: $e, Trace: $trace');
//     }
//     return null;
//   }
// }
