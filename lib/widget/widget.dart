import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_court/helper/style.dart';
import 'package:food_court/modal/modal.dart';
import 'package:food_court/modal/restaurantModal.dart';
import 'package:food_court/views/buka_info.dart';

AppBar appBar() {
  return AppBar(
    backgroundColor:  Colors.orange[900],
    title: const Text('Food Courts'),
  );
}

class StaggeredGridViewContainer extends StatelessWidget {
  const StaggeredGridViewContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      itemCount: bukaList.length,
      itemBuilder: (BuildContext context, int index) {
        if (kDebugMode) {
          print(index);
        }
        return GestureDetector(
          onTap: () {

          },
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.transparent)),
            child: Card(
              child: Column(
                children: [
                  Image(
                    image: AssetImage(bukaList[index]),
                  ),
                  ListTile(
                    title: Text('Buka ${index + 1}'),
                  )
                ],
              ),
            ),
          ),
        );
      },
      crossAxisCount: 2,
      staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class ListviewOFBuka extends StatelessWidget {
  const ListviewOFBuka({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('restaurants').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
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
          }),
    );
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

}


showSnack(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(text))
);