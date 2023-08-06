import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_court/modal/productModal.dart';
import 'package:food_court/modal/restaurantModal.dart';
import 'package:food_court/views/details.dart';
import 'package:food_court/widget/custom_text.dart';
import 'package:food_court/widget/productWidget.dart';
import 'package:food_court/widget/widget.dart';

class BukaInfo extends StatefulWidget {
  final RestaurantModel restaurantModel ;
  const BukaInfo({Key? key,required this.restaurantModel}) : super(key: key);
  @override
  _BukaInfoState createState() => _BukaInfoState();
}

class _BukaInfoState extends State<BukaInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              const Positioned.fill(
                  child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )),

              // restaurant image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child:CachedNetworkImage(imageUrl:widget.restaurantModel.image!,height: 160,

                  fit: BoxFit.fill,width: double.infinity,)

              ),

              // fading black
              Container(
                height: 160,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.025),
                      ],
                    )),
              ),

              //restaurant name
              Positioned.fill(
                  bottom: 60,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomText(
                        text: widget.restaurantModel.name,
                        color: Colors.white,
                        size: 26,
                        weight: FontWeight.w300,
                      ))),

              // average price
              Positioned.fill(
                  bottom: 40,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomText(
                        text: "Average Price: \$${widget.restaurantModel.avgPrice}" ,
                        color: Colors.white,
                        size: 18,
                        weight: FontWeight.w300,
                      ))),

              // rating widget
              Positioned.fill(
                  bottom: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow[900],
                                size: 20,
                              ),
                            ),
                             Text('${widget.restaurantModel.rating}'),
                          ],
                        ),
                      ),
                    ),
                  )),

              // close button
              Positioned.fill(
                  top: 5,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.2)),
                            child: const Icon(
                              Icons.close,
                              size: 28,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  )),

              //like button
              // Positioned.fill(
              //     top: 5,
              //     child: Align(
              //       alignment: Alignment.topRight,
              //       child: Padding(
              //         padding: const EdgeInsets.all(4),
              //         child: GestureDetector(
              //           onTap: () {},
              //           child: SmallButton(Icons.favorite),
              //         ),
              //       ),
              //     )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

//              open & book section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomText(
                text: "Open",
                color: Colors.green,
                weight: FontWeight.w400,
                size: 18,
              ),

              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.report),
                  label: CustomText(text: "Report Here"))
            ],
          ),

          // products
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('products')
                .where('restaurantId' ,isEqualTo:widget.restaurantModel.id)
                .snapshots(),
              builder:(context,AsyncSnapshot<QuerySnapshot<dynamic>> snapshot){
              print('product ');
              return snapshot.hasData
                  ?ListView.builder(
                shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    print('product ');
                      DocumentSnapshot docSnap = snapshot.data!.docs[index];
                      ProductModel productModel = ProductModel.fromSnapshot(docSnap);
                      return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder:
                                (context)=>Details(productModel: productModel,)));
                          },
                          child: ProductWidget(product:productModel ));
                  },
              ) : const SizedBox(width: 0,height: 0,);
              }
          ),

        ],
      )),
    );
  }
}
