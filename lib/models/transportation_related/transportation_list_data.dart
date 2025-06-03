class TransportationDataList {
  TransportationDataList({
    required this.data,
  });

  final List<TransportationData> data;

  factory TransportationDataList.fromJson(Map<String, dynamic> json){
    return TransportationDataList(
      data: json["data"] == null ? [] : List<TransportationData>.from(json["data"]!.map((x) => TransportationData.fromJson(x))),
    );
  }

}

class TransportationData {
  TransportationData({
    required this.id,
    required this.tId,
    required this.tName,
    required this.contNo,
    required this.altContNo,
    required this.propriterName,
    required this.country,
    required this.state,
    required this.district,
    required this.city,
    required this.pincode,
    required this.address,
    required this.gst,
    required this.vType,
    required this.bName,
    required this.aName,
    required this.aNo,
    required this.ifsc,
    required this.serviceList,
    required this.status,
    required this.addDate,
    required this.updateDate,
  });

  final int? id;
  final String? tId;
  final String? tName;
  final String? contNo;
  final dynamic altContNo;
  final String? propriterName;
  final String? country;
  final String? state;
  final String? district;
  final String? city;
  final String? pincode;
  final String? address;
  final String? gst;
  final String? vType;
  final String? bName;
  final String? aName;
  final String? aNo;
  final String? ifsc;
  final List<ServiceList> serviceList;
  final bool? status;
  final DateTime? addDate;
  final DateTime? updateDate;

  factory TransportationData.fromJson(Map<String, dynamic> json){
    return TransportationData(
      id: json["id"],
      tId: json["t_id"],
      tName: json["t_name"],
      contNo: json["cont_no"],
      altContNo: json["Alt_cont_no"],
      propriterName: json["propriter_name"],
      country: json["country"],
      state: json["state"],
      district: json["district"],
      city: json["city"],
      pincode: json["pincode"],
      address: json["address"],
      gst: json["gst"],
      vType: json["v_type"],
      bName: json["b_name"],
      aName: json["a_name"],
      aNo: json["a_no"],
      ifsc: json["ifsc"],
      serviceList: json["service_list"] == null ? [] : List<ServiceList>.from(json["service_list"]!.map((x) => ServiceList.fromJson(x))),
      status: json["status"],
      addDate: DateTime.tryParse(json["add_date"] ?? ""),
      updateDate: DateTime.tryParse(json["update_date"] ?? ""),
    );
  }

}

class ServiceList {
  ServiceList({
    required this.serState,
    required this.serDistrict,
  });

  final String? serState;
  final List<String> serDistrict;

  factory ServiceList.fromJson(Map<String, dynamic> json){
    return ServiceList(
      serState: json["ser_state"],
      serDistrict: json["ser_district"] == null ? [] : List<String>.from(json["ser_district"]!.map((x) => x)),
    );
  }

}
