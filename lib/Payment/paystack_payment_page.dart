import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:food_court/modal/paystack_key.dart';

import '../modal/cart Function.dart';
import '../modal/cart_item.dart';
import '../modal/orderServices.dart';
import '../views/homepage.dart';

class MakePayment{
  MakePayment({
    required this.ctx,
    required this.price,
    required this.email,
    // required this.buka,
    // required this.food,
    required this.name,
    required this.uid
  });

  BuildContext? ctx;

  int? price;

  String? email;
  String? uid;
  String? name;
  // String? food;
  // String? buka;

  PaystackPlugin paystack = PaystackPlugin();
///Reference
  String _getReference(){
    String platform;
    if(Platform.isIOS){
      platform = 'iOS';
    }else{
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_$uid';
  }

  ///GetUi
  PaymentCard _getCardUI(){
    return PaymentCard(number: '', cvc: '', expiryMonth: 0, expiryYear: 0);
  }

  Future initializePLugin()async{
    await paystack.initialize(publicKey: ConstantKey.PAYSTACK_KEY);
  }

  ///Method Charging card
  Future<CheckoutResponse?>  chargeCardAndMakePayment()async{
    CheckoutResponse? response;
    initializePLugin().then((_)async{
      Charge charge = Charge()
          ..amount = price! * 100
          ..email = email!
          ..reference = _getReference()
          ..card = _getCardUI()
          ..putCustomField('Charged From', 'from $name');

       response = await paystack.checkout(
        ctx!,
        charge: charge,
        method: CheckoutMethod.card,
        fullscreen: false,
        logo: const FlutterLogo(
          size: 24,
        )
      );

      if (kDebugMode) {
        print('Respsone $response');
      }

      if(response!.status== true){
        print('here is payment');
          OrderServices()
              .createOrder(
              userId: userModel!.id!,
              id: uid!,
              description: 'Some random description',
              status: false,
              cart: userModel!.cart!,
              totalPrice: userModel!.totalCartPrice!
          );
          for(CartItemModel cartItem in userModel!.cart!){
            bool value = await AddCartFunction().
            removeFromCart(cartItem: cartItem);
            if(value){

              print("Item added to cart");
              ScaffoldMessenger.of(ctx!).showSnackBar(
                  const SnackBar(content: Text("Removed from Cart!"))
              );
            }else{
              print("ITEM WAS NOT REMOVED");
            }
          }
          getUserModel();

          ScaffoldMessenger.of(ctx!).showSnackBar(
              const SnackBar(content: Text("Order created!"))
          );
          Navigator.pop(ctx!);
          Navigator.pop(ctx!);


        if (kDebugMode) {
          print('Transaction successful');
        }
      }else{
      ScaffoldMessenger.of(ctx!).showSnackBar(
      const SnackBar(content: Text("Payment Failed"))
      );

        if (kDebugMode) {
          print('Transaction failed');
        }
      }

    });
    return response;
  }


}