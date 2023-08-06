import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../helper/style.dart';
import '../../modal/restaurantModal.dart';
import '../buka_info.dart';

class AdminRestaurants extends StatefulWidget {
  const AdminRestaurants({Key? key}) : super(key: key);

  @override
  State<AdminRestaurants> createState() => _AdminRestaurantsState();
}

class _AdminRestaurantsState extends State<AdminRestaurants> {
  TextEditingController searchTextEditingController = TextEditingController();
  bool shouldSearch = false;
  bool flitterThePage = false;
  String searchItem = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        backgroundColor:  Colors.orange[900]

      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 10, left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width - 120,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5))),
                          child: TextField(
                            controller: searchTextEditingController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search Business'),
                            onChanged: (String val) {},
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (searchTextEditingController.text.isNotEmpty) {
                                shouldSearch = true;
                              } else {
                                shouldSearch = false;
                              }
                            });
                            searchItem = searchTextEditingController.text;
                          },
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.orange[900],
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5))),
                            child: const Icon(
                              Icons.search_sharp,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 75),
              child: createBusinessLines())
        ],
      ),
    );
  }

  createBusinessLines() {
    return StreamBuilder(
        stream: shouldSearch
            ? FirebaseFirestore.instance.collection('restaurants')
            .where('name',
            isGreaterThanOrEqualTo: searchTextEditingController.text)
            .orderBy("name", descending: true)
            .snapshots()
            : FirebaseFirestore.instance.collection('restaurants').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
          // if (!snapshot.hasData) {
          //   return MyWidgets().noDataPlaceholder(
          //       'There are no active businesses'
          //       , Icons.business_center);
          // }
          if (!snapshot.hasData) {
            return noDataPlaceholder(
                'There are no active restaurants', Icons.business_center);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('We encountered an error'));
          } else if (snapshot.data!.docs.isEmpty) {
            return noDataPlaceholder(
                'There are no active restaurants', Icons.business_center);
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 30),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot docSnap = snapshot.data!.docs[index];
                RestaurantModel restaurantModel = RestaurantModel.fromSnapshot(docSnap);
                if (kDebugMode) {
                  print(index);
                }
                return SizedBox(
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) => BukaInfo(
                                      restaurantModel: restaurantModel,
                                    )));
                          },
                          child: Container(
                            height: 200,
                            padding:  EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                backgroundImage(restaurantModel.image),
                                Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.8),
                                                Colors.black.withOpacity(0.7),
                                                Colors.black.withOpacity(0.6),
                                                Colors.black.withOpacity(0.4),
                                                Colors.black.withOpacity(0.1),
                                                Colors.black.withOpacity(0.05),
                                                Colors.black.withOpacity(0.025),
                                              ],
                                            )),
                                      ),
                                    )),
                                Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 8, 8, 8),
                                            child: RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                        "${restaurantModel.name} \n",
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                            FontWeight.bold)),
                                                    const TextSpan(
                                                        text: "avg meal price: ",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w300)),
                                                    TextSpan(
                                                        text: "\$${restaurantModel.avgPrice} \n",
                                                        style: const TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        });

  }


  Widget backgroundImage(String? image){
    if(image == '' || image == null){
      return Container(
          height: 200,
          decoration: BoxDecoration(
            color: grey.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Image.asset("assets/images/table.png",fit: BoxFit.fill,),
          )
      );
    }else{
      return Padding(
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CachedNetworkImage(imageUrl: image,fit: BoxFit.fill,height: 200,)
              ],
            )),
      );
    }
  }

  Center noDataPlaceholder(String text, IconData icon){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
              child: Icon(icon, color: Colors.grey, size: 150)
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text(text, style: TextStyle(fontSize: 30, color: Colors.black45, fontWeight: FontWeight.bold ), textAlign: TextAlign.center,)
          )
        ],
      ),
    );
  }
}
