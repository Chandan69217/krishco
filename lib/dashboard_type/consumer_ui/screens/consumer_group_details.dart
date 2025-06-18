import 'dart:convert';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/api_services/api_urls.dart';
import 'package:krishco/api_services/handle_https_response.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  String? selectedGroupCategory;
  String? selectedGroupName;
  Map<String, dynamic>? selectedData;

  final ValueNotifier<List<Map<String, dynamic>>> groupList =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  List<String> get uniqueGroupCategories =>
      groupList.value.map((e) => e['group_cat'] as String).toSet().toList();

  List<String> get filteredGroupNames {
    if (selectedGroupCategory == null) return [];
    return groupList.value
        .where((e) => e['group_cat'] == selectedGroupCategory)
        .map((e) => e['cust_grp_name'] as String)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      initGroupList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
    final textStyleValue = const TextStyle(fontSize: 15, color: Colors.black87);

    Widget buildRow(String title, String? value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 120, child: Text("$title:", style: textStyleTitle)),
            Expanded(
              child: Text(
                value?.isNotEmpty == true ? value! : '-',
                style: textStyleValue,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Other Consumers')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: groupList,
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedGroupCategory,
                  hint: const Text("Select Group Category"),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items:
                      uniqueGroupCategories
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGroupCategory = value;
                      selectedGroupName = null;
                      selectedData = null;
                    });
                  },
                ),
                const SizedBox(height: 12),

                if (selectedGroupCategory != null)
                  DropdownButtonFormField<String>(
                    value: selectedGroupName,
                    hint: const Text("Select Group Name"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items:
                        filteredGroupNames
                            .map(
                              (name) => DropdownMenuItem(
                                value: name,
                                child: Text(name),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroupName = value;
                        selectedData = groupList.value.firstWhere(
                          (e) =>
                              e['group_cat'] == selectedGroupCategory &&
                              e['cust_grp_name'] == selectedGroupName,
                        );
                      });
                    },
                  ),

                const SizedBox(height: 20),

                if (selectedData != null) ...[
                  FutureBuilder(
                    future: _getConsumerGroupDetail(
                      selectedData!['id'].toString(),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox.square(
                            dimension: 25.0,
                            child: CircularProgressIndicator(
                              color: CustColors.nile_blue,
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return _ViewDetailsScreen(data: data);
                      } else {
                        return Center(child: Text('Something went wrong !'));
                      }
                    },
                  ),
                ],

                if (selectedData == null) ...[
                  Center(child: Text('No details available.')),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void initGroupList() async {
    final response =
        await APIService.getInstance(context).consumersGroup.getConsumerGroup();
    if (response != null) {
      final groups = response['data'] as List<dynamic>;
      groupList.value = groups.map<Map<String, dynamic>>((e) => e).toList();
    }
  }

  Future<Map<String, dynamic>?> _getConsumerGroupDetail(String id) async {
    final userToken = Pref.instance.getString(Consts.user_token);
    try {
      final url = Uri.https(Urls.base_url, "${Urls.consumersGroup} $id/");
      final response = await get(
        url,
        headers: {'Authorization': 'Bearer ${userToken}'},
      );
      print('response code: ${response.statusCode}, Body: ${response.body}');
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final status = body['isScuss'];
        if (status) {
          final details = body['data'] as List<dynamic>;
          return details.first;
        }
      } else {
        handleHttpResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }
}





class _ViewDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ViewDetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
    final textStyleValue = const TextStyle(
      fontSize: 15,
      color: Colors.black87,
    );

    Widget buildRow(String title, String? value, {Widget? trailing}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Text("$title:", style: textStyleTitle),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      (value?.trim().isNotEmpty ?? false) ? value!.trim() : '-',
                      style: textStyleValue,
                    ),
                  ),
                  if (trailing != null) trailing,
                ],
              ),
            ),
          ],
        ),
      );
    }

    void _launchCaller(String number) async {
      final uri = Uri.parse("tel:$number");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('Could not launch phone dialer');
      }
    }

    void _launchEmail(String email) async {
      final uri = Uri(scheme: 'mailto', path: email);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('Could not open email client');
      }
    }

    void _showError(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                "No customer details available.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                Center(
          child: CustomNetworkImage(
            imageUrl: data['photo'],
            placeHolder: 'assets/logo/dummy_profile.webp',
            height: 120.0,
            width: 120.0,
            borderRadius: BorderRadius.circular(60.0),
          ),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: Text(
            data['cust_name'] ?? 'Unknown',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            data['m_id'] ?? '-',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if ((data['email']?.toString().isNotEmpty ?? false))
              ElevatedButton.icon(
                icon: const Icon(Icons.email, size: 18),
                label: const Text("Email"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => _launchEmail(data['email']),
              ),
            const SizedBox(width: 12),
            if ((data['cont_no']?.toString().isNotEmpty ?? false))
              ElevatedButton.icon(
                icon: const Icon(Icons.call, size: 18),
                label: const Text("Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => _launchCaller(data['cont_no']),
              ),
          ],
        ),
        const Divider(height: 32, thickness: 1),
        buildRow("Group Category", data['group_cat']),
        buildRow("Customer Category", data['cust_category']),
        buildRow("State", data['state']),
        buildRow("District", data['dist']),
        buildRow("City", data['city']),
        buildRow("PIN", data['pin']),
        buildRow("Address", data['address']),
      ],
    );
  }
}


