import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_court/helperfuctions/auth.dart';
import 'package:food_court/helperfuctions/database.dart';
import 'package:food_court/modal/user.dart';
import 'package:food_court/views/Restaurants.dart';
import 'package:food_court/views/admin/adminHome.dart';
import 'package:food_court/views/login.dart';
import 'package:food_court/widget/custom_text.dart';
import 'package:food_court/widget/featured_product.dart';
import 'package:food_court/widget/widget.dart';

import 'cart.dart';
import 'order.dart';

UserModel? userModel ;
class HomePage extends StatefulWidget{
   HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  void initState() {
    userModel = UserModel(name: '', email: '');
    getUserModel();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(

                decoration:  BoxDecoration(color:  Colors.orange[900]),
                accountName: CustomText(
                  text: userModel!.name,
                  color: Colors.white,
                  weight: FontWeight.bold,
                  size: 18,
                ),
                accountEmail: CustomText(
                  text:  userModel!.email,
                  color: Colors.white,
                ),
              ),


              ListTile(
                onTap: () async{
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => OrdersScreen()));

                },
                leading: const Icon(Icons.bookmark_border),
                title: CustomText(text: "My orders"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
                },
                leading: const Icon(Icons.shopping_cart),
                title: CustomText(text: "Cart"),
              ),
              if(userModel !=null && userModel!.role == 'seller')
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RestaurantsPage()));
                },
                leading: const Icon(Icons.restaurant),
                title: CustomText(text: "Vendor"),
              ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminHomePage()));
                  },
                  leading: const Icon(Icons.admin_panel_settings),
                  title: CustomText(text: "Admin Panel"),
                ),
              ListTile(
                onTap: () {
                  Authentication.signOUt(context: context);
                },
                leading: const Icon(Icons.exit_to_app),
                title: CustomText(text: "Log out"),
              ),
            ],
          ),
        ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children:  [

            Padding(
              padding:  const EdgeInsets.all(8.0),
              child: CustomText(
                text: "Welcome To Buka, Hope You have a Good Meal",
                size: 25,
                color: Colors.red,
              ),
            ),
            Padding(
              padding:  const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomText(
                    text: "Featured",
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Featured(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child:  Text('Restaurants',style:
                  TextStyle(color: Colors.grey,fontSize: 20),)),
            ),
            const SizedBox( height: 5,),
            const ListviewOFBuka(),

          ],
        ),
      )
    );
  }
  Future getUserModel()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid)
        .get().then((DocumentSnapshot doc){
      userModel = UserModel().fromSnapshot(doc);
      setState(() {});
      print(userModel);
    }).catchError((e){
      print(e);
      getUserModel();
    });
  }
}

Future getUserModel()async{
  FirebaseAuth auth = FirebaseAuth.instance;
  await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid)
      .get().then((DocumentSnapshot doc){
    userModel = UserModel().fromSnapshot(doc);
  }).catchError((e){
    print(e);
    getUserModel();
  });
}