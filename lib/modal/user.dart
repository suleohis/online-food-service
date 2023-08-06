import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class Users {
  String userId;

  Users({required this.userId});
}

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";
  static const RESTAURANTID = 'restaurantId';
  static const ROLE = 'role';
  static const RESTAURANT = 'restaurant';

  final String? name;
  final String? email;
  final String? id;
  final String? stripeId;
  int priceSum;
  final int quantitySum;
  final String? restaurantId;
  final String? restaurant;
  final String? role;

  UserModel(
      {this.name = '',
      this.email = '',
      this.id,
      this.stripeId,
      this.priceSum = 0,
      this.quantitySum = 0,
      this.restaurant,
      this.cart,
      this.restaurantId,
      this.role,
      this.totalCartPrice});

//  public variable
  List<CartItemModel>? cart;
  int? totalCartPrice;

  UserModel fromSnapshot(DocumentSnapshot<dynamic> snapshot) {
    return UserModel(
      name: snapshot.data()[NAME],
      email: snapshot.data()[EMAIL],
      restaurantId: snapshot.data()[RESTAURANTID],
      restaurant: snapshot.data()[RESTAURANT],
      role: snapshot.data()[ROLE],
      id: snapshot.data()[ID],
      stripeId: snapshot.data()[STRIPE_ID],
      cart: _convertCartItems(snapshot.data()[CART]),
      totalCartPrice: snapshot.data()[CART] == null
          ? 0
          : getTotalPrice(cart: snapshot.data()[CART]),
    );
  }

  int getTotalPrice({required List? cart}) {
    if (cart == null) {
      return 0;
    }
    for (Map<String, dynamic> cartItem in cart) {
      priceSum = priceSum + cartItem["price"] * cartItem["quantity"] as int;
    }

    int total = priceSum;

    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");

    return total;
  }

  List<CartItemModel> _convertCartItems(List cart) {
    List<CartItemModel> convertedCart = [];
    for (Map cartItem in cart) {
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }
}
