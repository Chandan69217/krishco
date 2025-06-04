import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/screens/channel_partner_create_claim_screen.dart';
import 'package:krishco/models/invoice_claim/claim_list_data.dart';
import 'package:krishco/models/invoice_claim/claim_reporting_list_data.dart';
import 'package:krishco/widgets/cust_loader.dart';
import 'package:krishco/widgets/cust_snack_bar.dart';




class ChannelPartnerClaimScreen extends StatefulWidget {
  @override
  _ChannelPartnerClaimScreenState createState() => _ChannelPartnerClaimScreenState();
}

class _ChannelPartnerClaimScreenState extends State<ChannelPartnerClaimScreen> {
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
    final invoiceClaimObj = APIService(context: context).invoiceClaim;
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

  Future<void> _onRefresh()async{
    final invoiceClaimObj = APIService(context: context).invoiceClaim;
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
              child: CustomRefreshIndicator(
                onRefresh: _onRefresh,
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
                                  return _ClaimCard(claim:  claim[index]);
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
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>_ClaimReportingDetailsScreen(claimData: ValueNotifier<ClaimReportingData>(claimRepo[index]),onActionResponse: (){
                                      _fetchClaimData();
                                    },)));
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
      floatingActionButton: _fabButton(),
    );
  }



  Widget _fabButton() {
    return FloatingActionButton.extended(
      foregroundColor: Colors.white,
      heroTag: 'claim_fab_button',
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChannelPartnerCreateClaimScreen(
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
  const _ClaimCard({super.key, required this.claim});

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
        subtitle: Text("Status: ${claim.claimStatus}"),
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
                    Text("From: ${claim.claimedFrom ?? 'N/A'}",
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
                                  builder: (_) => _ClaimCopyViewerScreen(
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
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => _ClaimDetailsScreen(claim: claim),
                              ),
                            );
                          },
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



class _ClaimDetailsScreen extends StatelessWidget {
  final ClaimData claim;

  const _ClaimDetailsScreen({super.key, required this.claim});

  @override
  Widget build(BuildContext context) {
    final claimedBy = claim.claimedBy;
    final claimedFrom = claim.claimedFromOthers;
    final isUnregistered = claim.isRegistered == false;

    return Scaffold(
      appBar: AppBar(title: const Text("Claim Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              title: "Claim Info",
              children: [
                _infoRow("Claim No", claim.claimNumber),
                _infoRow("Claimed Date", claim.claimedDate?.toString()),
                _infoRow("Status", claim.claimStatus, highlight: true),
                _infoRow("Position", claim.claimPosition),
                _infoRow("App", claim.appName),
                _infoRow("Claim Amount", "₹${claim.claimAmount}"),
                _infoRow("Final Amount", "₹${claim.finalClaimAmount}"),
                _infoRow("Points", claim.claimPoints?.toString()),
                if ((claim.claimRemarks ?? '').isNotEmpty)
                  _infoRow("Remarks", claim.claimRemarks, isWarning: true),
              ],
            ),

            const SizedBox(height: 12),

            if (claimedBy != null)
              _buildCard(
                title: "Claimed By",
                children: [
                  _infoRow("Name", claimedBy.custName),
                  _infoRow("Contact", claimedBy.contNo),
                  _infoRow("Group Category", claimedBy.groupCat),
                  _infoRow("Category", claimedBy.custCategory),
                  _infoRow("Status", claimedBy.status == true ? "Active" : "Inactive"),
                ],
              ),

            if (isUnregistered && claimedFrom != null) ...[
              const SizedBox(height: 12),
              _buildCard(
                title: "Claimed From (Unregistered)",
                children: [
                  _infoRow("Name", claimedFrom.name),
                  _infoRow("Number", claimedFrom.number.toString()),
                  _infoRow("Address", claimedFrom.address),
                ],
              ),
            ],

            if ((claim.claimCopy ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildCard(
                title: "Claim Copy",
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>_ClaimCopyViewerScreen(imageUrl: claim.claimCopy!)));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: claim.claimCopy!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/logo/Placeholder_image.webp'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String key, String? value, {bool highlight = false, bool isWarning = false}) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
      color: isWarning ? Colors.red : Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text("$key:", style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value ?? "-", style: textStyle)),
        ],
      ),
    );
  }
}

class _ClaimCopyViewerScreen extends StatelessWidget {
  final String imageUrl;

  const _ClaimCopyViewerScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Claim Copy"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 5.0,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error, color: Colors.red)),
              imageBuilder: (context, imageProvider) => SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
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
                      "By: ${claimedBy?.custName ?? 'N/A'} (${claimedBy?.groupCat ?? ''})",
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
                      "From: ${claimedFrom?.custName ?? 'N/A'} (${claimedFrom?.groupCat ?? ''})",
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

class _ClaimReportingDetailsScreen extends StatelessWidget {
  final ValueNotifier<ClaimReportingData> claimData;
  final VoidCallback? onActionResponse;

  const _ClaimReportingDetailsScreen({Key? key, required this.claimData,this.onActionResponse}) : super(key: key);

  String formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : '-';
  }

  @override
  Widget build(BuildContext context) {
    final claim = claimData.value.claim;
    if (claim == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Claim Details")),
        body: const Center(child: Text("Claim data not available")),
      );
    }

    final claimedBy = claim.claimedBy;
    final claimedFrom = claim.claimedFromOthers;
    final isUnregistered = claim.isRegistered == false;

    return Scaffold(
      appBar: AppBar(title: const Text("Claim Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder(
          valueListenable: claimData,
          builder:(context,value,child){
            return Column(
              children: [
                _buildCard(
                  title: "Claim Info",
                  children: [
                    _infoRow("Claim No", claim.claimNumber),
                    _infoRow("Reported Date", formatDate(claimData.value.addDate)),
                    _infoRow("Claimed Date", formatDate(claim.claimedDate)),
                    _infoRow("Status", claim.claimStatus, highlight: true),
                    _infoRow("Position", claim.claimPosition),
                    _infoRow("App", claim.appName),
                    _infoRow("Claim Amount", "₹${claim.claimAmount ?? 0}"),
                    _infoRow("Final Amount", "₹${claim.finalClaimAmount ?? 0}"),
                    _infoRow("Points", "${claim.claimPoints ?? 0}"),
                    _infoRow("Remarks", claim.claimRemarks, isWarning: true),
                  ],
                ),

                const SizedBox(height: 12),

                _buildCard(
                  title: "Invoice Details",
                  children: [
                    _infoRow("Invoice ID", claim.invoiceId),
                    _infoRow("Invoice Date", formatDate(claim.invoiceDate)),
                  ],
                ),

                const SizedBox(height: 12),

                if (claimedBy != null)
                  _buildCard(
                    title: "Claimed By",
                    children: [
                      _infoRow("Name", claimedBy.custName),
                      _infoRow("Contact", claimedBy.contNo),
                      _infoRow("Group", claimedBy.groupCat),
                      _infoRow("Category", claimedBy.custCategory),
                      _infoRow("Status", claimedBy.status == true ? "Active" : "Inactive"),
                    ],
                  ),

                if (isUnregistered && claimedFrom != null) ...[
                  const SizedBox(height: 12),
                  _buildCard(
                    title: "Claimed From (Unregistered)",
                    children: [
                      _infoRow("Name", claimedFrom.name),
                      _infoRow("Number", claimedFrom.number.toString()),
                      _infoRow("Address", claimedFrom.address),
                    ],
                  ),
                ],

                const SizedBox(height: 12),

                _buildCard(
                  title: "Meta Info",
                  children: [
                    _infoRow("Created Date", formatDate(claim.createdDate)),
                    _infoRow("Last Edited", formatDate(claim.editDate)),
                  ],
                ),

                if ((claim.claimCopy ?? '').isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildCard(
                    title: "Claim Copy",
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => _ClaimCopyViewerScreen(imageUrl: claim.claimCopy!),
                          ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: claim.claimCopy!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/logo/Placeholder_image.webp'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  if(claim.claimStatus!.toLowerCase() == 'pending')
                    _buildCard(title: 'Action Required', children: [
                      _ClaimReportingActions(
                        claimId: claim.id??0,
                        claimAmount: claim.claimAmount??0,
                        onSuccess: onActionResponse,
                      ),
                    ])
                ],
              ],
            );
          }
        ),
      ),
    );

  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value, {bool highlight = false, bool isWarning = false}) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
      color: isWarning ? Colors.red : Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value?.isNotEmpty == true ? value! : '-', style: textStyle)),
        ],
      ),
    );
  }

}


