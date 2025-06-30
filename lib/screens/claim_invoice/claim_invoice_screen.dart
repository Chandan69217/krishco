import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/dashboard_type/dashboard_types.dart';
import 'package:krishco/models/define_roles/define_roles.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/screens/claim_invoice/create_claim_screen.dart';
import 'package:krishco/models/invoice_claim/claim_list_data.dart';
import 'package:krishco/models/invoice_claim/claim_reporting_list_data.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/cust_dialog_box/cust_dialog_box.dart';
import 'package:krishco/widgets/cust_loader.dart';
import 'package:krishco/widgets/cust_snack_bar.dart';
import 'package:krishco/widgets/file_viewer/image_viewer.dart';

import 'claim_actions/approval_permissions.dart';
import 'claim_actions/claim_actions.dart';
import 'claim_details/claim_details_screen.dart';
import 'claim_details/claim_reporting_details.dart';


class ClaimScreen extends StatefulWidget {
  ClaimScreen({Key? key}):super(key:key);
  @override
  ClaimScreenState createState() => ClaimScreenState();
}

class ClaimScreenState extends State<ClaimScreen> {
  int selectedTabIndex = 0;
  ClaimListData?  claimList;
  ClaimReportingListData? claimReportingList;
  Future<Map<String,dynamic>?>? _futureClaims;
  ValueNotifier<List<ClaimData>> _filteredClaimsList = ValueNotifier<List<ClaimData>>([]);
  ValueNotifier<List<ClaimReportingData>> _filteredReportingClaimList = ValueNotifier<List<ClaimReportingData>>([]);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterClaims);
    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchClaimData();
    });
  }

  void _fetchClaimData(){
    final invoiceClaimObj = APIService.getInstance(context).invoiceClaim;
    setState(() {
      _futureClaims = selectedTabIndex == 0
          ? invoiceClaimObj.getClaimList()
          : invoiceClaimObj.getClaimReportingList();
    });
  }

  void _updateFilteredClaims() {
    if(selectedTabIndex == 0){
      _filteredClaimsList.value = claimList?.data??[];
    }else{
      _filteredReportingClaimList.value = claimReportingList?.data??[];
    }
  }

  void _filterClaims() {
    final query = _searchController.text.toLowerCase();
    if(selectedTabIndex == 0){
      final filter = claimList?.data.where((claim){
        return claim.claimNumber?.toLowerCase().contains(query)??false;
      }).toList()??[];
      _filteredClaimsList.value = filter;
    }else{
      final filter = claimReportingList?.data.where((claim){
        return true;
      }).toList()??[];
      _filteredReportingClaimList.value = filter;
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
      _searchController.clear();
      _fetchClaimData();
    });
  }

  Future<void> onRefresh()async{
    final invoiceClaimObj = APIService.getInstance(context).invoiceClaim;
    if(selectedTabIndex == 0){
      final data = await invoiceClaimObj.getClaimList();
      if(data!=null){
        claimList = ClaimListData.fromJson(data);
      }
    }else{
      final data = await invoiceClaimObj.getClaimReportingList();
      if(data!=null){
        claimReportingList = ClaimReportingListData.fromJson(data);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_){
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
                              fontWeight: isSelected ? FontWeight.bold : null ,
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
                  Image.asset('assets/icons/features.webp',width: 20,height: 20, color: Colors.black54),
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
              child: CustomRefreshIndicator(
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
                child: FutureBuilder(
                  future: _futureClaims,
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CustLoader(),
                        );
                      }

                      if(snapshot.hasError){
                        return Center(
                          child: Text('Something went wrong !!'),
                        );
                      }

                      if(snapshot.data == null){
                        return Center(
                          child: Text('Empty'),
                        );
                      }

                      if(selectedTabIndex == 0){
                        claimList = ClaimListData.fromJson(snapshot.data!);
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          _updateFilteredClaims();
                        });
                        return ValueListenableBuilder<List<ClaimData>>(
                            valueListenable: _filteredClaimsList,
                            builder: (context,claim,_){
                              if(claim.isEmpty){
                                return  Center(
                                  child: Text("No claims found",
                                      style: TextStyle(color: Colors.grey)),
                                );
                              }
                              return ListView.builder(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 80),
                                itemCount: claim.length,
                                itemBuilder: (context, index) {
                                  return _ClaimCard(
                                      claim:  claim[index],
                                    onTap: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ClaimDetailsScreen(claimId: claim[index].id.toString(),onActionResponse: onRefresh,),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                        );
                      }else{
                        claimReportingList = ClaimReportingListData.fromJson(snapshot.data!);
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          _updateFilteredClaims();
                        });
                        return ValueListenableBuilder<List<ClaimReportingData>>(
                            valueListenable: _filteredReportingClaimList,
                            builder: (context,claimRepo,_){
                              if(claimRepo.isEmpty){
                                return  Center(
                                  child: Text("No Reporting claims found",
                                      style: TextStyle(color: Colors.grey)),
                                );
                              }
                              return ListView.builder(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 80),
                                itemCount: claimRepo.length,
                                itemBuilder: (context, index) {
                                  return _ClaimReportingCard(data: claimRepo[index],
                                    onTap: (){
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>_ClaimReportingDetailsScreen(claimReporId: claimRepo[index].id.toString(),onActionResponse: onRefresh)));
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ClaimReportingDetailsScreen(claimReporId: claimRepo[index].id.toString(),onActionResponse: onRefresh)));
                                    },
                                  );
                                },
                              );
                            }
                        );
                        return Container();
                      }
                    }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GroupRoles.dashboardType == DashboardTypes.User ? GroupRoles.roles.contains(DefineRoles.user.Who_can_claim_points_by_uploading_invoice)?_fabButton():null:_fabButton(),
    );
  }


  Widget _fabButton() {
    return FloatingActionButton.extended(
      foregroundColor: Colors.white,
      heroTag: 'claim_fab_button',
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateClaimScreen(
          onSuccess: (){
            _fetchClaimData();
          },
        )));
      },
      icon: Icon(Icons.add),
      label: Text("Create Claim"),
      backgroundColor: Colors.blue,
    );
  }

}



