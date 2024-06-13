import 'package:brew_buddy/Model/FlavourModel.dart';
import 'package:brew_buddy/Model/StoreModel.dart';

class OrderModel {
  int? id;
  int? orderNumber;
  StoreModel? store;
  FlavourModel? flavour;
  int? status;

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    store = StoreModel.fromJson(json['store']);
    flavour = FlavourModel.fromJson(json['flavour']);
    status = json['status'];
  }
}
