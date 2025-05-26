

class AddBy {
  AddBy({
    required this.id,
    required this.name,
    required this.number,
    required this.email,
    required this.groupType,
    required this.groupName,
  });

  final int? id;
  final String? name;
  final String? number;
  final String? email;
  final String? groupType;
  final String? groupName;

  factory AddBy.fromJson(Map<String, dynamic> json){
    return AddBy(
      id: json["id"],
      name: json["name"],
      number: json["number"],
      email: json["email"],
      groupType: json["group_type"],
      groupName: json["group_name"],
    );
  }

}

class OrderProduct {
  OrderProduct({
    required this.id,
    required this.product,
    required this.orderedQuantity,
    required this.confirmedQuantity,
    required this.dispatchedQuantity,
    required this.deleteRec,
  });

  final int? id;
  final Product? product;
  final int? orderedQuantity;
  final int? confirmedQuantity;
  final int? dispatchedQuantity;
  final bool? deleteRec;

  factory OrderProduct.fromJson(Map<String, dynamic> json){
    return OrderProduct(
      id: json["id"],
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
      orderedQuantity: json["ordered_quantity"],
      confirmedQuantity: json["confirmed_quantity"],
      dispatchedQuantity: json["dispatched_quantity"],
      deleteRec: json["delete_rec"],
    );
  }

}

class Product {
  Product({
    required this.id,
    required this.prdId,
    required this.catgeory,
    required this.name,
    required this.price,
    required this.unit,
    required this.quanityPerQr,
    required this.photo,
    required this.status,
    required this.deleteRec,
  });

  final int? id;
  final String? prdId;
  final String? catgeory;
  final String? name;
  final String? price;
  final String? unit;
  final String? quanityPerQr;
  final String? photo;
  final bool? status;
  final bool? deleteRec;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json["id"],
      prdId: json["prd_id"],
      catgeory: json["catgeory"],
      name: json["name"],
      price: json["price"],
      unit: json["unit"],
      quanityPerQr: json["quanity_per_qr"],
      photo: json["photo"],
      status: json["status"],
      deleteRec: json["delete_rec"],
    );
  }

}

class OrderedF {
  OrderedF({
    required this.id,
    required this.name,
    required this.number,
    required this.email,
    required this.groupType,
    required this.groupName,
    required this.photo,
    required this.status,
    required this.deleteRec,
  });

  final int? id;
  final String? name;
  final String? number;
  final String? email;
  final String? groupType;
  final String? groupName;
  final dynamic photo;
  final bool? status;
  final bool? deleteRec;

  factory OrderedF.fromJson(Map<String, dynamic> json){
    return OrderedF(
      id: json["id"],
      name: json["name"],
      number: json["number"],
      email: json["email"],
      groupType: json["group_type"],
      groupName: json["group_name"],
      photo: json["photo"],
      status: json["status"],
      deleteRec: json["delete_rec"],
    );
  }

}