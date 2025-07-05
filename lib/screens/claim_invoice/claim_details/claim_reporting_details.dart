import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/dashboard_type/dashboard_types.dart';
import 'package:krishco/models/invoice_claim/claim_reporting_list_data.dart';
import 'package:krishco/models/login_data/login_details_data.dart';
import 'package:krishco/screens/claim_invoice/claim_actions/approval_permissions.dart';
import 'package:krishco/screens/claim_invoice/claim_actions/claim_actions.dart';
import 'package:krishco/screens/splash/splash_screen.dart';
import 'package:krishco/utilities/constant.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/utilities/full_screen_loading.dart';
import 'package:krishco/widgets/cust_dialog_box/cust_dialog_box.dart';
import 'package:krishco/widgets/cust_loader.dart';
import 'package:krishco/widgets/custom_button.dart';
import 'package:krishco/widgets/file_viewer/image_viewer.dart';

class ClaimReportingDetailsScreen extends StatefulWidget {
  final String claimReporId;
  final VoidCallback? onActionResponse;

  const ClaimReportingDetailsScreen({
    Key? key,
    required this.claimReporId,
    this.onActionResponse,
  }) : super(key: key);

  @override
  State<ClaimReportingDetailsScreen> createState() =>
      _ClaimReportingDetailsScreenState();
}

class _ClaimReportingDetailsScreenState extends State<ClaimReportingDetailsScreen> {

  bool _isLoading = false;
  String? _claimID;
  late Future<Map<String,dynamic>?> _futureClaimReportingData;

  String formatDate(DateTime? date) {
    return date != null ? DateFormat('dd-MMM-yyyy').format(date) : '-';
  }

  String formatDate1(DateTime? date) {
    return date != null ? DateFormat('hh:mm a dd-MMM-yyyy').format(date) : '-';
  }


  @override
  void initState() {
    super.initState();
    _futureClaimReportingData =  APIService.getInstance(
      context,
    ).invoiceClaim.getClaimReportingDetailsByID(widget.claimReporId);
  }


