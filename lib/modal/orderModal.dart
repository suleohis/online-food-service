import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_court/modal/cart_item.dart';

class OrderModel{
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CANCELED = 'canceled';
  static const CREATED_AT = "createdAt";
  static const RESTAURANT_ID = "restaurantId";


  String? _id;
  String? _restaurantId;
  String? _description;
  String? _userId;
  bool? _status;
  bool? _canceled;
  int? _createdAt;
  int? _total;

//  getters
  String? get id => _id;
  String? get restaurantId => _restaurantId;
  String? get description => _description;
  String? get userId => _userId;
  bool? get status => _status;
  bool? get canceled => _canceled;
  int? get total => _total;
  int? get createdAt => _createdAt;

  // public variable
  List? cart;


  OrderModel.fromSnapshot(DocumentSnapshot<dynamic> snapshot){
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION];
    _total = snapshot.data()[TOTAL];
    _status = snapshot.data()[STATUS];
    _canceled = snapshot.data()[CANCELED];
    _userId = snapshot.data()[USER_ID];
    _createdAt = snapshot.data()[CREATED_AT];
    _restaurantId = snapshot.data()[RESTAURANT_ID];
    cart = snapshot.data()[CART];
  }









}