class _ClaimCard extends StatelessWidget {
  final ClaimData claim;
  final VoidCallback? onTap;
  const _ClaimCard({super.key, required this.claim,this.onTap});
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase().trim()) {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Claim No: ${claim.claimNumber}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(claim.invoiceId != null && claim.invoiceId.toString().isNotEmpty)...[
              const SizedBox(height: 2.0,),
              Text('Invoice ID: ${claim.invoiceId}'),
              const SizedBox(height: 2.0,),
            ],
            Text("Status: ${claim.claimStatus}"),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(claim.claimStatus).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            claim.claimStatus ?? 'N/A',
            style: TextStyle(fontSize: 12, color:_getStatusColor(claim.claimStatus)),
          ),
        ),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Claimed by
                Row(
                  children: [
                    const Icon(Icons.person, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "By: ${claim.claimedBy?.custName ?? 'N/A'} (${claim.claimNumber ?? 'N/A'})",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Claim Info Row with Image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Invoice Date: ${claim.invoiceDate}",
                        style: const TextStyle(fontSize: 12)),
                    Text("Claimed On: ${claim.claimedDate}",
                        style: const TextStyle(fontSize: 12)),
                    Text("From: ${claim.claimedFrom != null ? claim.claimedFrom!.custName: 'N/A'}",
                        style: const TextStyle(fontSize: 12)),
                    Text("Amount: ₹${claim.claimAmount}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),

                    // View Copy Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            if ((claim.claimCopy ?? '').isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ImageViewerScreen(
                                    imageUrl: claim.claimCopy!,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text("View Copy"),
                        ),
                        TextButton(
                          style: Theme.of(context).textButtonTheme.style!.copyWith(
                              foregroundColor: WidgetStatePropertyAll(Colors.blue.shade600)
                          ),
                          onPressed:onTap,
                          child: const Text("More Details"),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Position or Remark
                if ((claim.claimPosition ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Note: ${claim.claimPosition}",
                      style: TextStyle(fontSize: 12, color:Colors.red.shade600),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaimReportingCard extends StatelessWidget {
  final ClaimReportingData data;
  final VoidCallback? onTap;

  const _ClaimReportingCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final claim = data.claim;
    final claimedBy = claim?.claimedBy;
    final claimedFrom = claim?.claimedFrom;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row - Claim Number and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    claim?.claimNumber ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(claim?.claimStatus??'Unknown').withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      claim?.claimStatus ?? "Unknown",
                      style: TextStyle(fontSize: 12, color: _getStatusColor(claim?.claimStatus??'Unknown')),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Claimed By / From
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "By: ${claimedBy?.custName ?? 'N/A'} (${claimedBy?.group_type ?? ''})",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.store, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "From: ${claimedFrom?.custName ?? 'N/A'} (${claimedFrom?.group_type ?? ''})",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Claim Amount and Claimed Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Amount: ₹${claim?.claimAmount?.toString() ?? '0'}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Date: ${_formatDate(claim?.claimedDate)}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Message
              if (data.message != null && data.message!.isNotEmpty)
                Text(
                  data.message!,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase().trim()) {
      case "confirmed":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat('dd MMM yyyy').format(date);
  }

}





