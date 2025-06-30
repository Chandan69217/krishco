import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/models/invoice_claim/claim_reporting_list_data.dart';
import 'package:krishco/screens/claim_invoice/claim_actions/approval_permissions.dart';
import 'package:krishco/screens/claim_invoice/claim_actions/claim_actions.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/file_viewer/image_viewer.dart';

class ClaimReportingDetailsScreen extends StatefulWidget {
  final String claimReporId;
  final VoidCallback? onActionResponse;

  const ClaimReportingDetailsScreen({Key? key, required this.claimReporId,this.onActionResponse}) : super(key: key);

  @override
  State<ClaimReportingDetailsScreen> createState() => _ClaimReportingDetailsScreenState();
}

class _ClaimReportingDetailsScreenState extends State<ClaimReportingDetailsScreen> {
  String formatDate(DateTime? date) {
    return date != null ? DateFormat('dd-MMM-yyyy').format(date) : '-';
  }

  String formatDate1(DateTime? date) {
    return date != null ? DateFormat('hh:mm a dd-MMM-yyyy').format(date) : '-';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Claim Reporting Details")),
      body: FutureBuilder<Map<String,dynamic>?>(
          future: APIService.getInstance(context).invoiceClaim.getClaimReportingDetailsByID(widget.claimReporId),
          builder:(context,snapshot){
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
              final claimData = ClaimReportingData.fromJson(data);
              final claim = ClaimReportingData.fromJson(data).claim;
              final claimedBy = claim?.claimedBy;
              final claimedFromOthers = claim?.claimedFromOthers;
              final claimedFrom = claim?.claimedFrom;
              final isUnregistered = claim?.isRegistered == false;
              return ListView(
                children: [
                  _buildCard(title: 'Reporting Message', children: [
                    _infoRow(null,claimData.message),
                  ]),
                  const SizedBox(height: 12),
                  _buildCard(
                    title: "Claim Info",
                    children: [
                      _infoRow("Claim No", claim?.claimNumber),
                      _infoRow("Reported Date", formatDate1(claimData.addDate)),
                      _infoRow("Invoice ID", claim?.invoiceId),
                      _infoRow("Invoice Date", formatDate(claim?.invoiceDate)),
                      _infoRow("Claimed Date", formatDate1(claim?.claimedDate)),
                      _infoRow("Status", claim?.claimStatus, highlight: true),
                      _infoRow("Status Remark", claim?.claimPosition),
                      _infoRow("App", claim?.appName),
                      _infoRow("Claim Amount", "₹${claim?.claimAmount ?? 0}"),
                      _infoRow("Final Amount", "₹${claim?.finalClaimAmount ?? 0}"),
                      _infoRow("Points", "${claim?.claimPoints ?? 0}"),
                      _infoRow("Remarks", claim?.claimRemarks, isWarning: true),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (claimedBy != null)
                    _buildCard(
                      title: "Claimed By",
                      children: [
                        _infoRow("Name", claimedBy.custName),
                        _infoRow("Contact", claimedBy.contNo),
                        _infoRow("email", claimedBy.email??'-'),
                        _infoRow("Group", claimedBy.group_type),
                        _infoRow("Group Name", claimedBy.group_name),
                        _infoRow("Status", claimedBy.status == true ? "Active" : "Inactive"),
                      ],
                    ),
                  const SizedBox(height: 12),
                  if (claimedFrom != null)
                    _buildCard(
                      title: "Claimed From (Registered)",
                      children: [
                        _infoRow("Name", claimedFrom.custName),
                        _infoRow("Contact", claimedFrom.contNo),
                        _infoRow("email", claimedFrom.email??'-'),
                        _infoRow("Group", claimedFrom.group_type),
                        _infoRow("Group Name", claimedFrom.group_name),
                        _infoRow("Status", claimedFrom.status == true ? "Active" : "Inactive"),
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

                  // const SizedBox(height: 12),
                  //
                  // _buildCard(
                  //   title: "Meta Info",
                  //   children: [
                  //     _infoRow("Created Date", formatDate(claim.createdDate)),
                  //     _infoRow("Last Edited", formatDate(claim.editDate)),
                  //   ],
                  // ),

                  if ((claim?.claimCopy ?? '').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildCard(
                      title: "Claim Copy",
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ImageViewerScreen(imageUrl: claim.claimCopy!),
                            ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: claim!.claimCopy!,
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
                        ClaimActions(
                          claimId: claim.id??0,
                          permissionToCancel:false,
                          permissionToReject: true,
                          approvalPermissions: ApprovalPermissions(
                            dashboardType: Pref.instance.getString(Consts.group_type)??'',
                            confirmed: Confirm(claimAmount: claim.claimAmount??0,allowToConfirm: true),
                            onHold: true,
                            approval: true,
                          ),
                          onSuccess: (){
                            setState(() {
                              widget.onActionResponse?.call();
                            });
                          },
                        ),
                      ])
                  ],
                ],
              );
            }else{
              return Center(
                child: Text('Something went wrong !!'),
              );
            }
          }
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

  Widget _infoRow(String? label, String? value, {bool highlight = false, bool isWarning = false}) {
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
          if(label != null)
            SizedBox(width: 130, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value?.isNotEmpty == true ? value! : '-', style: textStyle)),
        ],
      ),
    );
  }

}