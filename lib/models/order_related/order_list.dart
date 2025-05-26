import 'order_product_data.dart';



class OrderListData {
  OrderListData({
    required this.data,
  });

  final List<OrderData> data;

  factory OrderListData.fromJson(Map<String, dynamic> json){
    return OrderListData(
      data: json["data"] == null ? [] : List<OrderData>.from(json["data"]!.map((x) => OrderData.fromJson(x))),
    );
  }

}

class OrderData {
  OrderData({
    required this.id,
    required this.addBy,
    required this.updateBy,
    required this.orderProduct,
    required this.orderedFor,
    required this.orderedFrom,
    required this.orderStatus,
    required this.statusMessage,
    required this.orderDate,
    required this.addDate,
    required this.updateDate,
    required this.orderBill,
    required this.orderNo,
    required this.orderType,
    required this.isTagged,
    required this.isRegistered,
    required this.nonRegisteredName,
    required this.nonRegisteredNumber,
    required this.nonRegisteredAddress,
    required this.orderRemarks,
    required this.appName,
  });

  final int? id;
  final AddBy? addBy;
  final dynamic updateBy;
  final List<OrderProduct> orderProduct;
  final OrderedFrom? orderedFor;
  final OrderedFrom? orderedFrom;
  final String? orderStatus;
  final String? statusMessage;
  final DateTime? orderDate;
  final DateTime? addDate;
  final DateTime? updateDate;
  final List<dynamic> orderBill;
  final String? orderNo;
  final String? orderType;
  final bool? isTagged;
  final bool? isRegistered;
  final String? nonRegisteredName;
  final int? nonRegisteredNumber;
  final String? nonRegisteredAddress;
  final dynamic orderRemarks;
  final String? appName;

  factory OrderData.fromJson(Map<String, dynamic> json){
    return OrderData(
      id: json["id"],
      addBy: json["add_by"] == null ? null : AddBy.fromJson(json["add_by"]),
      updateBy: json["update_by"],
      orderProduct: json["order_product"] == null ? [] : List<OrderProduct>.from(json["order_product"]!.map((x) => OrderProduct.fromJson(x))),
      orderedFor: json["ordered_for"] == null ? null : OrderedFrom.fromJson(json["ordered_for"]),
      orderedFrom: json["ordered_from"] == null ? null : OrderedFrom.fromJson(json["ordered_from"]),
      orderStatus: json["order_status"],
      statusMessage: json["status_message"],
      orderDate: DateTime.tryParse(json["order_date"] ?? ""),
      addDate: DateTime.tryParse(json["add_date"] ?? ""),
      updateDate: DateTime.tryParse(json["update_date"] ?? ""),
      orderBill: json["order_bill"] == null ? [] : List<dynamic>.from(json["order_bill"]!.map((x) => x)),
      orderNo: json["order_no"],
      orderType: json["order_type"],
      isTagged: json["is_tagged"],
      isRegistered: json["is_registered"],
      nonRegisteredName: json["non_registered_name"],
      nonRegisteredNumber: json["non_registered_number"],
      nonRegisteredAddress: json["non_registered_address"],
      orderRemarks: json["order_remarks"],
      appName: json["app_name"],
    );
  }

}

// class AddBy {
//   AddBy({
//     required this.id,
//     required this.name,
//     required this.number,
//     required this.email,
//     required this.groupType,
//     required this.groupName,
//   });
//
//   final int? id;
//   final String? name;
//   final String? number;
//   final String? email;
//   final String? groupType;
//   final String? groupName;
//
//   factory AddBy.fromJson(Map<String, dynamic> json){
//     return AddBy(
//       id: json["id"],
//       name: json["name"],
//       number: json["number"],
//       email: json["email"],
//       groupType: json["group_type"],
//       groupName: json["group_name"],
//     );
//   }
//
// }
//
// class OrderProduct {
//   OrderProduct({
//     required this.id,
//     required this.product,
//     required this.orderedQuantity,
//     required this.confirmedQuantity,
//     required this.dispatchedQuantity,
//     required this.deleteRec,
//   });
//
//   final int? id;
//   final Product? product;
//   final int? orderedQuantity;
//   final int? confirmedQuantity;
//   final int? dispatchedQuantity;
//   final bool? deleteRec;
//
//   factory OrderProduct.fromJson(Map<String, dynamic> json){
//     return OrderProduct(
//       id: json["id"],
//       product: json["product"] == null ? null : Product.fromJson(json["product"]),
//       orderedQuantity: json["ordered_quantity"],
//       confirmedQuantity: json["confirmed_quantity"],
//       dispatchedQuantity: json["dispatched_quantity"],
//       deleteRec: json["delete_rec"],
//     );
//   }
//
// }
//
// class Product {
//   Product({
//     required this.id,
//     required this.prdId,
//     required this.catgeory,
//     required this.name,
//     required this.price,
//     required this.unit,
//     required this.quanityPerQr,
//     required this.photo,
//     required this.status,
//     required this.deleteRec,
//   });
//
//   final int? id;
//   final String? prdId;
//   final String? catgeory;
//   final String? name;
//   final String? price;
//   final String? unit;
//   final String? quanityPerQr;
//   final String? photo;
//   final bool? status;
//   final bool? deleteRec;
//
//   factory Product.fromJson(Map<String, dynamic> json){
//     return Product(
//       id: json["id"],
//       prdId: json["prd_id"],
//       catgeory: json["catgeory"],
//       name: json["name"],
//       price: json["price"],
//       unit: json["unit"],
//       quanityPerQr: json["quanity_per_qr"],
//       photo: json["photo"],
//       status: json["status"],
//       deleteRec: json["delete_rec"],
//     );
//   }
//
// }
//
class OrderedFrom {
  OrderedFrom({
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

  factory OrderedFrom.fromJson(Map<String, dynamic> json){
    return OrderedFrom(
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
