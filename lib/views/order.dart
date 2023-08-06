import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_court/helper/style.dart';
import 'package:food_court/modal/orderModal.dart';
import 'package:food_court/widget/custom_text.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index){
                DocumentSnapshot docSnap = snapshot.data!.docs[index];
                OrderModel orderModel = OrderModel.fromSnapshot(docSnap);
                return ListTile(
                  leading: CustomText(
                    text: "\$${ orderModel.total}",
                    weight: FontWeight.bold,
                  ),
                  title:  Text('${orderModel.description}'),
                  subtitle: Text(DateTime.fromMillisecondsSinceEpoch(orderModel.createdAt!).toString()),
                  trailing: CustomText(text: orderModel.canceled == true? 'Canceled' :orderModel.status == true ? "Completed" : "Waiting" , color: green,),
                );
              });
        }
      ),
    );
  }
}
