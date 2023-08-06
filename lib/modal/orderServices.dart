import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';
import 'orderModal.dart';

class OrderServices{
  String collection = "orders";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createOrder({required String userId ,required String id,required String description,
    required bool status ,required List<CartItemModel> cart, required int totalPrice}) {
    List<Map> convertedCart = [];
    List<String> restaurantIds = [];

    for(CartItemModel item in cart){
      convertedCart.add(item.toMap());
      restaurantIds.add(item.restaurantId!);
    }


    _firestore.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "restaurantIds": restaurantIds,
      "cart": convertedCart,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status,
      "canceled": false
    });
  }

  Future<List<OrderModel>> getUserOrders({required String userId}) async =>
      _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .orderBy('createdAt')
          .get()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.docs) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });

}