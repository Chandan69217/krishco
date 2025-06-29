class EnterpriseDetailsListData {
  EnterpriseDetailsListData({
    required this.data,
  });

  final List<Datum?> data;

  factory EnterpriseDetailsListData.fromJson(Map<String, dynamic> json){
    return EnterpriseDetailsListData(
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.customer,
  });

  final Customer? customer;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    );
  }

}

class Customer {
  Customer({
    required this.id,
    required this.name,
    required this.number,
    required this.groupCat,
    required this.groupName,
  });

  final int? id;
  final String? name;
  final String? number;
  final String? groupCat;
  final String? groupName;

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      id: json["id"],
      name: json["name"],
      number: json["number"],
      groupCat: json["group_cat"],
      groupName: json["group_name"],
    );
  }

}