class _ClaimReportingActions extends StatefulWidget {
  final int claimAmount;
  final int claimId;
  final VoidCallback? onSuccess;
  _ClaimReportingActions({required this.claimAmount,this.onSuccess,required this.claimId});
  @override
  _ClaimReportingActionsState createState() => _ClaimReportingActionsState();
}

class _ClaimReportingActionsState extends State<_ClaimReportingActions> {
  final TextEditingController _claimAmountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedAction;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _claimAmountController.text = widget.claimAmount.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading?Center(child: CustLoader()):Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            key: Key('Claim_Amount_Text'),
            validator: (v){
             if(v!=null){
               final amount = int.tryParse(v)??0;
               if(!(amount<= widget.claimAmount|| amount==0)){
                 return 'Enter Claim amount less ${widget.claimAmount}';
               }else if(amount==0){
                 return 'Enter Claim amount';
               }
             }
              return null;
            },
            onChanged: (x){
              _formKey.currentState!.validate();
            },
            controller: _claimAmountController,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Claim Amount',
              prefixIcon: Icon(Icons.currency_rupee_rounded,size: 20,)
            ),
          ),
          const SizedBox(height: 8.0,),
          TextFormField(
            key: Key('Remark_Text'),
            validator: (v){
              if(_selectedAction!.toLowerCase().contains('rejected')){
                if(v == null || v.isEmpty){
                  return 'Please enter remarks';
                }
              }
              return null;
            },
            controller: _remarkController,
            decoration: InputDecoration(
                labelText: 'Remarks'
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex:1,child: ElevatedButton(onPressed: _onRejected, child: Text('Reject'),
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                        Colors.red
                    )
                ),
              )),
              SizedBox(width: 8.0,),
              Expanded(flex:1,child: ElevatedButton(onPressed: _onApprove, child: Text('Approve'),
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                        Colors.green
                    )
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }

  void _onApprove()async {
    _selectedAction = 'Approved';
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final response = await APIService(context: context).invoiceClaim.claimRecall(claimID: widget.claimId, finalClaimAmount: int.tryParse(_claimAmountController.text)??0, status: 'confirmed');
    if(response != null){
      final status = response['isScuss'];
      showSimpleSnackBar(context: context, message: response['messages'],status: status);
      if(status){
        widget.onSuccess?.call();
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onRejected()async {
    _selectedAction = 'Rejected';
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final resopnse = await APIService(context: context).invoiceClaim.cancelClaim(claimID: widget.claimId, claimStatus: 'cancelled', remakrs: _remarkController.text);
    if(resopnse != null){
      final status = resopnse['isScuss'];
      showSimpleSnackBar(context:context,message: resopnse['messages'],status: status);
     if(status){
       widget.onSuccess?.call();
     }
    }
    setState(() {
      _isLoading = false;
    });
  }
  

}
