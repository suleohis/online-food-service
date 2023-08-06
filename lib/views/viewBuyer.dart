import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_court/modal/cart_item.dart';
import 'package:food_court/modal/orderModal.dart';
import 'package:food_court/modal/user.dart';
import 'package:food_court/widget/widget.dart';

class ViewBuyer extends StatefulWidget {
  final CartItemModel cart;
  final OrderModel orderModel;
  final UserModel userModel;
  final int totalAmount;
  const ViewBuyer(
      {Key? key,
      required this.cart,
      required this.orderModel,
      required this.userModel,
      required this.totalAmount})
      : super(key: key);

  @override
  _ViewBuyerState createState() => _ViewBuyerState();
}

class _ViewBuyerState extends State<ViewBuyer> {
  bool doneButtonActive = true;
  canceledOrder() {
    setState(() {
      doneButtonActive = false;
    });
    FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderModel.id)
        .update({'canceled': true})
        .then((value) => Navigator.pop(context))
        .catchError((e) {
      setState(() {
        doneButtonActive = true;
      });
      showSnack(context, "Please Check Your Network");
    });
  }
  completeOrder() {

    FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.cart.restaurantId)
        .update({'totalAmount': widget.cart.price! * widget.cart.quantity! + widget.totalAmount}).then(
            (value) {
      FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderModel.id)
          .update({'status': true})
          .then((value) => Navigator.pop(context))
          .catchError((e) {
            setState(() {
              doneButtonActive = true;
            });
            showSnack(context, "Please Check Your Network");
          });
    }).catchError((e) {
      setState(() {
        doneButtonActive = true;
      });
      showSnack(context, "Please Check Your Network");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const BackButton(),
        title: const Text('Order Detail'),
        backgroundColor: Colors.orange[900],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: [
            const Text(
              'Customer Detail',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Name : ' + widget.userModel.name!,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 18)),
            // const SizedBox(
            //   height: 10,
            // ),
            // const Text('Address :  To Put Address',
            //     style: const TextStyle(
            //         fontWeight: FontWeight.normal, fontSize: 18)),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Product Detail',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Product Name : ' + widget.cart.name!,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 18)),
            const SizedBox(
              height: 10,
            ),
            Text('Price : ' + widget.cart.price.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 18)),
            const SizedBox(
              height: 10,
            ),
            Text('Quantity : ' + widget.cart.quantity.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 18)),
            const SizedBox(
              height: 10,
            ),
            Text('Description : ' + widget.orderModel.description!,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 18)),
            const SizedBox(
              height: 10,
            ),
            if (widget.orderModel.canceled == true)
            const Text(
              'Status : ' + 'Canceled',
              style:
              TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            )
            else
            Text(
              'Status : ' +
                  (widget.orderModel.status == true ? "Completed" : "Waiting"),
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Total Price : '
                '${widget.cart.price! * widget.cart.quantity!}',
                style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (widget.orderModel.canceled != true && widget.orderModel.status != true)
            Center(
              child: Wrap(
                children: [
                  GestureDetector(
                    onTap: doneButtonActive ? () => completeOrder() : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[900],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                      child: doneButtonActive
                          ? const Text(
                        'Create',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 19),
                      )
                          : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  GestureDetector(
                    onTap: doneButtonActive ? () => showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: Text('Are You Sure'),
                        actions: [
                          Row(
                            children: [

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  canceledOrder();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange[900],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                                  child: doneButtonActive
                                      ? const Text(
                                    'Yes',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 19),
                                  )
                                      : const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[800],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                                  child: doneButtonActive
                                      ? const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 19),
                                  )
                                      : const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    }) : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[800],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                      child: doneButtonActive
                          ? const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 19),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
