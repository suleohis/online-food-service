
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:food_court/helper/style.dart';
import 'package:food_court/helperfuctions/database.dart';
import 'package:food_court/modal/cart%20Function.dart';
import 'package:food_court/modal/productModal.dart';
import 'package:food_court/views/cart.dart';
import 'package:food_court/views/homepage.dart';
import 'package:food_court/widget/custom_text.dart';
import 'package:provider/provider.dart';




class Details extends StatefulWidget {
  ProductModel productModel;
  Details({Key? key,required this.productModel}) : super(key: key);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;
  final _key = GlobalKey<ScaffoldState>();
   String imageUrl = '';
  @override
  void initState() {
    imageUrl = widget.productModel.image!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>CartScreen()));
            },
          ),

        ],
        leading: IconButton(icon: const Icon(Icons.close), onPressed: (){Navigator.pop(context);}),
      ),
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           imageUrl == ''?
               const CircleAvatar(
                 radius: 120,
                 backgroundColor: Colors.grey,
               )
               :  ClipRRect(
             borderRadius: BorderRadius.circular(120),
                 child: CircleAvatar(
              radius: 120,
                 child: CachedNetworkImage(imageUrl:imageUrl, width:240,fit: BoxFit.fill,),
            ),
               ),
            const SizedBox(height: 15,),

            CustomText(text: widget.productModel.name,size: 26,weight: FontWeight.bold),
            CustomText(text: "\$${ widget.productModel.price}",size: 20,weight: FontWeight.w400),
            const SizedBox(height: 10,),

            CustomText(text: "Description",size: 18,weight: FontWeight.w400),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.productModel.description! , textAlign: TextAlign.center, style: const TextStyle(color: grey, fontWeight: FontWeight.w300),),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: const Icon(Icons.remove,size: 36,), onPressed: (){
                    if(quantity != 1){
                      setState(() {
                        quantity -= 1;
                      });
                    }
                  }),
                ),

                GestureDetector(
                  onTap: ()async{
                    bool value = await AddCartFunction().
                    addToCard(product: widget.productModel, quantity: quantity);
                    if(value){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add to Cart'))
                      );
                      getUserModel();
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
                    }
                    },
                  child: Container(
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.fromLTRB(28,12,28,12),
                      child: CustomText(text: "Add $quantity To Cart",color: white,size: 22,weight: FontWeight.w300,),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: const Icon(Icons.add,size: 36,color: red,), onPressed: (){
                    setState(() {
                      quantity += 1;
                    });
                  }),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
