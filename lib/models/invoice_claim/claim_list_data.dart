import 'package:intl/intl.dart';

class ClaimListData {
  ClaimListData({
    required this.data,
  });

  final List<ClaimData> data;

  factory ClaimListData.fromJson(Map<String, dynamic> json){
    return ClaimListData(
      data: json["data"] == null ? [] : List<ClaimData>.from(json["data"]!.map((x) => ClaimData.fromJson(x))),
    );
  }

}

class ClaimData {
  static final dateFormatted = DateFormat('hh:mm a dd MMM yyyy');
  ClaimData({
    required this.id,
    required this.claimNumber,
    required this.invoiceId,
    required this.invoiceDate,
    required this.claimedDate,
    required this.claimedBy,
    required this.claimedFrom,
    required this.claimedFromOthers,
    required this.isTagged,
    required this.isRegistered,
    required this.claimAmount,
    required this.finalClaimAmount,
    required this.claimRemarks,
    required this.claimCopy,
    required this.claimPoints,
    required this.claimStatus,
    required this.claimPosition,
    required this.appName,
    required this.createdDate,
    required this.editDate,
  });

  final int? id;
  final String? claimNumber;
  final dynamic invoiceId;
  final String? invoiceDate;
  final String? claimedDate;
  final ClaimedBy? claimedBy;
  final dynamic claimedFrom;
  final ClaimedFromOthers? claimedFromOthers;
  final bool? isTagged;
  final bool? isRegistered;
  final int? claimAmount;
  final int? finalClaimAmount;
  final dynamic claimRemarks;
  final String? claimCopy;
  final int? claimPoints;
  final String? claimStatus;
  final String? claimPosition;
  final String? appName;
  final String? createdDate;
  final String? editDate;

  factory ClaimData.fromJson(Map<String, dynamic> json){
    return ClaimData(
      id: json["id"],
      claimNumber: json["claim_number"],
      invoiceId: json["invoice_id"]??null,
      invoiceDate: json["invoice_date"] != null ? dateFormatted.format(DateTime.tryParse(json["invoice_date"] ?? "")!):'-',
      claimedDate:json["claimed_date"] != null ? dateFormatted.format(DateTime.tryParse(json["claimed_date"] ?? "")!):'-',
      claimedBy: json["claimed_by"] == null ? null : ClaimedBy.fromJson(json["claimed_by"]),
      claimedFrom: json["claimed_from"],
      claimedFromOthers: json["claimed_from_others"] == null ? null : ClaimedFromOthers.fromJson(json["claimed_from_others"]),
      isTagged: json["is_tagged"],
      isRegistered: json["is_registered"],
      claimAmount: json["claim_amount"],
      finalClaimAmount: json["final_claim_amount"],
      claimRemarks: json["claim_remarks"],
      claimCopy: json["claim_copy"],
      claimPoints: json["claim_points"],
      claimStatus: json["claim_status"],
      claimPosition: json["claim_position"],
      appName: json["app_name"],
      createdDate: json["created_date"]!= null?dateFormatted.format(DateTime.tryParse(json["created_date"] ?? "")!):'-',
      editDate: json["edit_date"] != null ? dateFormatted.format(DateTime.tryParse(json["edit_date"] ?? "")!):'-',
    );
  }

}

class ClaimedBy {
  ClaimedBy({
    required this.id,
    required this.custName,
    required this.contNo,
    required this.groupCat,
    required this.custCategory,
    required this.photo,
    required this.status,
    required this.deleteRec,
  });

  final int? id;
  final String? custName;
  final String? contNo;
  final String? groupCat;
  final String? custCategory;
  final dynamic photo;
  final bool? status;
  final bool? deleteRec;

  factory ClaimedBy.fromJson(Map<String, dynamic> json){
    return ClaimedBy(
      id: json["id"],
      custName: json["cust_name"],
      contNo: json["cont_no"],
      groupCat: json["group_cat"],
      custCategory: json["cust_category"],
      photo: json["photo"],
      status: json["status"],
      deleteRec: json["delete_rec"],
    );
  }

}

class ClaimedFromOthers {
  ClaimedFromOthers({
    required this.name,
    required this.number,
    required this.address,
  });

  final String? name;
  final int? number;
  final String? address;

  factory ClaimedFromOthers.fromJson(Map<String, dynamic> json){
    return ClaimedFromOthers(
      name: json["name"],
      number: json["number"],
      address: json["address"],
    );
  }

}
