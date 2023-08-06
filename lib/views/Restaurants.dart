import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:food_court/helper/style.dart';
import 'package:food_court/modal/cart_item.dart';
import 'package:food_court/modal/orderModal.dart';
import 'package:food_court/modal/productModal.dart';
import 'package:food_court/modal/restaurantModal.dart';
import 'package:food_court/modal/user.dart';
import 'package:food_court/views/createMeal.dart';
import 'package:food_court/views/homepage.dart';
import 'package:food_court/views/viewBuyer.dart';
import 'package:food_court/widget/productWidget.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool checkIfRestaurantIsExisting = false;
  bool nameFieldActive = true;
  bool priceFieldActive = true;
  bool doneButtonActive = true;

  bool imageIsValid = false;
  bool nameIsValid = false;
  bool priceIsValid = false;

  File? image;
  checkRestaurant() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('ownerId', isEqualTo: userModel!.id)
        .get();
    checkIfRestaurantIsExisting = snap.docs.isEmpty;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    checkRestaurant();
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              leading: const BackButton(
                color: Colors.white,
              ),
              title: const Text('Profile',
                  style: TextStyle(color: Colors.white, fontSize: 23)),
              backgroundColor: Colors.orange[900],
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            )),
                      )),
                ),
              ],
            )
          ];
        },
        body: Scaffold(
          backgroundColor: Colors.white,
          appBar: const PreferredSize(
            preferredSize: Size.zero,
            child: SizedBox(height: 0, width: 0),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    //          mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _buildHeader(),
                      const SizedBox(
                        height: 14,
                      ),
                      buildStats(),
                      const Divider(),
                      // displayProfilePosts()
                    ],
                  ),
                ),
                if (checkIfRestaurantIsExisting)
                  createRestaurantsWidget(context)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: checkIfRestaurantIsExisting == false
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateMeal()));
              },
              backgroundColor:  Colors.orange[900],
              icon: const Icon(Icons.fastfood),
              label: const Text('Add A New Meal'))
          : const SizedBox(),
    );
  }

  GestureDetector createRestaurantsWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(.4),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Image',
                  style: TextStyle(color: Colors.orange[900], fontSize: 20),
                ),
                const SizedBox(
                  height: 6,
                ),
                GestureDetector(
                  onTap: doneButtonActive
                      ? () {
                          ImagePicker()
                              .pickImage(source: ImageSource.gallery)
                              .then((value) {
                            if (value != null) {
                              image = File(value.path);
                              setState(() {});
                            }
                          });
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange[900]!),
                        borderRadius: BorderRadius.circular(30)),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: image == null
                        ? Icon(
                            Icons.add,
                            color: Colors.orange[900],
                            size: 30,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              image!,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                ),
                if (imageIsValid)
                  Text(
                    'Pick a Image',
                    style: TextStyle(color: Colors.red[900]),
                  ),
                const SizedBox(
                  height: 10,
                ),

                ///Change the fullName
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Restaurant Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.orange[900]),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: nameController,
                    enabled: nameFieldActive,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Restaurant Name',
                        errorText: nameIsValid
                            ? "Restaurant name can't be empty"
                            : null),
                    onChanged: (String value) {
                      if (nameIsValid) {
                        setState(() {
                          nameIsValid = false;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                ///Change the Price
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Average Price',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.orange[900]),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: priceController,
                    enabled: priceFieldActive,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Average Price',
                        errorText: priceIsValid
                            ? "Average Price can't be empty"
                            : null),
                    onChanged: (String value) {
                      if (priceIsValid) {
                        setState(() {
                          priceIsValid = false;
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: GestureDetector(
                    onTap: doneButtonActive ? () => checkForError() : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 15),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // String image = 'https://images.unsplash.com/photo-1552566626-52f8b828add9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=400&q=60';
  late RestaurantModel restaurantModel;
  ///This is used to display the user name ,
  _buildHeader() {
    try {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('restaurants')
              .where('ownerId', isEqualTo: userModel!.id)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
            DocumentSnapshot docSnap;

            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'NO PRODUCT YET',
                    style: TextStyle(color: Colors.orange[900], fontSize: 22),
                  ),
                );
              }
              docSnap = snapshot.data!.docs[0];
              restaurantModel = RestaurantModel.fromSnapshot(docSnap);
            }
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return snapshot.hasData
                ? Container(
                    color:  Colors.orange[900],
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                          width: 0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const SizedBox(width: 20.0),

                            ///Profile pic
                            GestureDetector(
                                onTap: () {
                                  showImage(
                                      tag: restaurantModel.image!,
                                      postImage: restaurantModel.image!);
                                },
                                child: SizedBox(
                                    width: 200.0,
                                    height: 200.0,
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.black,
                                        child: Hero(
                                            child: CircleAvatar(
                                                radius: 100.0,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        restaurantModel.image!
                                                        // progressIndicatorBuilder: (context, url, downloadProgress){
                                                        //   return LinearProgressIndicator(value: downloadProgress.progress);
                                                        // },
                                                        )),
                                            tag: restaurantModel.image!)))),
                            const SizedBox(height: 10.0),

                            ///Name of user
                            Column(
                              children: <Widget>[
                                Wrap(
                                  children: [
                                    Text(
                                      '${restaurantModel.name}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),

                                // const SizedBox(height: 10.0),
                                // Text(user.entryYear != null && user.isDirectEntry != null ? '${setStudentLevel(int.parse(user.entryYear!.substring(2)), user.isDirectEntry!, user.faculty!)} Level' : ''),
                                const SizedBox(height: 5.0),

                                ///Username
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${restaurantModel.owner}',
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      '${restaurantModel.totalAmount}',
                                      style: const TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : const CircularProgressIndicator();
            ;
          });
    } catch (e) {
      print(e);
      return const CircularProgressIndicator();
    }
  }

  Widget buildStats() {
    return SizedBox(
      height: 1000,
      child: Column(
        // shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.orange[900],
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.orange[900],
            labelStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            controller: tabController,
            tabs: const [
              Text(
                'Products',
              ),
              Text('Orders'),
              Text('Completed Orders')
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [productList(), orderList(false), orderList(true)],
            ),
          )
        ],
      ),
    );
  }

  productList() {
    return SizedBox(
      height: 200,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('restaurantId', isEqualTo: userModel!.restaurantId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
            print('product ');

            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text(
                      'NO PRODUCT YET',
                      style: TextStyle(color: Colors.orange[900], fontSize: 22),
                    ),
                  ),
                );
              }
            }

            return snapshot.hasData
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      print('product ');
                      DocumentSnapshot docSnap = snapshot.data!.docs[index];
                      ProductModel productModel =
                          ProductModel.fromSnapshot(docSnap);
                      return GestureDetector(
                          onTap: () {},
                          child: ProductWidget(product: productModel));
                    },
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  );
          }),
    );
  }

  orderList(bool completedList) {
    return StreamBuilder(
      stream: completedList?
      FirebaseFirestore.instance
          .collection('orders')
          .where('restaurantIds', arrayContains: userModel!.restaurantId)
          .snapshots()
          :FirebaseFirestore.instance
          .collection('orders')
          .where('restaurantIds', arrayContains: userModel!.restaurantId)
      .where('canceled', isEqualTo: false)
      .where('status', isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  'NO ORDER YET',
                  style: TextStyle(color: Colors.orange[900], fontSize: 22),
                ),
              ),
            );
          }
        }
        String restaurantId = userModel!.restaurantId!;
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot docSnap = snapshot.data!.docs[index];
                  OrderModel orderModel = OrderModel.fromSnapshot(docSnap);
                  CartItemModel? cart;
                  for (var element in orderModel.cart!) {
                    if (element['restaurantId'] == restaurantId) {
                      cart = CartItemModel.fromMap(element);
                    }
                  }
                  UserModel? userModel;
                  print(cart!.name);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewBuyer(
                                  cart: cart!,
                                  orderModel: orderModel,
                                  userModel: userModel!, totalAmount: restaurantModel.totalAmount!,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Card(
                        color: Colors.grey[300],
                        child: ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Product name : ' + cart.name!),
                              Text('Price : ' + cart.price.toString())
                            ],
                          ),
                          subtitle: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(orderModel.userId!)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot<dynamic>>
                                    snapshot) {
                              if (snapshot.hasData) {
                                DocumentSnapshot doc = snapshot.data!;
                                userModel = UserModel().fromSnapshot(doc);
                                return Text('Name : ' + userModel!.name!);
                              } else {
                                return const Text('Waiting');
                              }
                            },
                          ),
                          trailing:
                              Text('Quantity : ' + cart.quantity.toString()),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  ///This is used to show post
  showImage({required String tag, required String postImage}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
                child: SizedBox(
                    height: 500,
                    width: MediaQuery.of(context).size.width - 60,
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Hero(
                              tag: tag,
                              child: CachedNetworkImage(
                                imageUrl: postImage,
                              )),
                        )))),
          );
        });
  }

  checkForError() {
    if (image == null) {
      setState(() {
        imageIsValid = true;
      });
      return;
    }
    if (nameController.text.isEmpty) {
      setState(() {
        nameIsValid = true;
      });
      return;
    }
    if (priceController.text.isEmpty) {
      setState(() {
        priceIsValid = true;
      });
      return;
    }
    toggleFields(false);
    uploadToFirestore();
  }

  uploadToFirestore() async {
    try {
      const ID = "id";
      const NAME = "name";
      const AVG_PRICE = "avgPrice";
      const RATING = "rating";
      const RATES = "rates";
      const IMAGE = "image";
      const POPULAR = "popular";
      const USER_LIKES = "userLikes";
      const OWNER = 'owner';
      const OWNERID = 'ownerId';
      String imgUrl = await profileImageUploadFile(image!);

      DateTime dateCreated = DateTime.now();
      int timestamp = dateCreated.millisecondsSinceEpoch;
      FirebaseFirestore.instance
          .collection('restaurants')
          .doc(timestamp.toString())
          .set({
        ID: timestamp.toString(),
        NAME: nameController.text,
        AVG_PRICE: int.tryParse(priceController.text),
        RATING: 0,
        RATES: 0,
        IMAGE: imgUrl,
        POPULAR: false,
        USER_LIKES: [],
        OWNER: userModel!.name,
        OWNERID: userModel!.id,
        'timeStamp': timestamp,
        'dateCreated': dateCreated,
        'totalAmount': 0
      }).then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userModel!.id)
            .update({
          'restaurant': nameController.text,
          'restaurantId': timestamp.toString()
        }).then((value) {
          getUserModel();
          checkRestaurant();
          toggleFields(true);
        });
      }).catchError((e) {
        toggleFields(true);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Restaurant Failed')));
      });
    } catch (e) {
      toggleFields(true);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Restaurant Failed')));
    }
  }

  Future<String> profileImageUploadFile(File _image) async {
    String extension = path.extension(_image.path);
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('Restaurant')
        .child('${userModel!.id}')
        .child('/profileImage.$extension');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }

  toggleFields(bool state) {
    nameFieldActive = state;
    doneButtonActive = state;
    priceFieldActive = state;

    setState(() {});
  }
}
