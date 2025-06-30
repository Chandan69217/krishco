import 'package:krishco/dashboard_type/dashboard_types.dart';

class ApprovalPermissions {
  final bool onHold;
  final bool approval;
  final Confirm? confirmed;
  final String dashboardType;
  late final List<String> approvalStatus;

  ApprovalPermissions({
    this.onHold = true,
    this.approval = true,
    this.confirmed,
    required this.dashboardType
  }) {
    approvalStatus = [];
    // 'Conform','Approve','On Hold'
    if (confirmed != null && confirmed!.allowToConfirm!) approvalStatus.add('Conform');
    if (approval && dashboardType.contains(DashboardTypes.User)) approvalStatus.add('Approve');
    if (onHold) approvalStatus.add('On Hold');
  }
}

class Confirm{
  final int claimAmount;
  final bool? allowToConfirm;
  Confirm({required this.claimAmount,this.allowToConfirm = true});
}