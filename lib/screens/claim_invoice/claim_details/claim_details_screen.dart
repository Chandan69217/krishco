import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/models/invoice_claim/claim_list_data.dart';
import 'package:krishco/screens/claim_invoice/claim_actions/approval_permissions.dart';
import 'package:krishco/screens/claim_invoice/claim_actions/claim_actions.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/file_viewer/image_viewer.dart';



class ClaimDetailsScreen extends StatefulWidget {
  final String claimId;
  final VoidCallback? onActionResponse;
  const ClaimDetailsScreen({super.key, required this.claimId,this.onActionResponse});

  @override
  State<ClaimDetailsScreen> createState() => _ClaimDetailsScreenState();
}

class _ClaimDetailsScreenState extends State<ClaimDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Claim Details")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<Map<String,dynamic>?>(
            future: APIService.getInstance(context).invoiceClaim.getClaimDetailsByID(widget.claimId),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: SizedBox.square(
                    dimension: 25.0,
                    child: CircularProgressIndicator(
                      color: CustColors.nile_blue,
                    ),
                  ),
                );
              }
              if(snapshot.hasData){
                final data = snapshot.data?['data'];
                final claim = ClaimData.fromJson(data!);
                final claimedBy = claim.claimedBy;
                final claimedFromOthers = claim.claimedFromOthers;
                final claimedForm = claim.claimedFrom;
                final isUnregistered = claim.isRegistered == false;
                return  ListView(
                  shrinkWrap: true,
                  children: [
                    _buildCard(
                      title: "Claim Info",
                      children: [
                        _infoRow("Claim No", claim.claimNumber),
                        _infoRow("Claimed Date", claim.claimedDate?.toString()),
                        _infoRow("Invoice ID", claim.invoiceId!= null && claim.invoiceId.toString().isNotEmpty?claim.invoiceId:'-',),
                        _infoRow("Invoice Date", claim.invoiceDate,),
                        _infoRow("Status", claim.claimStatus, highlight: true),
                        _infoRow("Message", claim.claimPosition),
                        _infoRow("App", claim.appName),
                        _infoRow("Claim Amount", "₹${claim.claimAmount}"),
                        _infoRow("Final Amount", "₹${claim.finalClaimAmount}"),
                        _infoRow("Points", claim.claimPoints?.toString()),
                        if ((claim.claimRemarks ?? '').isNotEmpty)
                          _infoRow("Remarks", claim.claimRemarks, isWarning: true),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (claimedForm != null)
                      _buildCard(
                        title: "Claimed From (Registered)",
                        children: [
                          _infoRow("Name", claimedForm.custName),
                          _infoRow("Contact", claimedForm.contNo),
                          _infoRow("email", claimedForm.email),
                          _infoRow("Group", claimedForm.group_type),
                          _infoRow("Group Name", claimedForm.group_name),
                          _infoRow("Status", claimedForm.status == true ? "Active" : "Inactive"),
                        ],
                      ),
                    const SizedBox(height: 12),

                    if (claimedBy != null)
                      _buildCard(
                        title: "Claimed By",
                        children: [
                          _infoRow("Name", claimedBy.custName),
                          _infoRow("Contact", claimedBy.contNo),
                          _infoRow("email", claimedBy.email),
                          _infoRow("Group", claimedBy.group_type),
                          _infoRow("Group Name", claimedBy.group_name),
                          _infoRow("Status", claimedBy.status == true ? "Active" : "Inactive"),
                        ],
                      ),

                    if (isUnregistered && claimedFromOthers != null) ...[
                      const SizedBox(height: 12),
                      _buildCard(
                        title: "Claimed From (Unregistered)",
                        children: [
                          _infoRow("Name", claimedFromOthers.name),
                          _infoRow("Number", claimedFromOthers.number.toString()),
                          _infoRow("Address", claimedFromOthers.address),
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ImageViewerScreen(imageUrl: claim.claimCopy!)));
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

                    const SizedBox(height: 12),
                    if(claim.claimStatus?.toLowerCase() == 'pending')
                      _buildCard(title: 'Action Required', children: [
                        ClaimActions(
                          claimId: claim.id??0,
                          permissionToCancel: true,
                          // permissionToReject: false,
                          // approvalPermissions: ApprovalPermissions(
                          //   confirmed: Confirm(claimAmount: claim.claimAmount??0,allowToConfirm: true),
                          // ),
                          onSuccess: (){
                            setState(() {
                              widget.onActionResponse?.call();
                            });
                          },
                        ),
                      ])
                  ],
                );
              }else{
                return Center(
                  child: Text('Something went wrong!!'),
                );
              }
            }),
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