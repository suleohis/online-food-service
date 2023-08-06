import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_court/Payment/paystack_payment_page.dart';
import 'package:food_court/helper/style.dart';
import 'package:food_court/modal/cart%20Function.dart';
import 'package:food_court/modal/cart_item.dart';
import 'package:food_court/modal/orderServices.dart';
import 'package:food_court/views/homepage.dart';

import 'package:food_court/widget/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  bool isWaiting = false;
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Shopping Cart", color: null, size: null, weight: null,),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body:  ListView.builder(
          itemCount: userModel!.cart!.length,
          itemBuilder: (_, index) {

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                          color: red.withOpacity(0.2),
                          offset: const Offset(3, 2),
                          blurRadius: 30)
                    ]),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),

                      child: CachedNetworkImage(
                        imageUrl: userModel!.cart![index].image!,
                        height: 120,
                        width: 140,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: RichText(
                              text:  TextSpan(children: [
                                TextSpan(
                                    text: userModel!.cart![index].name!+ "\n",
                                    style: const TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: "\$${ userModel!.cart![index].price} \n\n",
                                    style: const TextStyle(
                                        color: black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300)),
                                const TextSpan(
                                    text: "Quantity: ",
                                    style: TextStyle(
                                        color: grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                    text: '${userModel!.cart![index].quantity}',
                                    style: const TextStyle(
                                        color: primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ]),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: red,
                              ),
                              onPressed: ()async{
                                bool value = await AddCartFunction()
                                    .removeFromCart(cartItem: userModel!.cart![index]);
                                if(value){
                                  print("Item added to cart");

                                  getUserModel().then((value){
                                    setState(() {
                                      userModel;
                                    });
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Removed from Cart!"))
                                  );
                                  return;
                                }else{
                                  print("ITEM WAS NOT REMOVED");
                                }
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text:  TextSpan(children: [
                  const TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                          color: grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: " \$${userModel!.totalCartPrice}",
                      style: const TextStyle(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.normal)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: primary),
                child: TextButton(
                    onPressed: () {
                      if(userModel!.totalCartPrice == 0){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20.0)), //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const <Widget>[
                                            Text('Your cart is empty', textAlign: TextAlign.center,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20.0)), //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Text('You will be charged \$'
                                           '${userModel!.totalCartPrice} '
                                           'upon delivery!',
                                         textAlign: TextAlign.center,),

                                      SizedBox(
                                        width: 320.0,
                                        child: ElevatedButton(
                                          onPressed: () async{
                                            var uuid = const Uuid();
                                            String id = uuid.v4();
                                            MakePayment(
                                                name: userModel!.name,
                                                uid: id,
                                                ctx: context,
                                                email: userModel!.email,
                                                price: userModel!.totalCartPrice

                                            ).chargeCardAndMakePayment().whenComplete(() {
                                              setState(() {

                                              });
                                            });
                                          },
                                          child: const Text(
                                            "Accept",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: const Color(0xFF1BC0C5),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Reject",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary:Colors. red
                                            ),

                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: CustomText(
                      text: "Check out",
                      size: 20,
                      color: Colors.white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
