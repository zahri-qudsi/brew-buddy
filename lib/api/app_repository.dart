import 'dart:io';

import '../Model/FlavourModel.dart';
import '../Model/MachineModel.dart';
import '../Model/OrderModel.dart';
import '../Model/StoreModel.dart';
import '../Model/TokenModel.dart';
import '../Model/UserModel.dart';
import '../util/network_util.dart';

class AppRepository {
  final String authToken;
  dynamic headers;

  AppRepository({required this.authToken}) {
    headers = {
      // HttpHeaders.acceptHeader: "application/json",
      // HttpHeaders.contentTypeHeader: "application/json",
      //HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $authToken'
    };
  }

  NetworkUtil net = NetworkUtil();

  Future<bool> verifyPhone(dynamic body) async {
    return net
        .post('/client/phone/verify', body: body)
        .then((dynamic res) async {
      if (res != null && res['status'] == true) {
        return true;
      } else {
        throw Exception(res.message);
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<TokenModel> login(dynamic body) async {
    return net.post('/client/login', body: body).then((dynamic res) async {
      if (res != null) {
        return TokenModel.fromJson(res);
      } else {
        throw Exception(res.message);
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<List<StoreModel>> getStores() async {
    return net.get('/store/get', headers: headers).then((dynamic res) async {
      if (res != null) {
        return List<StoreModel>.from(
            res['data'].map((store) => StoreModel.fromJson(store)));
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<List<FlavourModel>> getFlavours() async {
    return net.get('/flavour/get', headers: headers).then((dynamic res) async {
      if (res != null) {
        return List<FlavourModel>.from(
            res['data'].map((store) => FlavourModel.fromJson(store)));
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<List<MachineModel>> getMachines() async {
    return net.get('/machine/get', headers: headers).then((dynamic res) async {
      if (res != null) {
        return List<MachineModel>.from(
            res['data'].map((machine) => MachineModel.fromJson(machine)));
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<UserModel> getProfile() async {
    return net.get('/profile', headers: headers).then((dynamic res) async {
      if (res != null) {
        return UserModel.fromJson(res);
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> placeOrder(dynamic body) async {
    return net
        .post('/order/create', body: body, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        if (res['status']) {
          return true;
        }
        return false;
      } else {
        throw Exception(res.message);
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> updateProfile(dynamic body) async {
    return net
        .post('/profile/update', body: body, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return true;
      } else {
        throw Exception(res.message);
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> deleteProfile(dynamic body) async {
    return net
        .post('/profile/delete', body: body, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return true;
      } else {
        throw Exception(res.message);
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<List<OrderModel>> getMyOrders() async {
    return net
        .get('/client/orders', headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return List<OrderModel>.from(
            res.map((order) => OrderModel.fromJson(order)));
      } else {
        throw Exception("Error loading data");
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<bool> logout(dynamic body) async {
    return net
        .post('/logout', body: body, headers: headers)
        .then((dynamic res) async {
      if (res != null) {
        return true;
      } else {
        throw Exception(res.message);
      }
    }).catchError((e) {
      throw e;
    });
  }
}
