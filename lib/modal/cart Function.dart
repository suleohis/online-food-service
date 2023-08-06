
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_court/helperfuctions/database.dart';
import 'package:food_court/modal/productModal.dart';
import 'package:food_court/views/homepage.dart';
import 'package:uuid/uuid.dart';

import 'cart_item.dart';

class AddCartFunction{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> addToCard({required ProductModel product, required int quantity})async{
    print("THE PRODUCT IS: ${product.toString()}");
    print("THE qty IS: ${quantity.toString()}");

    try{
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel>? cart = userModel!.cart;
//      bool itemExists = false;
      Map cartItem ={
        "id": cartItemId,
        "name": product.name,
        "image": product.image,
        "restaurantId": product.restaurantId,
        "totalRestaurantSale": product.price! * quantity,
        "productId": product.id,
        "price": product.price,
        "quantity": quantity
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      DatabaseMethods().addToCart(userId: userModel!.id!, cartItem: item);
//      }



      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  Future<bool> removeFromCart({required CartItemModel cartItem})async{
    print("THE PRODUC IS: ${cartItem.toString()}");

    try{
      DatabaseMethods().removeFromCart(userId: userModel!.id!, cartItem: cartItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }
}