  void _checkClaimStatus()async{
    setState(() {
      _isLoading = true;
    });
    final message = await APIService.getInstance(context).invoiceClaim.checkClaimStatus(_claimID!);
    if(message != null){
      CustDialog.show(context: context, message: message,title: 'Claim Status');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _tagClaimSource()async{
    final message = await APIService.getInstance(context).invoiceClaim.tagClaimSource(claimId: _claimID!);
    if(message != null){
      CustDialog.show(context: context, message: message,title: 'Source Tagging');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Claim Reporting Details"),
        actions: [
          PopupMenuButton<String>(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            // menuPadding: EdgeInsets.symmetric(horizontal: 20,),
            borderRadius: BorderRadius.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)
            ),
            onSelected: (value)async {
              if(value.contains('claim_status')&& _claimID != null){
                _checkClaimStatus();
              }else if(value.contains('register_source') && _claimID != null){
                _showRegisterBottomSheet(_claimID!);
              }else if(value.contains('tag_source') && _claimID != null){
                _tagClaimSource();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                if(GroupRoles.dashboardType == DashboardTypes.User)...[
                  const PopupMenuItem<String>(
                    value: 'register_source',
                    child: Row(
                      children: [
                        Icon(Icons.business, color: Colors.black54),
                        SizedBox(width: 16.0),
                        Text('Register Source'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'tag_source',
                    child: Row(
                      children: [
                        Icon(Icons.link, color: Colors.black54),
                        SizedBox(width: 16.0),
                        Text('Tag Source'),
                      ],
                    ),
                  ),
                ],
                const PopupMenuItem<String>(
                  value: 'claim_status',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.black54),
                      SizedBox(width: 16.0),
                      Text('Claim Status'),
                    ],
                  ),
                ),
              ];
            },
          )

        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<Map<String, dynamic>?>(
            future: _futureClaimReportingData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox.square(
                    dimension: 25.0,
                    child: CircularProgressIndicator(color: CustColors.nile_blue),
                  ),
                );
              }
              if (snapshot.hasData) {
                final data = snapshot.data?['data'];
                final claimData = ClaimReportingData.fromJson(data);
                final claim = ClaimReportingData.fromJson(data).claim;
                _claimID = claim?.id.toString();
                final claimedBy = claim?.claimedBy;
                final updatedBy = claim?.updateBY;
                final claimedFromOthers = claim?.claimedFromOthers;
                final claimedFrom = claim?.claimedFrom;
                final isUnregistered = claim?.isRegistered == false;
                return ListView(
                  padding: EdgeInsets.all(12.0),
                  children: [
                    _buildCard(
                      title: 'Reporting Message',
                      children: [_infoRow(null, claimData.message)],
                    ),
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
                        _infoRow(
                          "Final Amount",
                          "₹${claim?.finalClaimAmount ?? 0}",
                        ),
                        _infoRow("Points", "${claim?.claimPoints ?? 0}"),
                        _infoRow("Remarks", claim?.claimRemarks, isWarning: true),
                        Row(
                          children: [
                            SizedBox(
                              width: 130,
                              child: Text(
                                'Claim Copy',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            claim?.claimCopy != null ?
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ImageViewerScreen(imageUrl: claim?.claimCopy??''),
                                ));
                              },
                              label: Text('View Copy'),
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  overlayColor: Colors.transparent,
                                  foregroundColor: Colors.blue
                              ),
                              icon: Icon(Icons.remove_red_eye_rounded,color: Colors.blue,),
                            ):Text('N/A')
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (claimedBy != null)
                      _buildCard(
                        title: "Claimed By",
                        children: [
                          _infoRow("Name", claimedBy.custName),
                          _infoRow("Contact", claimedBy.contNo),
                          _infoRow("email", claimedBy.email ?? '-'),
                          _infoRow("Group", claimedBy.group_type),
                          _infoRow("Group Name", claimedBy.group_name),
                          _infoRow(
                            "Status",
                            claimedBy.status == true ? "Active" : "Inactive",
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    if (claimedFrom != null)
                      _buildCard(
                        title: "Claimed From (Registered)",
                        children: [
                          _infoRow("Name", claimedFrom.custName),
                          _infoRow("Contact", claimedFrom.contNo),
                          _infoRow("email", claimedFrom.email ?? '-'),
                          _infoRow("Group", claimedFrom.group_type),
                          _infoRow("Group Name", claimedFrom.group_name),
                          _infoRow(
                            "Status",
                            claimedFrom.status == true ? "Active" : "Inactive",
                          ),
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

                    if (updatedBy != null) ...[
                      const SizedBox(height: 12),
                      _buildCard(
                        title: 'Updated By',
                        children: [
                          _infoRow("Name", updatedBy.custName),
                          _infoRow("Contact", updatedBy.contNo),
                          _infoRow("email", updatedBy.email),
                          _infoRow("Group", updatedBy.group_type),
                          _infoRow("Group Name", updatedBy.group_name),
                          _infoRow(
                            "Status",
                            updatedBy.status == true ? "Active" : "Inactive",
                          ),
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

                    // if ((claim?.claimCopy ?? '').isNotEmpty) ...[
                    //   const SizedBox(height: 12),
                    //   _buildCard(
                    //     title: "Claim Copy",
                    //     children: [
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (_) => ImageViewerScreen(imageUrl: claim.claimCopy!),
                    //           ));
                    //         },
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(10),
                    //           child: CachedNetworkImage(
                    //             imageUrl: claim!.claimCopy!,
                    //             width: double.infinity,
                    //             height: 180,
                    //             fit: BoxFit.cover,
                    //             placeholder: (context, url) =>
                    //             const Center(child: CircularProgressIndicator()),
                    //             errorWidget: (context, url, error) =>
                    //                 Image.asset('assets/logo/Placeholder_image.webp'),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ],
                    const SizedBox(height: 12),
                    if (claim != null && ['pending',].contains( claim.claimStatus!.toLowerCase()))
                      _buildCard(
                        title: 'Action Required',
                        children: [
                          ClaimActions(
                            claimId: claim.id ?? 0,
                            permissionToCancel: false,
                            permissionToReject: true,
                            approvalPermissions: ApprovalPermissions(
                              dashboardType:
                                  Pref.instance.getString(Consts.group_type) ?? '',
                              confirmed: Confirm(
                                claimAmount: claim.claimAmount ?? 0,
                                allowToConfirm: true,
                              ),
                              onHold: true,
                              approval: true,
                            ),
                            onSuccess: () {
                              setState(() {
                                _futureClaimReportingData =  APIService.getInstance(
                                  context,
                                ).invoiceClaim.getClaimReportingDetailsByID(widget.claimReporId);
                                widget.onActionResponse?.call();
                              });
                            },
                          ),
                        ],
                      ),
                  ],
                );
              } else {
                return Center(child: Text('Something went wrong !!'));
              }
            },
          ),
          if(_isLoading)
            FullScreenLoading()
          ]
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(
    String? label,
    String? value, {
    bool highlight = false,
    bool isWarning = false,
  }) {
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
          if (label != null)
            SizedBox(
              width: 130,
              child: Text(
                "$label:",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : '-',
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }

  _showRegisterBottomSheet(String claimId){
    final Future<Map<String,dynamic>?> _futureGroupType = APIService.getInstance(context).groupDetails.getGroupCategory();
    String? selectedGroupType;
    String? selectedGroupName;
    bool btnLoading = false;
    final ValueNotifier<List<Map<String,dynamic>>?> groupName = ValueNotifier<List<Map<String,dynamic>>?>(null);
    final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

    showModalBottomSheet(
      useSafeArea: true,
        constraints: BoxConstraints(
          minHeight: 280,
          maxHeight: 280,
        ),
        context: context,
        builder:(context){
          return SafeArea(
            child: FutureBuilder(
                future: _futureGroupType,
                builder:(context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: CustLoader(color: CustColors.nile_blue,),
                      ),
                    );
                  }

                  if(snapshot.hasData){
                    final data = snapshot.data!;
                    final groups = data['data'] != null ? data['data'] as List<dynamic>:[];
                    final filteredGroups = groups.where((e) {
                      final name = e['name'] as String;
                      return !name.contains('Customer');
                    }).toList();
                    return StatefulBuilder(
                      builder: (context,setModelState) => Form(
                        key: formGlobalKey,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(12.0,18.0,12.0,30),
                          shrinkWrap: true,
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedGroupType,
                              isExpanded: true,
                              decoration: InputDecoration(
                                filled: false,
                                labelText: 'Group Type',
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Select Group Type'),
                                ),
                                ...filteredGroups.map<DropdownMenuItem<String>>(
                                      (e) => DropdownMenuItem<String>(
                                    value: e['id'].toString(),
                                    child: Text(e['name']),
                                  ),
                                ),
                              ],
                              validator: (value){
                                if(value == null && selectedGroupName != null){
                                  return 'Please select group type';
                                }
                                return null;
                              },
                              onChanged: (value)async {
                                setModelState((){
                                  selectedGroupType = value;
                                  selectedGroupName = null;
                                });
                                if(selectedGroupType != null){
                                  final data = await APIService.getInstance(context).groupDetails.getGroupByCategoryId(selectedGroupType!);
                                  if(data != null && data['data'] != null){
                                    final groupList = data['data'] as List<dynamic>;
                                    groupName.value = groupList.map<Map<String,dynamic>>((e){
                                      return e as Map<String,dynamic>;
                                    }).toList();
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 18.0,),
                            ValueListenableBuilder<List<Map<String,dynamic>>?>(
                              valueListenable: groupName,
                              builder: (context,value,child){
                                return DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      filled: false,
                                      labelText: 'Group Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: selectedGroupName,
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: null,
                                        child: Text('Select Group Name'),
                                      ),
                                      if(value != null)...value.map<DropdownMenuItem<String>>(
                                              (e)=> DropdownMenuItem<String>(
                                              value: e['id'].toString(),
                                              child: Text('${e['cust_grp_name']}-${e['group_cat']}')
                                          )
                                      )
                                    ],
                                    validator: (value){
                                      if(value == null && selectedGroupName != null){
                                        return 'Please select group name';
                                      }
                                      return null;
                                    },
                                    onChanged:(value)async{
                                     setModelState((){
                                       selectedGroupName = value;
                                     });
                                    }
                                );
                              },
                            ),
                            const SizedBox(height: 18.0,),
                            StatefulBuilder(
                              builder: (context,refreshBtn){
                                return btnLoading ? Center(child: CustLoader(color: CustColors.nile_blue,)): CustomElevatedButton(text: 'Register', onPressed: ()async{
                                  if(!(formGlobalKey.currentState != null && formGlobalKey.currentState!.validate())){
                                    return;
                                  }
                                  refreshBtn((){
                                    btnLoading = true;
                                  });
                                 final message =  await APIService.getInstance(context).invoiceClaim.registerSource(claimId: claimId, group_type_id: selectedGroupType!, group_name_id: selectedGroupName!);
                                 if(message != null){
                                   CustDialog.show(context: context, message: message,title: "Source Registration");
                                 }
                                  refreshBtn((){
                                    btnLoading = false;
                                  });
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  }else{
                    return Center(child: Text('Something went wrong !!'));
                  }
                }
            )
          );
        }
    );
  }

}
