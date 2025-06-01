import 'package:flutter/cupertino.dart';

class LoginDetailsData {
  LoginDetailsData({
    required this.data,
  });

  final UserDetailsData? data;
  factory LoginDetailsData.fromJson(Map<String, dynamic> json){
    return LoginDetailsData(
      data: json["data"] == null ? null : UserDetailsData.fromJson(json["data"]),
    );
  }

}

class UserDetailsData {
  UserDetailsData({
    required this.fname,
    required this.lname,
    required this.contNo,
    required this.altContNo,
    required this.dob,
    required this.gender,
    required this.marStatus,
    required this.annDate,
    required this.email,
    required this.photo,
    required this.emergencyContactDetails,
    required this.address,
    required this.city,
    required this.state,
    required this.pin,
    required this.dist,
    required this.country,
    required this.tId,
    required this.gstNo,
    required this.gstCopy,
  });

  final String? fname;
  final String? lname;
  final String? contNo;
  final dynamic altContNo;
  final dynamic dob;
  final String? gender;
  final String? marStatus;
  final dynamic annDate;
  final String? email;
  final dynamic photo;
  final List<EmergencyContactDetail> emergencyContactDetails;
  final dynamic address;
  final String? city;
  final String? state;
  final dynamic pin;
  final String? dist;
  final String? country;
  final dynamic tId;
  final dynamic gstNo;
  final dynamic gstCopy;

  factory UserDetailsData.fromJson(Map<String, dynamic> json){
    return UserDetailsData(
      fname: json["fname"],
      lname: json["lname"],
      contNo: json["cont_no"],
      altContNo: json["alt_cont_no"],
      dob: json["dob"],
      gender: json["gender"],
      marStatus: json["mar_status"],
      annDate: json["ann_date"],
      email: json["email"],
      photo: json["photo"],
      emergencyContactDetails: json["emergency_contact_details"] == null ? [] : List<EmergencyContactDetail>.from(json["emergency_contact_details"]!.map((x) => EmergencyContactDetail.fromJson(x))),
      address: json["address"],
      city: json["city"],
      state: json["state"],
      pin: json["pin"],
      dist: json["dist"],
      country: json["country"],
      tId: json["t_id"],
      gstNo: json["gst_no"],
      gstCopy: json["gst_copy"],
    );
  }

}

class EmergencyContactDetail {
  EmergencyContactDetail({
    required this.emerName,
    required this.emerContact,
    required this.emerRelationship,
  });

  final String? emerName;
  final String? emerContact;
  final String? emerRelationship;

  factory EmergencyContactDetail.fromJson(Map<String, dynamic> json){
    return EmergencyContactDetail(
      emerName: json["emer_name"],
      emerContact: json["emer_contact"],
      emerRelationship: json["emer_relationship"],
    );
  }

}


class UserState {
  static final ValueNotifier<UserDetailsData?> userData = ValueNotifier(null);

  static void update(UserDetailsData? newUserData) {
    userData.value = newUserData;
  }

  static void clear() {
    userData.value = null;
  }
}
