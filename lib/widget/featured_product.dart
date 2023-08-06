import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_court/modal/modal.dart';
import 'package:food_court/modal/productModal.dart';
import 'package:food_court/views/details.dart';

import 'custom_text.dart';



class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> with AutomaticKeepAliveClientMixin{
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {


    return Container(
      height: 220,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot docSnap = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel.fromSnapshot(docSnap);
                return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 16, 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            Details(productModel: productModel,)));

                      },
                      child: Container(
                        height: 220,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300]!,
                                  offset: const Offset(-2, -1),
                                  blurRadius: 5),
                            ]),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: Stack(
                                children: <Widget>[
                                  const Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(),
                                      )),
                                  productModel.image != null ?
                                      CachedNetworkImage(imageUrl:productModel.image!,height: 126,width: 180,fit: BoxFit.fill,)
                                      :
                                  Center(
                                    child:Image.asset(bukaList[index],height: 126,)

                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomText(
                                    text:
                                        productModel.name ?? "id null",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: (){
                                      },
                                    child: Container(),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: CustomText(
                                        text: productModel.rating.toString() != 'null'
                                            ?productModel.rating.toString(): '3',
                                        color: Colors.grey,
                                        size: 14.0,
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 2,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CustomText(
                                    text:
                                    "\$${productModel.price!}",
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
              });
        }
      ),
    );
  }
}
