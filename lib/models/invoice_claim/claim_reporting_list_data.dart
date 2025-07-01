class ClaimReportingListData {
  ClaimReportingListData({
    required this.data,
  });

  final List<ClaimReportingData> data;

  factory ClaimReportingListData.fromJson(Map<String, dynamic> json){
    return ClaimReportingListData(
      data: json["data"] == null ? [] : List<ClaimReportingData>.from(json["data"]!.map((x) => ClaimReportingData.fromJson(x))),
    );
  }

}

class ClaimReportingData {
  ClaimReportingData({
    required this.id,
    required this.claim,
    required this.message,
    required this.addDate,
  });

  final int? id;
  final Claim? claim;
  final String? message;
  final DateTime? addDate;

  factory ClaimReportingData.fromJson(Map<String, dynamic> json){
    return ClaimReportingData(
      id: json["id"],
      claim: json["claim"] == null ? null : Claim.fromJson(json["claim"]),
      message: json["message"],
      addDate: DateTime.tryParse(json["add_date"] ?? ""),
    );
  }

}

class Claim {
  Claim({
    required this.id,
    required this.claimNumber,
    required this.invoiceId,
    required this.invoiceDate,
    required this.claimedDate,
    required this.claimedBy,
    required this.updateBY,
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
  final String? invoiceId;
  final DateTime? invoiceDate;
  final DateTime? claimedDate;
  final Claimed? claimedBy;
  final Claimed? updateBY;
  final Claimed? claimedFrom;
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
  final DateTime? createdDate;
  final DateTime? editDate;

  factory Claim.fromJson(Map<String, dynamic> json){
    return Claim(
      id: json["id"],
      claimNumber: json["claim_number"],
      invoiceId: json["invoice_id"],
      invoiceDate: DateTime.tryParse(json["invoice_date"] ?? ""),
      claimedDate: DateTime.tryParse(json["claimed_date"] ?? ""),
      claimedBy: json["claimed_by"] == null ? null : Claimed.fromJson(json["claimed_by"]),
      updateBY: json["update_by"] == null ? null : Claimed.fromJson(json["update_by"]),
      claimedFrom: json["claimed_from"] == null ? null : Claimed.fromJson(json["claimed_from"]),
      claimedFromOthers: json["claimed_from_others"] == null ? null: ClaimedFromOthers.fromJson( json["claimed_from_others"]),
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
      createdDate: DateTime.tryParse(json["created_date"] ?? ""),
      editDate: DateTime.tryParse(json["edit_date"] ?? ""),
    );
  }

}

class Claimed {
  Claimed({
    required this.id,
    required this.custName,
    required this.contNo,
    this.email,
    required this.group_type,
    required this.group_name,
    required this.photo,
    required this.status,
    required this.deleteRec,
  });

  final int? id;
  final String? custName;
  final String? contNo;
  final String? email;
  final String? group_type;
  final String? group_name;
  final dynamic photo;
  final bool? status;
  final bool? deleteRec;

  factory Claimed.fromJson(Map<String, dynamic> json){
    return Claimed(
      id: json["id"],
      custName: json["name"],
      contNo: json["number"],
      email: json["email"],
      group_type: json["group_type"],
      group_name: json["group_name"],
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
